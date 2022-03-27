# FogEx

Aplicação Phoenix que irá conter todas as regras do FogEx.

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
$env:DATABASE_URL="postgresql://postgres:postgres@localhost:5432/rockelivery"
$env:EVENT_STORE_URL="postgresql://postgres:postgres@localhost:5432/eventstore"

iex.bat -S mix
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
- Bibliotecas utilizadas
  - [EventStore](https://github.com/commanded/eventstore)
  - [MQTTPotion](https://github.com/brianmay/mqtt_potion)
  - Telemetry
    - [telemetry_poller](https://github.com/beam-telemetry/telemetry_poller)
    - [telemetry_metrics](https://github.com/beam-telemetry/telemetry_metrics)

```powershell
$env:SECRET_KEY_BASE="$(mix phx.gen.secret)"
$env:DATABASE_URL="postgresql://postgres:postgres@localhost:5432/rockelivery"
$env:EVENT_STORE_URL="postgresql://postgres:postgres@localhost:5432/eventstore"
```
