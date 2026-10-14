$ErrorActionPreference = 'Stop'
$port = 9334
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
Start-Process -FilePath $edge -ArgumentList "--headless=new","--disable-gpu","--remote-debugging-port=$port","--user-data-dir=C:\temp\edge-cdp-profile","--no-first-run","file:///C:/Users/Administrator/Desktop/sas/test_edge_v2.html"
$token = $null
try {
  $target = $null
  for ($i=0; $i -lt 30; $i++) {
    Start-Sleep -Milliseconds 500
    try {
      $json = Invoke-RestMethod -Uri "http://127.0.0.1:$port/json" -UseBasicParsing
      $target = $json | Where-Object { $_.url -like "*test_edge_v2*" } | Select-Object -First 1
      if ($target) { break }
    } catch {}
  }
  if (-not $target) { Write-Output "NO_TARGET"; exit 1 }
  Start-Sleep -Seconds 3
  $ws = New-Object System.Net.WebSockets.ClientWebSocket
  $ct = [System.Threading.CancellationToken]::None
  $ws.ConnectAsync([Uri]$target.webSocketDebuggerUrl, $ct).Wait()
  function Send-Cdp($id, $method, $params) {
    $msg = @{ id = $id; method = $method; params = $params } | ConvertTo-Json -Depth 5 -Compress
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($msg)
    $seg = New-Object System.ArraySegment[byte] (,$bytes)
    $ws.SendAsync($seg, [System.Net.WebSockets.WebSocketMessageType]::Text, $true, $ct).Wait()
  }
  function Recv-Cdp {
    $buf = New-Object byte[] 1048576
    $ms = New-Object System.IO.MemoryStream
    while ($true) {
      $seg = New-Object System.ArraySegment[byte] (,$buf)
      $r = $ws.ReceiveAsync($seg, $ct).Result
      $ms.Write($buf, 0, $r.Count)
      if ($r.EndOfMessage) { break }
    }
    [System.Text.Encoding]::UTF8.GetString($ms.ToArray())
  }
  Send-Cdp 1 "Runtime.evaluate" @{ expression = "generateSecMsGecV2()"; returnByValue = $true }
  $resp = Recv-Cdp | ConvertFrom-Json
  $token = $resp.result.result.value
  Write-Output ("TOKEN: " + $token)
  $ws.CloseAsync([System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure, "done", $ct).Wait()
} finally {
  Get-CimInstance Win32_Process -Filter "Name='msedge.exe'" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -match "edge-cdp-profile" } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
}
if (-not $token) { Write-Output "NO_TOKEN"; exit 1 }

# --- Edge TTS WS test (no Origin header, like python edge-tts) ---
$url = "wss://speech.platform.bing.com/consumer/speech/synthesize/readaloud/edge/v1?TrustedClientToken=6A5AA1D4EAFF4E9FB37E23D68491D6F4&Sec-MS-GEC=" + $token + "&Sec-MS-GEC-Version=2-143.0.3650.75"
$tts = New-Object System.Net.WebSockets.ClientWebSocket
$tts.Options.SetRequestHeader("X-SupportLogMalformedChars", "UTF-8")
$tts.Options.KeepAliveInterval = [TimeSpan]::FromSeconds(10)
$cts = New-Object System.Threading.CancellationTokenSource 30000
try {
  $connTask = $tts.ConnectAsync([Uri]$url, $cts.Token)
  if (-not $connTask.Wait(20000)) { Write-Output "CONNECT_TIMEOUT"; exit 1 }
  Write-Output ("CONNECTED state=" + $tts.State)

  function Get-Ts {
    $d = [DateTime]::UtcNow
    $s = $d.ToString("ddd MMM dd yyyy HH:mm:ss", [System.Globalization.CultureInfo]::InvariantCulture)
    $s + " GMT+0000 (Coordinated Universal Time)"
  }
  function Send-Text($text) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
    $seg = New-Object System.ArraySegment[byte] (,$bytes)
    $tts.SendAsync($seg, [System.Net.WebSockets.WebSocketMessageType]::Text, $true, $cts.Token).Wait()
  }
  $reqId = ([guid]::NewGuid().ToString("N"))
  $config = "X-Timestamp:" + (Get-Ts) + "`r`nContent-Type:application/json; charset=utf-8`r`nPath:speech.config`r`n`r`n" +
    '{"context":{"synthesis":{"audio":{"metadataoptions":{"sentenceBoundaryEnabled":"false","wordBoundaryEnabled":"false"},"outputFormat":"audio-24khz-48kbitrate-mono-mp3"}}}}'
  Send-Text $config
  $ssmlBody = "<speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' xml:lang='th-TH'><voice name='th-TH-PremwadeeNeural'><prosody pitch='+0Hz' rate='+0%' volume='+0%'>Hello, this is a test of the Thai voice engine</prosody></voice></speak>"
  $ssml = "X-RequestId:" + $reqId + "`r`nContent-Type:application/ssml+xml`r`nX-Timestamp:" + (Get-Ts) + "Z`r`nPath:ssml`r`n`r`n" + $ssmlBody
  Send-Text $ssml

  $buf = New-Object byte[] 262144
  $audio = New-Object System.IO.MemoryStream
  $turnEnd = $false
  $msgCount = 0
  while (-not $turnEnd -and -not $cts.Token.IsCancellationRequested) {
    $seg = New-Object System.ArraySegment[byte] (,$buf)
    $r = $tts.ReceiveAsync($seg, $cts.Token).Result
    if ($r.MessageType -eq [System.Net.WebSockets.WebSocketMessageType]::Close) {
      Write-Output ("CLOSED " + $tts.CloseStatus)
      break
    }
    $msgCount++
    $data = $buf[0..($r.Count - 1)]
    if ($r.MessageType -eq [System.Net.WebSockets.WebSocketMessageType]::Text) {
      $txt = [System.Text.Encoding]::UTF8.GetString($data)
      if ($txt -match "Path:turn\.end") { $turnEnd = $true; Write-Output "TURN_END" }
      else { Write-Output ("TEXT_MSG(" + $r.Count + "): " + $txt.Substring(0, [Math]::Min(200, $txt.Length))) }
    } else {
      if ($r.Count -ge 2) {
        $hdrLen = ($data[0] -shl 8) -bor $data[1]
        if ($r.Count -gt (2 + $hdrLen)) {
          $payloadLen = $r.Count - 2 - $hdrLen
          $audio.Write($data, 2 + $hdrLen, $payloadLen)
        }
      }
    }
  }
  $audioBytes = $audio.ToArray()
  [System.IO.File]::WriteAllBytes("C:\Users\Administrator\Desktop\sas\test_th.mp3", $audioBytes)
  Write-Output ("MP3_BYTES=" + $audioBytes.Length + " MESSAGES=" + $msgCount)
} catch {
  Write-Output ("WS_FAIL: " + $_.Exception.Message)
  $e = $_.Exception
  while ($e) {
    if ($e -is [System.AggregateException]) { $e = $e.InnerException; continue }
    $detail = $e.Message
    if ($e -is [System.Net.WebSockets.WebSocketException]) { $detail = $detail + " [WSERROR=" + $e.WebSocketErrorCode + "]" }
    if ($e -is [System.Net.HttpWebRequest]) { }
    Write-Output ("  INNER: " + $detail)
    $e = $e.InnerException
  }
}
