FROM oven/bun

WORKDIR /app

COPY package.json .
COPY bun.lockb .
COPY prisma prisma

RUN bun install --production
RUN bunx prisma generate

COPY src src
COPY .env .env
COPY tsconfig.json .
# COPY public public

ENV NODE_ENV production
CMD ["bun", "src/app.ts"]

EXPOSE 3000