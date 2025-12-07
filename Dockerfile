ARG CADDY_VERSION=2.10.2

FROM caddy:${CADDY_VERSION}-builder-alpine AS builder

# 필요한 도구 설치
RUN apk add --no-cache git go ca-certificates binutils

ENV PATH="/root/go/bin:${PATH}"

# xcaddy 설치 (버전 고정 권장)
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
      --with github.com/caddy-dns/cloudflare \
      --with github.com/WeidiDeng/caddy-cloudflare-ip \
      --with github.com/fvbommel/caddy-combine-ip-ranges \
      #--with github.com/fvbommel/caddy-dns-ip-range \
      --with github.com/greenpau/caddy-security \
      --with github.com/porech/caddy-maxmind-geolocation
      # --with github.com/corazawaf/coraza-caddy/v2 \
      # --with github.com/caddyserver/transform-encoder \
      # --with github.com/greenpau/caddy-trace

FROM caddy:${CADDY_VERSION}-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
EXPOSE 80 443/tcp 443/udp
