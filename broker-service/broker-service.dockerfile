# ---------- Build Stage ----------
FROM golang:1.25.1 AS builder

WORKDIR /app

# Download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build binary
RUN CGO_ENABLED=0 GOOS=linux go build -o broker ./cmd/api

# ---------- Runtime Stage ----------
FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/broker .

EXPOSE 8080

CMD ["./broker"]