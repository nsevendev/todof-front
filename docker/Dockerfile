FROM golang:1.24-bullseye AS base-go
RUN apt-get update && apt-get install -y git curl
RUN go install github.com/air-verse/air@latest
RUN mkdir -p /app/tmp/air
RUN curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-arm64 \
    && chmod +x tailwindcss-linux-arm64 \
    && mv tailwindcss-linux-arm64 /usr/bin/tailwindcss
WORKDIR /app
COPY . .
RUN go mod download
RUN go mod tidy

FROM base-go AS dev-go
WORKDIR /app
CMD ["sh", "-c", "tailwindcss -i ./input.css -o ./static/css/main.css --watch & air -c .air.toml"]