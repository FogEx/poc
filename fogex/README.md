# FogEx

Aplicação Phoenix que irá conter todas as regras do FogEx.

## 🔧 Setup

- Instale as dependências com `mix deps.get`;
- Crie e execute as migrations do banco de dados com `mix ecto.setup`.

## 💬 Utilização

- Execute o servidor Phoenix com `mix phx.server`;
- Após a execução, acesse o endereço `http://localhost:4000` através do seu navegador.

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

TO-DO
