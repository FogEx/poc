Write-Output "===== Setup  ====="

Write-Output "1. Removing old services"

docker-compose down

Write-Output "2. Building images"

docker-compose build

Write-Output "3. Starting database service"

docker-compose up -d db 

Write-Output "4. Migrating database"

docker-compose run --rm db_migrations

Write-Output "5. Starting the others services"

docker-compose up node_1 node_2 node_3 mqtt_broker -d