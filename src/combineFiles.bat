@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$output = 'combined.out'; ^
Set-Content -Path $output -Value ''; ^
Get-ChildItem -Path . -Recurse -File -Filter *.luau ^| Sort-Object FullName ^| ForEach-Object { ^
Add-Content -Path $output -Value ('-- FILE: ' + $_.FullName); ^
Get-Content $_.FullName ^| Add-Content -Path $output; ^
Add-Content -Path $output -Value \"`n\" ^
}; ^
Write-Host 'Готово!'"