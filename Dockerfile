# builder
FROM debian:11.6-slim as builder

WORKDIR /app

RUN apt update
RUN apt install curl unzip -y
RUN curl https://bun.sh/install | bash

COPY package.json .
COPY bun.lockb .
COPY prisma prisma

RUN /root/.bun/bin/bun install --production
RUN /root/.bun/bin/bunx prisma generate
RUN /root/.bun/bin/bunx prisma migrate

# release
FROM oven/bun as release

WORKDIR /app

COPY --from=builder /app/node_modules node_modules
COPY --from=builder /app/dev.db .

COPY src src
COPY .env .env
COPY tsconfig.json .

ENV NODE_ENV production
CMD ["bun", "serve"]

EXPOSE 3000