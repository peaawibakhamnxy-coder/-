$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Security

$token = '6A5AA1D4EAFF4E9FB37E23D68491D6F4'
# Sec-MS-GEC: SHA256(ticks rounded down to 5-min) + token, uppercase hex
$ticks = ([DateTimeOffset]::UtcNow.ToUnixTimeSeconds() + 11644473600) * 10000000
$ticks = $ticks - ($ticks % 3000000000)
$sha = [System.Security.Cryptography.SHA256]::Create()
$hash = $sha.ComputeHash([Text.Encoding]::ASCII.GetBytes("$ticks$token"))
$gec = ([BitConverter]::ToString($hash) -replace '-', '').ToUpper()

$connId = [Guid]::NewGuid().ToString().Replace('-', '')
$url = "wss://speech.platform.bing.com/consumer/speech/synthesize/readaloud/edge/v1?TrustedClientToken=$token&Sec-MS-GEC=$gec&Sec-MS-GEC-Version=1-130.0.2849.68&ConnectionId=$connId"

$voice = 'th-TH-PremwadeeNeural'
$text = 'สวัสดีครับ นี่คือการทดสอบเสียงพูดภาษาไทยแบบเสียงเนอรัลคุณภาพสูง อ่านข้อความยาวได้เต็มที่ไม่มีการตัดทอน'

$ws = New-Object System.Net.WebSockets.ClientWebSocket
$cts = New-Object System.Threading.CancellationTokenSource
$cts.Token.Register({ param($s) Write-Host 'cancelled' }) | Out-Null
try { $ws.ConnectAsync([Uri]$url, $cts.Token).Wait() } catch {
    $e = $_.Exception
    while ($e.InnerException) { $e = $e.InnerException }
    Write-Host "CONNECT FAILED: $($e.GetType().Name): $($e.Message)"
    if ($ws.CloseStatus) { Write-Host "CloseStatus: $($ws.CloseStatus) $($ws.CloseStatusDescription)" }
    exit 1
}
Write-Host "Connected state: $($ws.State)"

$config = '{"context":{"synthesis":{"audio":{"metadataoptions":{"sentenceBoundaryEnabled":"false","wordBoundaryEnabled":"false"},"outputFormat":"audio-24khz-48kbitrate-mono-mp3"}}}}'
$msg1 = "X-Timestamp:$(Get-Date -Format 'ddd MMM dd yyyy HH:mm:ss zzz')`r`nContent-Type:application/json; charset=utf-8`r`nPath:speech.config`r`n`r`n$config"
$sb1 = [Text.Encoding]::UTF8.GetBytes($msg1)
$ws.SendAsync([ArraySegment[byte]]::new($sb1), [System.Net.WebSockets.WebSocketMessageType]::Text, $true, $cts.Token).Wait()

$ssml = "<speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' xml:lang='th-TH'><voice name='$voice'><prosody pitch='+0Hz' rate='+0%' volume='+0%'>$text</prosody></voice></speak>"
$reqId = [Guid]::NewGuid().ToString().Replace('-', '')
$msg2 = "X-RequestId:$reqId`r`nContent-Type:application/ssml+xml`r`nX-Timestamp:$(Get-Date -Format 'ddd MMM dd yyyy HH:mm:ss zzz')`r`nPath:ssml`r`n`r`n$ssml"
$sb2 = [Text.Encoding]::UTF8.GetBytes($msg2)
$ws.SendAsync([ArraySegment[byte]]::new($sb2), [System.Net.WebSockets.WebSocketMessageType]::Text, $true, $cts.Token).Wait()

$audio = New-Object System.IO.MemoryStream
$buf = New-Object byte[] 65536
while ($ws.State -eq [System.Net.WebSockets.WebSocketState]::Open) {
    $seg = [ArraySegment[byte]]::new($buf)
    $res = $ws.ReceiveAsync($seg, $cts.Token).Result
    if ($res.MessageType -eq [System.Net.WebSockets.WebSocketMessageType]::Close) { break }
    $payload = $buf[0..([int]$res.Count - 1)]
    if ($res.MessageType -eq [System.Net.WebSockets.WebSocketMessageType]::Binary) {
        if ($payload.Length -gt 2) {
            $hdrLen = [int]$payload[0] * 256 + [int]$payload[1]
            $audio.Write($payload, 2 + $hdrLen, $payload.Length - 2 - $hdrLen)
        }
    } else {
        $txt = [Text.Encoding]::UTF8.GetString($payload)
        if ($txt -match 'Path:turn\.end') { Write-Host 'turn.end received'; break }
        Write-Host "TEXT: $($txt.Substring(0, [Math]::Min(160, $txt.Length)))"
    }
}
$ws.Dispose()
Write-Host "Audio bytes: $($audio.Length)"
if ($audio.Length -gt 0) {
    [IO.File]::WriteAllBytes("$env:TEMP\edge_tts_test.mp3", $audio.ToArray())
    Write-Host "Saved: $env:TEMP\edge_tts_test.mp3"
}
