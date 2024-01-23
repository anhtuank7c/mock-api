# builder
FROM oven/bun as builder

WORKDIR /app

# Install nodejs using n
ARG NODE_VERSION=20
RUN apt update \
    && apt install -y curl
RUN curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n \
    && bash n $NODE_VERSION \
    && rm n \
    && npm install -g n

COPY package.json .
COPY bun.lockb .
COPY prisma prisma
COPY .env .env

RUN bun install --frozen-lockfile
RUN npx prisma generate
RUN npx prisma migrate deploy
RUN ls -la

# release
FROM oven/bun as release

WORKDIR /app

COPY --from=builder /app/node_modules node_modules
COPY --from=builder /app/dev.db .

COPY src src
COPY tsconfig.json .
COPY .env .env
COPY package.json .

ENV NODE_ENV production
CMD ["bun", "serve"]

EXPOSE 3000