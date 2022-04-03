FROM golang:1.17-alpine as builder

WORKDIR /app

RUN apk --no-cache add git

RUN go install go.k6.io/xk6/cmd/xk6@latest

RUN xk6 build v0.37.0 --with github.com/pmalhaire/xk6-mqtt

FROM alpine:3.15

RUN apk add --no-cache ca-certificates && \
  adduser -D k6

COPY --from=builder /app/k6 /usr/bin/k6

USER k6

WORKDIR /home/k6

ENTRYPOINT ["k6"]
