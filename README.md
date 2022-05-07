# Prova de conceito do FogEx

Prova de conceito de meu projeto de trabalho de conclusão de curso da graduação de Sistemas de Informação da Unisinos denominado de FogEx.

## 📝 Índice

- [MQTT Broker](mqtt_broker/README.md)
- [FogEx](fogex/README.md)
- [Teste de carga](load_test/README.md)

## 🐋 Compose

- Buildando as imagens:

```powershell
docker-compose build
```

- Executando:

```powershell
$env:SECRET_KEY_BASE="$(mix phx.gen.secret)"
$env:DATABASE_URL="postgresql://postgres:postgres@db:5432/fogex_dev"
$env:EVENT_STORE_URL="postgresql://postgres:postgres@db:5432/eventstore"

# ou adicione essas variáveis num arquivo .env

docker-compose up -d
```

## 📄 Licença

- [MIT](/LICENSE)
