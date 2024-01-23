FROM oven/bun

WORKDIR /app

COPY package.json .
COPY bun.lockb .

RUN bun install
# RUN bun install --production
RUN bun prisma generate

COPY src src
COPY node_modules/@prisma node_modules/@prisma
COPY tsconfig.json .
# COPY public public

ENV NODE_ENV production
CMD ["bun", "src/app.ts"]

EXPOSE 3000