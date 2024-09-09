# Build stage
FROM golang:1.19-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Final stage
FROM alpine:3.14

WORKDIR /app

COPY --from=builder /app/main .
COPY views/ ./views/

EXPOSE 8080

CMD ["./main"]
