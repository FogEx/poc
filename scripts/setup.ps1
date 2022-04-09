$env:SECRET_KEY_BASE = New-Guid
$env:DATABASE_URL = "postgresql://postgres:postgres@db:5432/fogex_dev"
$env:EVENT_STORE_URL = "postgresql://postgres:postgres@db:5432/eventstore"
$env:MQTT_HOST = "mqtt_broker"

Write-Output "1. Starting database container"

docker-compose up -d db

Write-Output "2. Creating database and upgrading migrations"

Set-Location .\fogex
mix setup
Set-Location ..

Write-Output "3. Starting the others containers"

docker-compose up -d