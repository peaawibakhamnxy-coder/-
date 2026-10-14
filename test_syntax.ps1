$tokens = $null
$errors = $null
[void][System.Management.Automation.Language.Parser]::ParseFile("C:\Users\Administrator\Desktop\sas\OmniReverse.ps1", [ref]$tokens, [ref]$errors)
if ($errors.Count -eq 0) {
    Write-Output "OmniReverse.ps1: SYNTAX OK"
} else {
    Write-Output "OmniReverse.ps1: ERRORS:"
    $errors | ForEach-Object { Write-Output "Line $($_.Extent.StartLineNumber): $($_.Message)" }
}
