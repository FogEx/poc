Set-Location ./fogex

$env:SECRET_KEY_BASE="$(mix phx.gen.secret)"
$env:DATABASE_URL = "postgresql://postgres:postgres@db:5432/fogex_dev"
$env:EVENT_STORE_URL = "postgresql://postgres:postgres@db:5432/eventstore_dev"
$env:MQTT_HOST = "mqtt_broker"

Set-Location ..

Write-Output "1. Removing old containers"

docker-compose down

Write-Output "2. Building images"

docker-compose build

Write-Output "3. Starting database container"

docker-compose up -d db

Write-Output "4. Creating database and upgrading migrations"

Set-Location .\fogex
mix setup
Set-Location ..

Write-Output "5. Starting the others containers"

docker-compose up -d