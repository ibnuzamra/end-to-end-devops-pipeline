# Multi-stage Dockerfile for Golang microservices
FROM golang:1.22-alpine AS builder

WORKDIR /app
RUN apk add --no-cache git ca-certificates tzdata
COPY go.mod go.sum* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o server .

FROM alpine:3.20
RUN apk --no-cache add ca-certificates tzdata
ENV TZ="Asia/Jakarta"
WORKDIR /app
COPY --from=builder /app/server .
EXPOSE 8080
USER 10001:10001
ENTRYPOINT ["/app/server"]
