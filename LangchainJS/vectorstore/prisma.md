[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/prisma/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Prisma

For augmenting existing models in PostgreSQL database with vector search, Langchain supports using [Prisma](https://www.prisma.io/) together with PostgreSQL and [`pgvector`](https://github.com/pgvector/pgvector) Postgres extension.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/prisma/\#setup "Direct link to Setup")

### Setup database instance with Supabase [​](https://js.langchain.com/docs/integrations/vectorstores/prisma/\#setup-database-instance-with-supabase "Direct link to Setup database instance with Supabase")

Refer to the [Prisma and Supabase integration guide](https://supabase.com/docs/guides/integrations/prisma) to setup a new database instance with Supabase and Prisma.

### Install Prisma [​](https://js.langchain.com/docs/integrations/vectorstores/prisma/\#install-prisma "Direct link to Install Prisma")

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install prisma

```

```codeBlockLines_AdAo
yarn add prisma

```

```codeBlockLines_AdAo
pnpm add prisma

```

### Setup `pgvector` self hosted instance with `docker-compose` [​](https://js.langchain.com/docs/integrations/vectorstores/prisma/\#setup-pgvector-self-hosted-instance-with-docker-compose "Direct link to setup-pgvector-self-hosted-instance-with-docker-compose")

`pgvector` provides a prebuilt Docker image that can be used to quickly setup a self-hosted Postgres instance.

```codeBlockLines_AdAo
services:
  db:
    image: ankane/pgvector
    ports:
      - 5432:5432
    volumes:
      - db:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=
      - POSTGRES_USER=
      - POSTGRES_DB=

volumes:
  db:

```

### Create a new schema [​](https://js.langchain.com/docs/integrations/vectorstores/prisma/\#create-a-new-schema "Direct link to Create a new schema")

Assuming you haven't created a schema yet, create a new model with a `vector` field of type `Unsupported("vector")`:

```codeBlockLines_AdAo
model Document {
  id      String                 @id @default(cuid())
  content String
  vector  Unsupported("vector")?
}

```

Afterwards, create a new migration with `--create-only` to avoid running the migration directly.

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npx prisma migrate dev --create-only

```

```codeBlockLines_AdAo
npx prisma migrate dev --create-only

```

```codeBlockLines_AdAo
npx prisma migrate dev --create-only

```

Add the following line to the newly created migration to enable `pgvector` extension if it hasn't been enabled yet:

```codeBlockLines_AdAo
CREATE EXTENSION IF NOT EXISTS vector;

```

Run the migration afterwards:

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npx prisma migrate dev

```

```codeBlockLines_AdAo
npx prisma migrate dev

```

```codeBlockLines_AdAo
npx prisma migrate dev

```

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/prisma/\#usage "Direct link to Usage")

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @langchain/openai @langchain/community @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/openai @langchain/community @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/openai @langchain/community @langchain/core

```

danger

Table names and column names (in fields such as `tableName`, `vectorColumnName`, `columns` and `filter`) are passed into SQL queries directly without parametrisation.
These fields must be sanitized beforehand to avoid SQL injection.

```codeBlockLines_AdAo
import { PrismaVectorStore } from "@langchain/community/vectorstores/prisma";
import { OpenAIEmbeddings } from "@langchain/openai";
import { PrismaClient, Prisma, Document } from "@prisma/client";

export const run = async () => {
  const db = new PrismaClient();

  // Use the `withModel` method to get proper type hints for `metadata` field:
  const vectorStore = PrismaVectorStore.withModel<Document>(db).create(
    new OpenAIEmbeddings(),
    {
      prisma: Prisma,
      tableName: "Document",
      vectorColumnName: "vector",
      columns: {
        id: PrismaVectorStore.IdColumn,
        content: PrismaVectorStore.ContentColumn,
      },
    }
  );

  const texts = ["Hello world", "Bye bye", "What's this?"];
  await vectorStore.addModels(
    await db.$transaction(
      texts.map((content) => db.document.create({ data: { content } }))
    )
  );

  const resultOne = await vectorStore.similaritySearch("Hello world", 1);
  console.log(resultOne);

  // create an instance with default filter
  const vectorStore2 = PrismaVectorStore.withModel<Document>(db).create(
    new OpenAIEmbeddings(),
    {
      prisma: Prisma,
      tableName: "Document",
      vectorColumnName: "vector",
      columns: {
        id: PrismaVectorStore.IdColumn,
        content: PrismaVectorStore.ContentColumn,
      },
      filter: {
        content: {
          equals: "default",
        },
      },
    }
  );

  await vectorStore2.addModels(
    await db.$transaction(
      texts.map((content) => db.document.create({ data: { content } }))
    )
  );

  // Use the default filter a.k.a {"content": "default"}
  const resultTwo = await vectorStore.similaritySearch("Hello world", 1);
  console.log(resultTwo);
};

```

#### API Reference:

- PrismaVectorStorefrom `@langchain/community/vectorstores/prisma`
- OpenAIEmbeddingsfrom `@langchain/openai`

The following SQL operators are available as filters: `equals`, `in`, `isNull`, `isNotNull`, `like`, `lt`, `lte`, `gt`, `gte`, `not`.

The samples above uses the following schema:

```codeBlockLines_AdAo
// This is your Prisma schema file,
// learn more about it in the docs: https://pris.ly/d/prisma-schema

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model Document {
  id        String                 @id @default(cuid())
  content   String
  namespace String?                @default("default")
  vector    Unsupported("vector")?
}

```

#### API Reference:

You can remove `namespace` if you don't need it.

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/prisma/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/prisma/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/prisma/#setup)
  - [Setup database instance with Supabase](https://js.langchain.com/docs/integrations/vectorstores/prisma/#setup-database-instance-with-supabase)
  - [Install Prisma](https://js.langchain.com/docs/integrations/vectorstores/prisma/#install-prisma)
  - [Setup `pgvector` self hosted instance with `docker-compose`](https://js.langchain.com/docs/integrations/vectorstores/prisma/#setup-pgvector-self-hosted-instance-with-docker-compose)
  - [Create a new schema](https://js.langchain.com/docs/integrations/vectorstores/prisma/#create-a-new-schema)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/prisma/#usage)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/prisma/#related)