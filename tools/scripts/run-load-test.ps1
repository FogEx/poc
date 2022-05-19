# & .\tools\scripts\setup.ps1

Write-Output "===== Running load test  ====="

Set-Location .\load_test

Write-Output "1. Compiling load test"

yarn build

Write-Output "2. Running load test"

Write-Output "Started at: $(Get-Date)"
./k6 run --vus 10 --iterations 10000 build/app.bundle.js
Write-Output "Ended at: $(Get-Date)"

Set-Location ..