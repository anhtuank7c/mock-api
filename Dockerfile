# builder
FROM ubuntu:jammy as builder

WORKDIR /app

ENV BUN_INSTALL="/root/.bun"

RUN apt update
RUN apt install curl unzip -y
RUN curl https://bun.sh/install | bash
RUN ln -s $BUN_INSTALL/bin/bun /usr/local/bin/bun

COPY package.json .
COPY bun.lockb .
COPY prisma prisma

RUN bun install
RUN bun prisma migrate

RUN ls -la

# release
FROM oven/bun as release

WORKDIR /app

COPY --from=builder /app/node_modules node_modules

COPY src src
COPY .env .env
COPY tsconfig.json .
COPY package.json .

ENV NODE_ENV production
CMD ["bun", "serve"]

EXPOSE 3000