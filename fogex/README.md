# FogEx

Aplicação desenvolvida em Elixir que irá conter todas as regras do FogEx.

## 🔧 Setup

- Instale as dependências com `mix deps.get`;
- Crie e execute as migrations do banco de dados com `mix ecto.setup`.

## 💬 Utilização

Executando o servidor Phoenix:

- Execute o servidor Phoenix com `mix phx.server`;
- Após a execução, acesse o endereço `http://localhost:4000` através do seu navegador.

Executando através do IEx:

```powershell
iex.bat -S mix
```

Executando com uma configuração diferente (produção):

```powershell
# Definindo as variáveis de ambiente
$env:SECRET_KEY_BASE="$(mix phx.gen.secret)"
$env:DATABASE_URL="postgresql://postgres:postgres@localhost:5432/fogex_dev"
$env:EVENT_STORE_URL="postgresql://postgres:postgres@localhost:5432/eventstore"

iex.bat -S mix
```

## 🐋 Docker

- Buildando a imagem:

```powershell
docker build -t fogex .
```

- Executando:

```powershell
$env:SECRET_KEY_BASE="$(mix phx.gen.secret)"
$env:DATABASE_URL="postgresql://postgres:postgres@localhost:5432/fogex_dev"
$env:EVENT_STORE_URL="postgresql://postgres:postgres@localhost:5432/eventstore"
$env:MQTT_HOST="mqtt_broker"

docker run --rm -it -e "DATABASE_URL=$env:DATABASE_URL" -e "EVENT_STORE_URL=$env:EVENT_STORE_URL" -e "SECRET_KEY_BASE=$env:SECRET_KEY_BASE" -e "MQTT_HOST=$env:MQTT_HOST" fogex
```

## 💾 Banco de dados

- Para executar o container do PostgreSQL, execute:

  ```powershell
  docker run -d --rm --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres
  ```

## 💡 Exemplos

### Exemplo de evento de sinal vital

- Tópico: `vital_signs/{user_id}`
- Conteúdo:

  ```json
  {
    "type": "body_temperature",
    "data": {
      "temperature": 33
    },
    "user_id": "1234"
  }
  ```

## 📌 Referências

- [Replacing GenEvent by a Supervisor + GenServer](http://blog.plataformatec.com.br/2016/11/replacing-genevent-by-a-supervisor-genserver/)
- [Three real-world examples of distributed Elixir](https://bigardone.dev/blog/2021/05/22/three-real-world-examples-of-distributed-elixir-pt-1)
- [Elixir School: Poolboy](https://elixirschool.com/en/lessons/misc/poolboy)
- Bibliotecas utilizadas
  - [EventStore](https://github.com/commanded/eventstore)
  - [MQTTPotion](https://github.com/brianmay/mqtt_potion)
  - Telemetry
    - [telemetry_poller](https://github.com/beam-telemetry/telemetry_poller)
    - [telemetry_metrics](https://github.com/beam-telemetry/telemetry_metrics)
  - [libcluster](https://github.com/bitwalker/libcluster)
  - [swarm](https://github.com/bitwalker/swarm)
