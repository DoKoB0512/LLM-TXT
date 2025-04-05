[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/neon/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Neon Postgres

Neon is a fully managed serverless PostgreSQL database. It separates storage and compute to offer
features such as instant branching and automatic scaling.

With the `pgvector` extension, Neon provides a vector store that can be used with LangChain.js to store and query embeddings.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/neon/\#setup "Direct link to Setup")

### Select a Neon project [​](https://js.langchain.com/docs/integrations/vectorstores/neon/\#select-a-neon-project "Direct link to Select a Neon project")

If you do not have a Neon account, sign up for one at [Neon](https://neon.tech/). After logging into the Neon Console, proceed
to the [Projects](https://console.neon.tech/app/projects) section and select an existing project or create a new one.

Your Neon project comes with a ready-to-use Postgres database named `neondb` that you can use to store embeddings. Navigate to
the Connection Details section to find your database connection string. It should look similar to this:

```codeBlockLines_AdAo
postgres://alex:AbC123dEf@ep-cool-darkness-123456.us-east-2.aws.neon.tech/dbname?sslmode=require

```

Keep your connection string handy for later use.

### Application code [​](https://js.langchain.com/docs/integrations/vectorstores/neon/\#application-code "Direct link to Application code")

To work with Neon Postgres, you need to install the `@neondatabase/serverless` package which provides a JavaScript/TypeScript
driver to connect to the database.

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @neondatabase/serverless

```

```codeBlockLines_AdAo
yarn add @neondatabase/serverless

```

```codeBlockLines_AdAo
pnpm add @neondatabase/serverless

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

To initialize a `NeonPostgres` vectorstore, you need to provide your Neon database connection string. You can use the connection string
we fetched above directly, or store it as an environment variable and use it in your code.

```codeBlockLines_AdAo
const vectorStore = await NeonPostgres.initialize(embeddings, {
  connectionString: NEON_POSTGRES_CONNECTION_STRING,
});

```

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/neon/\#usage "Direct link to Usage")

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import { NeonPostgres } from "@langchain/community/vectorstores/neon";

// Initialize an embeddings instance
const embeddings = new OpenAIEmbeddings({
  apiKey: process.env.OPENAI_API_KEY,
  dimensions: 256,
  model: "text-embedding-3-small",
});

// Initialize a NeonPostgres instance to store embedding vectors
const vectorStore = await NeonPostgres.initialize(embeddings, {
  connectionString: process.env.DATABASE_URL as string,
});

// You can add documents to the store, strings in the `pageContent` field will be embedded
// and stored in the database
const documents = [\
  { pageContent: "Hello world", metadata: { topic: "greeting" } },\
  { pageContent: "Bye bye", metadata: { topic: "greeting" } },\
  {\
    pageContent: "Mitochondria is the powerhouse of the cell",\
    metadata: { topic: "science" },\
  },\
];
const idsInserted = await vectorStore.addDocuments(documents);

// You can now query the store for similar documents to the input query
const resultOne = await vectorStore.similaritySearch("hola", 1);
console.log(resultOne);
/*
[\
  Document {\
    pageContent: 'Hello world',\
    metadata: { topic: 'greeting' }\
  }\
]
*/

// You can also filter by metadata
const resultTwo = await vectorStore.similaritySearch("Irrelevant query", 2, {
  topic: "science",
});
console.log(resultTwo);
/*
[\
  Document {\
    pageContent: 'Mitochondria is the powerhouse of the cell',\
    metadata: { topic: 'science' }\
  }\
]
*/

// Metadata filtering with IN-filters works as well
const resultsThree = await vectorStore.similaritySearch("Irrelevant query", 2, {
  topic: { in: ["greeting"] },
});
console.log(resultsThree);
/*
[\
  Document { pageContent: 'Bye bye', metadata: { topic: 'greeting' } },\
  Document {\
    pageContent: 'Hello world',\
    metadata: { topic: 'greeting' }\
  }\
]
*/

// Upserting is supported as well
await vectorStore.addDocuments(
  [\
    {\
      pageContent: "ATP is the powerhouse of the cell",\
      metadata: { topic: "science" },\
    },\
  ],
  { ids: [idsInserted[2]] }
);

const resultsFour = await vectorStore.similaritySearch(
  "powerhouse of the cell",
  1
);
console.log(resultsFour);
/*
[\
  Document {\
    pageContent: 'ATP is the powerhouse of the cell',\
    metadata: { topic: 'science' }\
  }\
]
*/

```

#### API Reference:

- OpenAIEmbeddingsfrom `@langchain/openai`
- NeonPostgresfrom `@langchain/community/vectorstores/neon`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/neon/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/neon/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/neon/#setup)
  - [Select a Neon project](https://js.langchain.com/docs/integrations/vectorstores/neon/#select-a-neon-project)
  - [Application code](https://js.langchain.com/docs/integrations/vectorstores/neon/#application-code)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/neon/#usage)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/neon/#related)