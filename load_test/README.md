# Testes de carga

## 🔧 Setup

- Instalar [Go](https://go.dev/doc/install) e [Git](https://git-scm.com)
- Instalar [xk6](https://k6.io/docs/extensions/guides/build-a-k6-binary-with-extensions)

  ```powershell
  go install go.k6.io/xk6/cmd/xk6@latest
  ```

- Buildar o k6 com o plugin [xk6-mqtt](https://github.com/pmalhaire/xk6-mqtt)

  ```powershell
  xk6 build --with github.com/pmalhaire/xk6-mqtt@latest
  ```

## 💬 Utilização

- Instalar dependências

```powershell
yarn install
```

- Buildar testes

```powershell
yarn run build
```

- Executando

  - Apenas uma única vez

  ```powershell
  # com executável local do k6
  ./k6 run build/app.bundle.js

  # utilizando Docker (necessário buildar a imagem)
  docker run -v ${pwd}/build:/build k6 run /build/app.bundle.js
  ```

  - Multiplas VUs (`virtual users`) e durante um intervalo de tempo (`duration`)

  ```powershell
  ./k6 run --vus 10 --duration 30s build/app.bundle.js

  # ou
   docker run -v ${pwd}/build:/build k6 run --vus 10 --duration 30s /build/app.bundle.js
  ```

## 🐋 Docker

Buildando imagem:

```powershell
docker build -t k6 .
```

## 📌 Referências

- [K6 Template ES6](https://github.com/grafana/k6-template-es6)
