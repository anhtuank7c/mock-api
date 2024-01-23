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

COPY --from=builder /app/src ./
COPY --from=builder /app/tsconfig.json .
COPY --from=builder /app/package.json .
COPY --from=builder /app/.env .
COPY --from=builder /app/node_modules/@prisma ./node_modules/@prisma

# COPY public public

ENV NODE_ENV production
CMD ["bun", "src/app.ts"]

EXPOSE 3000