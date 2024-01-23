FROM oven/bun

WORKDIR /app

COPY prisma ./prisma/
COPY package.json .
COPY bun.lockb .

# RUN bun install
RUN bun install --production
RUN bunx prisma generate

COPY src src
COPY tsconfig.json .
# COPY public public

ENV NODE_ENV production
CMD ["bun", "src/app.ts"]

EXPOSE 3000