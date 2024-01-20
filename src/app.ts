import { Elysia } from 'elysia';
import { swagger } from '@elysiajs/swagger';
import { v1 } from './routes/v1/v1';
import packageJson from '../package.json';
import cors from '@elysiajs/cors';

const app = new Elysia()
	.use(cors())
	.use(
		swagger({
			documentation: {
				info: {
					title: packageJson.name,
					description: packageJson.description,
					version: packageJson.version,
				},
			},
		})
	)
	.use(v1)
	.listen(process.env.PORT || 3000);

console.log(`Elysia is running at ${app.server?.hostname}:${app.server?.port}`);

export type api = typeof app;
