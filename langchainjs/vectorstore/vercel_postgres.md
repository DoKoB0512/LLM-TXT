[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/vercel_postgres/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Vercel Postgres

LangChain.js supports using the [`@vercel/postgres`](https://www.npmjs.com/package/@vercel/postgres) package to use generic Postgres databases
as vector stores, provided they support the [`pgvector`](https://github.com/pgvector/pgvector) Postgres extension.

This integration is particularly useful from web environments like Edge functions.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/vercel_postgres/\#setup "Direct link to Setup")

To work with Vercel Postgres, you need to install the `@vercel/postgres` package:

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @vercel/postgres

```

```codeBlockLines_AdAo
yarn add @vercel/postgres

```

```codeBlockLines_AdAo
pnpm add @vercel/postgres

```

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @langchain/community @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/community @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/community @langchain/core

```

This integration automatically connects using the connection string set under `process.env.POSTGRES_URL`.
You can also pass a connection string manually like this:

```codeBlockLines_AdAo
const vectorstore = await VercelPostgres.initialize(new OpenAIEmbeddings(), {
  postgresConnectionOptions: {
    connectionString:
      "postgres://<username>:<password>@<hostname>:<port>/<dbname>",
  },
});

```

### Connecting to Vercel Postgres [​](https://js.langchain.com/docs/integrations/vectorstores/vercel_postgres/\#connecting-to-vercel-postgres "Direct link to Connecting to Vercel Postgres")

A simple way to get started is to create a serverless [Vercel Postgres instance](https://vercel.com/docs/storage/vercel-postgres/quickstart).
If you're deploying to a Vercel project with an associated Vercel Postgres instance, the required `POSTGRES_URL` environment variable
will already be populated in hosted environments.

### Connecting to other databases [​](https://js.langchain.com/docs/integrations/vectorstores/vercel_postgres/\#connecting-to-other-databases "Direct link to Connecting to other databases")

If you prefer to host your own Postgres instance, you can use a similar flow to LangChain's [PGVector](https://js.langchain.com/docs/integrations/vectorstores/pgvector)
vectorstore integration and set the connection string either as an environment variable or as shown above.

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/vercel_postgres/\#usage "Direct link to Usage")

```codeBlockLines_AdAo
import { CohereEmbeddings } from "@langchain/cohere";
import { VercelPostgres } from "@langchain/community/vectorstores/vercel_postgres";

// Config is only required if you want to override default values.
const config = {
  // tableName: "testvercelvectorstorelangchain",
  // postgresConnectionOptions: {
  //   connectionString: "postgres://<username>:<password>@<hostname>:<port>/<dbname>",
  // },
  // columns: {
  //   idColumnName: "id",
  //   vectorColumnName: "vector",
  //   contentColumnName: "content",
  //   metadataColumnName: "metadata",
  // },
};

const vercelPostgresStore = await VercelPostgres.initialize(
  new CohereEmbeddings({ model: "embed-english-v3.0" }),
  config
);

const docHello = {
  pageContent: "hello",
  metadata: { topic: "nonsense" },
};
const docHi = { pageContent: "hi", metadata: { topic: "nonsense" } };
const docMitochondria = {
  pageContent: "Mitochondria is the powerhouse of the cell",
  metadata: { topic: "science" },
};

const ids = await vercelPostgresStore.addDocuments([\
  docHello,\
  docHi,\
  docMitochondria,\
]);

const results = await vercelPostgresStore.similaritySearch("hello", 2);
console.log(results);
/*
  [\
    Document { pageContent: 'hello', metadata: { topic: 'nonsense' } },\
    Document { pageContent: 'hi', metadata: { topic: 'nonsense' } }\
  ]
*/

// Metadata filtering
const results2 = await vercelPostgresStore.similaritySearch(
  "Irrelevant query, metadata filtering",
  2,
  {
    topic: "science",
  }
);
console.log(results2);
/*
  [\
    Document {\
      pageContent: 'Mitochondria is the powerhouse of the cell',\
      metadata: { topic: 'science' }\
    }\
  ]
*/

// Metadata filtering with IN-filters works as well
const results3 = await vercelPostgresStore.similaritySearch(
  "Irrelevant query, metadata filtering",
  3,
  {
    topic: { in: ["science", "nonsense"] },
  }
);
console.log(results3);
/*
  [\
    Document {\
      pageContent: 'hello',\
      metadata: { topic: 'nonsense' }\
    },\
    Document {\
      pageContent: 'hi',\
      metadata: { topic: 'nonsense' }\
    },\
    Document {\
      pageContent: 'Mitochondria is the powerhouse of the cell',\
      metadata: { topic: 'science' }\
    }\
  ]
*/

// Upserting is supported as well
await vercelPostgresStore.addDocuments(
  [\
    {\
      pageContent: "ATP is the powerhouse of the cell",\
      metadata: { topic: "science" },\
    },\
  ],
  { ids: [ids[2]] }
);

const results4 = await vercelPostgresStore.similaritySearch(
  "What is the powerhouse of the cell?",
  1
);
console.log(results4);
/*
  [\
    Document {\
      pageContent: 'ATP is the powerhouse of the cell',\
      metadata: { topic: 'science' }\
    }\
  ]
*/

await vercelPostgresStore.delete({ ids: [ids[2]] });

const results5 = await vercelPostgresStore.similaritySearch(
  "No more metadata",
  2,
  {
    topic: "science",
  }
);
console.log(results5);
/*
  []
*/

// Remember to call .end() to close the connection!
await vercelPostgresStore.end();

```

#### API Reference:

- CohereEmbeddingsfrom `@langchain/cohere`
- VercelPostgresfrom `@langchain/community/vectorstores/vercel_postgres`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/vercel_postgres/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/vercel_postgres/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/vercel_postgres/#setup)
  - [Connecting to Vercel Postgres](https://js.langchain.com/docs/integrations/vectorstores/vercel_postgres/#connecting-to-vercel-postgres)
  - [Connecting to other databases](https://js.langchain.com/docs/integrations/vectorstores/vercel_postgres/#connecting-to-other-databases)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/vercel_postgres/#usage)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/vercel_postgres/#related)