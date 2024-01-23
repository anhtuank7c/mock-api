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

COPY . .

RUN bun install --frozen-lockfile
RUN bunx prisma generate
RUN bunx prisma migrate deploy
RUN ls -la data

# release
FROM oven/bun as release

WORKDIR /app

COPY --from=builder /app/. .
RUN ls -la data

ENV NODE_ENV production
CMD ["bun", "serve"]

EXPOSE 3000