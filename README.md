# README

This is a Proof of Concept Rails project using Graphql. This was mainly created for these blog posts:

- [GraphQL Way - Rails Edition]
- [GraphQL Way - Limited Edition]

# Main Features

- Ruby on Rails setup with GraphQL
- DataLoaders for fetching data in batch
  - BelongsToLoader
  - HasManyLoader (works for has_many through relations as well)
- All main models are connected
- All main models are exposed as root query
- In any level of a GraphQL request (query), you can:
  - Filter
  - Sort
  - Paginate
- RSpec tests for the GraphQL requests

# Data Models

This app has a very limited version of a regular e-commerce data modeling with:

- Category
- Product
- Order
- User

This simple data model will work as a common base for this Proof of Concept.

# Development

This is a regular Rails app, so you can just:

```shell
rails db:create db:migrate db:seed
rails server
```

Then you can use your prefered GraphQL tool pointed to: http://localhost:3000/graphql

You can also use the built in [GrapiQL]

[GraphQL Way - Rails Edition]: https://hashrocket.com/blog/posts/graphql-way-rails-edition
[GraphQL Way - Limited Edition]: https://hashrocket.com/blog/posts/graphql-way-limited-edition
[GrapiQL]: http://localhost:3000/graphiql
