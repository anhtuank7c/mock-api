import { Elysia, t } from 'elysia';
import { Prisma, PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()

export const todos = new Elysia({ prefix: '/todos' })
	// get all
	.get('/', async ({ query }) => {
		const sortFields = query.sort?.split(',').map(field => field.trim())
		let where: Prisma.TodoWhereInput = {}
		if (query.completed === 1) {
			where = {
				completedAt: {
					gte: new Date()
				}
			}
		} else if (query.completed === 0) {
			where = {
				completedAt: null
			}
		}
		const orderBy: Prisma.TodoOrderByWithRelationInput[] = []
		enum FieldName {
			id,
			title,
			createdAt,
			completedAt,
		}
		sortFields?.forEach(field => {
			const [fieldName, direction] = field.split(' ').map(text => text.trim())
			if (fieldName in FieldName) {
				orderBy.push({
					[fieldName]: ['asc', 'desc'].includes(direction) ? direction : 'asc'
				})
			}
		})
		const [total, data] = await Promise.all([
			prisma.todo.count({
				where
			}),
			prisma.todo.findMany({
				where,
				skip: query.skip,
				take: query.take,
				orderBy,
			})
		])

		return {
			total,
			data
		}
	}, {
		query: t.Partial(
			t.Object({
				completed: t.Numeric(),
				take: t.Numeric({ default: 10 }),
				skip: t.Numeric({ default: 0 }),
				sort: t.String() // sort=createdAt asc, id desc, title desc
			})
		),
	})

	// get one
	.get('/:id', (ctx) => {
		return prisma.todo.findFirstOrThrow({
			where: {
				id: ctx.params.id
			}
		})
	}, {
		params: t.Object({
			id: t.Numeric()
		})
	})

	// add one
	.post(
		'/',
		(ctx) => {
			return prisma.todo.create({
				data: ctx.body
			})
		},
		{
			body: t.Object({
				title: t.String()
			})
		}
	)

	// update one
	.patch(
		'/:id',
		(ctx) => {
			return prisma.todo.update({
				where: {
					id: ctx.params.id
				},
				data: ctx.body
			})
		},
		{
			params: t.Object({
				id: t.Numeric()
			}),
			body: t.Object({
				title: t.String(),
				completedAt: t.Optional(t.String()) // ISO 8601: YYYY-MM-DDThh:mm:ssTZD 2024-01-20T10:26:30.708Z
			})
		}
	)

	// delete one
	.delete('/:id', (ctx) => {
		return prisma.todo.delete({ where: { id: ctx.params.id } })
	}, {
		params: t.Object({
			id: t.Numeric()
		})
	});
