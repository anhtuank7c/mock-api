# builder
FROM oven/bun as builder

# create app directory
WORKDIR /app

COPY prisma ./prisma/
COPY package.json .
COPY bun.lockb .

RUN bun install --production
# generate prisma client
RUN bunx prisma generate

COPY . .

# release
FROM oven/bun as release
WORKDIR /app

COPY --from=builder /app/src /app/src
COPY --from=builder /app/tsconfig.json /app
COPY --from=builder /app/package.json /app
COPY --from=builder /app/.env /app
COPY --from=builder /app/node_modules /app/node_modules

# COPY public public

ENV NODE_ENV production
CMD ["bun", "src/app.ts"]

EXPOSE 3000