# MQTT Broker

Nesta POC foi utilizado o broker MQTT chamado Mosquitto.

## 🦟 Mosquitto

O Eclipse Mosquitto é um message broker de software livre (licenciado por EPL/EDL) que implementa o protocolo MQTT nas versões 5.0, 3.1.1 e 3.1.

## 💬 Utilização

- Executando o broker através de um container Docker:

  ```powershell
  docker run --rm -d -p 1883:1883 -p 9001:9001 -v "${PWD}/config/:/mosquitto/config/" eclipse-mosquitto
  ```

## 📌 Referências

- [Eclipse Mosquitto](https://www.eclipse.org/mosquitto)
- [Mosquitto - Docker Hub](https://hub.docker.com/_/eclipse-mosquitto)
