$ErrorActionPreference = 'Stop'
$port = 9333
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
Start-Process -FilePath $edge -ArgumentList "--headless=new","--disable-gpu","--remote-debugging-port=$port","--user-data-dir=C:\temp\edge-cdp-profile","--no-first-run","file:///C:/Users/Administrator/Desktop/sas/test_edge_v2.html"
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

  Send-Cdp 1 "Runtime.evaluate" @{ expression = "document.title"; returnByValue = $true }
  $null = Recv-Cdp

  for ($i=0; $i -lt 40; $i++) {
    Start-Sleep -Seconds 2
    Send-Cdp 2 "Runtime.evaluate" @{ expression = "document.getElementById('out').innerText + '|' + document.title"; returnByValue = $true }
    $resp = Recv-Cdp | ConvertFrom-Json
    $val = $resp.result.result.value
    Write-Output ("POLL{0}: {1}" -f $i, ($val -replace "`n"," || "))
    if ($val -match "RESULT:") { break }
  }
  $ws.CloseAsync([System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure, "done", $ct).Wait()
} finally {
  Get-Process msedge -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -match "edge-cdp-profile" } | Stop-Process -Force -ErrorAction SilentlyContinue
  Get-CimInstance Win32_Process -Filter "Name='msedge.exe'" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -match "edge-cdp-profile" } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
}
