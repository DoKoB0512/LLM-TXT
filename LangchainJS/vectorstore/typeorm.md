[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/typeorm/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# TypeORM

To enable vector search in a generic PostgreSQL database, LangChain.js supports using [TypeORM](https://typeorm.io/) with the [`pgvector`](https://github.com/pgvector/pgvector) Postgres extension.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/typeorm/\#setup "Direct link to Setup")

To work with TypeORM, you need to install the `typeorm` and `pg` packages:

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install typeorm

```

```codeBlockLines_AdAo
yarn add typeorm

```

```codeBlockLines_AdAo
pnpm add typeorm

```

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install pg

```

```codeBlockLines_AdAo
yarn add pg

```

```codeBlockLines_AdAo
pnpm add pg

```

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

### Setup a `pgvector` self hosted instance with `docker-compose` [​](https://js.langchain.com/docs/integrations/vectorstores/typeorm/\#setup-a-pgvector-self-hosted-instance-with-docker-compose "Direct link to setup-a-pgvector-self-hosted-instance-with-docker-compose")

`pgvector` provides a prebuilt Docker image that can be used to quickly setup a self-hosted Postgres instance.
Create a file below named `docker-compose.yml`:

```codeBlockLines_AdAo
export default {services:{db:{image:'ankane/pgvector',ports:['5432:5432'],volumes:['./data:/var/lib/postgresql/data'],environment:['POSTGRES_PASSWORD=ChangeMe','POSTGRES_USER=myuser','POSTGRES_DB=api']}}};

```

#### API Reference:

And then in the same directory, run `docker compose up` to start the container.

You can find more information on how to setup `pgvector` in the [official repository](https://github.com/pgvector/pgvector).

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/typeorm/\#usage "Direct link to Usage")

One complete example of using `TypeORMVectorStore` is the following:

```codeBlockLines_AdAo
import { DataSourceOptions } from "typeorm";
import { OpenAIEmbeddings } from "@langchain/openai";
import { TypeORMVectorStore } from "@langchain/community/vectorstores/typeorm";

// First, follow set-up instructions at
// https://js.langchain.com/docs/modules/indexes/vector_stores/integrations/typeorm

export const run = async () => {
  const args = {
    postgresConnectionOptions: {
      type: "postgres",
      host: "localhost",
      port: 5432,
      username: "myuser",
      password: "ChangeMe",
      database: "api",
    } as DataSourceOptions,
  };

  const typeormVectorStore = await TypeORMVectorStore.fromDataSource(
    new OpenAIEmbeddings(),
    args
  );

  await typeormVectorStore.ensureTableInDatabase();

  await typeormVectorStore.addDocuments([\
    { pageContent: "what's this", metadata: { a: 2 } },\
    { pageContent: "Cat drinks milk", metadata: { a: 1 } },\
  ]);

  const results = await typeormVectorStore.similaritySearch("hello", 2);

  console.log(results);
};

```

#### API Reference:

- OpenAIEmbeddingsfrom `@langchain/openai`
- TypeORMVectorStorefrom `@langchain/community/vectorstores/typeorm`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/typeorm/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/typeorm/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/typeorm/#setup)
  - [Setup a `pgvector` self hosted instance with `docker-compose`](https://js.langchain.com/docs/integrations/vectorstores/typeorm/#setup-a-pgvector-self-hosted-instance-with-docker-compose)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/typeorm/#usage)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/typeorm/#related)