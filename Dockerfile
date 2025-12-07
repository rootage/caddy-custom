ARG CADDY_VERSION=2.10.2

FROM caddy:${CADDY_VERSION}-builder-alpine AS builder
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
      --with github.com/caddy-dns/cloudflare \
      --with github.com/WeidiDeng/caddy-cloudflare-ip \
      --with github.com/fvbommel/caddy-combine-ip-ranges \
      --with github.com/greenpau/caddy-security \
      --with github.com/porech/caddy-maxmind-geolocation \
      # --with github.com/corazawaf/coraza-caddy/v2 \
      # --with github.com/caddyserver/transform-encoder \
      # --with github.com/greenpau/caddy-trace \
      --ldflags="-s -w"

FROM caddy:${CADDY_VERSION}-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
EXPOSE 80 443/tcp 443/udp
