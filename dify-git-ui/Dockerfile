# syntax=docker/dockerfile:1.7

########## BUILD ##########
FROM node:20.14-alpine AS builder
RUN apk add --no-cache git python3 make g++ libc6-compat
RUN npm i -g pnpm@10.16.0

ARG DIFY_TAG=1.9.1
WORKDIR /src
RUN git clone --depth 1 --branch ${DIFY_TAG} https://github.com/langgenius/dify.git dify
WORKDIR /src/dify/web

# Key fix: production env + disable Husky
ENV NODE_ENV=production HUSKY=0

RUN --mount=type=cache,id=pnpm-store,target=/root/.local/share/pnpm/store/v3 \
    pnpm fetch --frozen-lockfile && pnpm install --offline

RUN pnpm build && pnpm prune --prod

########## RUNTIME ##########
FROM node:20.14-alpine AS runtime
RUN addgroup -g 10001 app && adduser -D -u 10001 -G app app
WORKDIR /opt/app
RUN mkdir -p /temp && chown -R app:app /temp

COPY --from=builder /src/dify/web/.next ./.next
COPY --from=builder /src/dify/web/node_modules ./node_modules
COPY --from=builder /src/dify/web/public ./public
COPY --from=builder /src/dify/web/package.json ./package.json

ENV PORT=8080 NODE_ENV=production NEXT_TELEMETRY_DISABLED=1 \
    TMPDIR=/temp XDG_CACHE_HOME=/temp/.cache HOME=/temp

EXPOSE 8080
USER 10001:10001
CMD ["node","node_modules/next/dist/bin/next","start","-p","8080","-H","0.0.0.0"]
