$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$batPath = Join-Path $scriptDir "Launch-OmniReverse.bat"
$desktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
if (-not $desktopPath) {
    $desktopPath = Join-Path $env:USERPROFILE "Desktop"
}
$shortcutPath = Join-Path $desktopPath "OmniReverse OSINT.lnk"

try {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $batPath
    $Shortcut.WorkingDirectory = $scriptDir
    $Shortcut.Description = "OmniReverse - Cross-Platform Reverse Image Search & OSINT Hub"
    $Shortcut.Save()
    Write-Output "Shortcut created successfully on Desktop: $shortcutPath"
} catch {
    Write-Output "Note: You can launch directly using: $batPath"
}
