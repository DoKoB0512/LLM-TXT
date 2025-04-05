[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/astradb/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Astra DB

Compatibility

Only available on Node.js.

DataStax [Astra DB](https://astra.datastax.com/register) is a serverless vector-capable database built on [Apache Cassandra](https://cassandra.apache.org/_/index.html) and made conveniently available through an easy-to-use JSON API.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/astradb/\#setup "Direct link to Setup")

1. Create an [Astra DB account](https://astra.datastax.com/register).
2. Create a [vector enabled database](https://astra.datastax.com/createDatabase).
3. Grab your `API Endpoint` and `Token` from the Database Details.
4. Set up the following env vars:

```codeBlockLines_AdAo
export ASTRA_DB_APPLICATION_TOKEN=YOUR_ASTRA_DB_APPLICATION_TOKEN_HERE
export ASTRA_DB_ENDPOINT=YOUR_ASTRA_DB_ENDPOINT_HERE
export ASTRA_DB_COLLECTION=YOUR_ASTRA_DB_COLLECTION_HERE
export OPENAI_API_KEY=YOUR_OPENAI_API_KEY_HERE

```

Where `ASTRA_DB_COLLECTION` is the desired name of your collection

6. Install the Astra TS Client & the LangChain community package

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @langchain/openai @datastax/astra-db-ts @langchain/community @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/openai @datastax/astra-db-ts @langchain/community @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/openai @datastax/astra-db-ts @langchain/community @langchain/core

```

## Indexing docs [​](https://js.langchain.com/docs/integrations/vectorstores/astradb/\#indexing-docs "Direct link to Indexing docs")

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import {
  AstraDBVectorStore,
  AstraLibArgs,
} from "@langchain/community/vectorstores/astradb";

const astraConfig: AstraLibArgs = {
  token: process.env.ASTRA_DB_APPLICATION_TOKEN as string,
  endpoint: process.env.ASTRA_DB_ENDPOINT as string,
  collection: process.env.ASTRA_DB_COLLECTION ?? "langchain_test",
  collectionOptions: {
    vector: {
      dimension: 1536,
      metric: "cosine",
    },
  },
};

const vectorStore = await AstraDBVectorStore.fromTexts(
  [\
    "AstraDB is built on Apache Cassandra",\
    "AstraDB is a NoSQL DB",\
    "AstraDB supports vector search",\
  ],
  [{ foo: "foo" }, { foo: "bar" }, { foo: "baz" }],
  new OpenAIEmbeddings(),
  astraConfig
);

// Querying docs:
const results = await vectorStore.similaritySearch("Cassandra", 1);

// or filtered query:
const filteredQueryResults = await vectorStore.similaritySearch("A", 1, {
  foo: "bar",
});

```

#### API Reference:

- OpenAIEmbeddingsfrom `@langchain/openai`
- AstraDBVectorStorefrom `@langchain/community/vectorstores/astradb`
- AstraLibArgsfrom `@langchain/community/vectorstores/astradb`

## Vector Types [​](https://js.langchain.com/docs/integrations/vectorstores/astradb/\#vector-types "Direct link to Vector Types")

Astra DB supports `cosine` (the default), `dot_product`, and `euclidean` similarity search; this is defined when the
vector store is first created as part of the `CreateCollectionOptions`:

```codeBlockLines_AdAo
  vector: {
      dimension: number;
      metric?: "cosine" | "euclidean" | "dot_product";
  };

```

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/astradb/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/astradb/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/astradb/#setup)
- [Indexing docs](https://js.langchain.com/docs/integrations/vectorstores/astradb/#indexing-docs)
- [Vector Types](https://js.langchain.com/docs/integrations/vectorstores/astradb/#vector-types)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/astradb/#related)