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
RUN bunx prisma generate
# RUN bunx prisma migrate deploy

# release
FROM oven/bun as release

WORKDIR /app

COPY --from=builder /app/node_modules node_modules

COPY src src
COPY tsconfig.json .
COPY .env .env
COPY package.json .

RUN bunx prisma migrate deploy

ENV NODE_ENV production
CMD ["bun", "serve"]

EXPOSE 3000