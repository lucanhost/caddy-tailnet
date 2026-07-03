FROM golang:1.26.3-alpine AS builder

RUN apk add --no-cache git

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /caddy-tailnet ./cmd/caddy-tailnet

FROM alpine:3.20

RUN apk add --no-cache ca-certificates tzdata && \
    adduser -D -H -s /sbin/nologin caddy-tailnet

COPY --from=builder /caddy-tailnet /usr/bin/caddy-tailnet

RUN mkdir -p /data/tsnet_state /etc/caddy-tailnet && \
    chown -R caddy-tailnet:caddy-tailnet /data/tsnet_state

EXPOSE 80 443 2019

VOLUME ["/data/tsnet_state"]

USER caddy-tailnet

ENTRYPOINT ["caddy-tailnet"]
CMD ["run", "--config", "/etc/caddy-tailnet/Caddyfile"]