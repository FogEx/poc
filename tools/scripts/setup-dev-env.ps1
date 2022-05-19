Write-Output "===== Setup (development)  ====="

Write-Output "1. Starting services"

docker-compose up mqtt_broker db db_migrations -d