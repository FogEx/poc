Set-Location .\load_test

Write-Output "1. Compiling load test"

yarn build

Write-Output "2. Running load test"

./k6 run --vus 10 --duration 30s --iterations 10000 build/app.bundle.js

Set-Location ..