# mock-api with Bun runtime

Super fast Mock API with Bun, Bun:Sqlite, ElysiaJS

## Required

* [bun](https://github.com/oven-sh/bun#install)

## Getting Started

* Clone this repo: `git clone https://github.com/anhtuank7c/mock-api.git`
* Install deps: `cd mock-api && bun install`
* Migrate DB and generate prisma client: `bunx prisma migrate dev --name init && bunx prisma generate`

```bash
bun dev
```

Open <http://localhost:3000/swagger> with your browser to see the documentation.  

## Deployment

Checkout [ElysiaJS website](https://elysiajs.com/integrations/docker.html).
