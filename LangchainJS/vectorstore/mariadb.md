[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

Compatibility

Only available on Node.js.

This requires MariaDB 11.7 or later version

This guide provides a quick overview for getting started with mariadb
[vector stores](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `MariaDB store` features and configurations head to
the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_mariadb.MariaDBStore.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#integration-details "Direct link to Integration details")

| Class | Package | [PY support](https://python.langchain.com/docs/integrations/vectorstores/mariadb/) | Package latest |
| :-- | :-- | :-: | :-: |
| [`MariaDBStore`](https://api.js.langchain.com/classes/langchain_community_vectorstores_mariadb.MariaDBStore.html) | [`@langchain/community`](https://npmjs.com/@langchain/community) | ✅ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/community?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#setup "Direct link to Setup")

To use MariaDBVector vector stores, you’ll need to set up a MariaDB 11.7
version or later with the
[`mariadb`](https://www.npmjs.com/package/mariadb) connector as a peer
dependency.

This guide will also use [OpenAI\\
embeddings](https://js.langchain.com/docs/integrations/text_embedding/openai), which require you
to install the `@langchain/openai` integration package. You can also use
[other supported embeddings models](https://js.langchain.com/docs/integrations/text_embedding)
if you wish.

We’ll also use the [`uuid`](https://www.npmjs.com/package/uuid) package
to generate ids in the required format.

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/community @langchain/openai @langchain/core mariadb uuid

```

```codeBlockLines_AdAo
yarn add @langchain/community @langchain/openai @langchain/core mariadb uuid

```

```codeBlockLines_AdAo
pnpm add @langchain/community @langchain/openai @langchain/core mariadb uuid

```

### Setting up an instance [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#setting-up-an-instance "Direct link to Setting up an instance")

Create a file with the below content named docker-compose.yml:

```codeBlockLines_AdAo
# Run this command to start the database:
# docker-compose up --build
version: "3"
services:
  db:
    hostname: 127.0.0.1
    image: mariadb/mariadb:11.7-rc
    ports:
      - 3306:3306
    restart: always
    environment:
      - MARIADB_DATABASE=api
      - MARIADB_USER=myuser
      - MARIADB_PASSWORD=ChangeMe
      - MARIADB_ROOT_PASSWORD=ChangeMe
    volumes:
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql

```

And then in the same directory, run docker compose up to start the
container.

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#credentials "Direct link to Credentials")

To connect to you MariaDB instance, you’ll need corresponding
credentials. For a full list of supported options, see the [`mariadb`\\
docs](https://github.com/mariadb-corporation/mariadb-connector-nodejs/blob/master/documentation/promise-api.md#connection-options).

If you are using OpenAI embeddings for this guide, you’ll need to set
your OpenAI key as well:

```codeBlockLines_AdAo
process.env.OPENAI_API_KEY = "YOUR_API_KEY";

```

If you want to get automated tracing of your model calls you can also
set your [LangSmith](https://docs.smith.langchain.com/) API key by
uncommenting below:

```codeBlockLines_AdAo
// process.env.LANGCHAIN_TRACING_V2="true"
// process.env.LANGCHAIN_API_KEY="your-api-key"

```

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#instantiation "Direct link to Instantiation")

To instantiate the vector store, call the `.initialize()` static method.
This will automatically check for the presence of a table, given by
`tableName` in the passed `config`. If it is not there, it will create
it with the required columns.

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";

import {
  DistanceStrategy,
  MariaDBStore,
} from "@langchain/community/vectorstores/mariadb";
import { PoolConfig } from "mariadb";

const config = {
  connectionOptions: {
    type: "mariadb",
    host: "127.0.0.1",
    port: 3306,
    user: "myuser",
    password: "ChangeMe",
    database: "api",
  } as PoolConfig,
  distanceStrategy: "EUCLIDEAN" as DistanceStrategy,
};
const vectorStore = await MariaDBStore.initialize(
  new OpenAIEmbeddings(),
  config
);

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#add-items-to-vector-store "Direct link to Add items to vector store")

```codeBlockLines_AdAo
import { v4 as uuidv4 } from "uuid";
import type { Document } from "@langchain/core/documents";

const document1: Document = {
  pageContent: "The powerhouse of the cell is the mitochondria",
  metadata: { source: "https://example.com" },
};

const document2: Document = {
  pageContent: "Buildings are made out of brick",
  metadata: { source: "https://example.com" },
};

const document3: Document = {
  pageContent: "Mitochondria are made out of lipids",
  metadata: { source: "https://example.com" },
};

const document4: Document = {
  pageContent: "The 2024 Olympics are in Paris",
  metadata: { source: "https://example.com" },
};

const documents = [document1, document2, document3, document4];

const ids = [uuidv4(), uuidv4(), uuidv4(), uuidv4()];

// ids are not mandatory, but that's for the example
await vectorStore.addDocuments(documents, { ids: ids });

```

### Delete items from vector store [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#delete-items-from-vector-store "Direct link to Delete items from vector store")

```codeBlockLines_AdAo
const id4 = ids[ids.length - 1];

await vectorStore.delete({ ids: [id4] });

```

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
const similaritySearchResults = await vectorStore.similaritySearch(
  "biology",
  2,
  { year: 2021 }
);
for (const doc of similaritySearchResults) {
  console.log(`* ${doc.pageContent} [${JSON.stringify(doc.metadata, null)}]`);
}

```

```codeBlockLines_AdAo
* The powerhouse of the cell is the mitochondria [{"year": 2021}]
* Mitochondria are made out of lipids [{"year": 2022}]

```

The above filter syntax use be more complex:

```codeBlockLines_AdAo
# name = 'martin' OR firstname = 'john'
let res = await vectorStore.similaritySearch("biology", 2, {"$or": [{"name":"martin"}, {"firstname", "john"}] });

```

If you want to execute a similarity search and receive the corresponding
scores you can run:

```codeBlockLines_AdAo
const similaritySearchWithScoreResults =
  await vectorStore.similaritySearchWithScore("biology", 2);

for (const [doc, score] of similaritySearchWithScoreResults) {
  console.log(
    `* [SIM=${score.toFixed(3)}] ${doc.pageContent} [${JSON.stringify(\
      doc.metadata\
    )}]`
  );
}

```

```codeBlockLines_AdAo
* [SIM=0.835] The powerhouse of the cell is the mitochondria [{"source":"https://example.com"}]
* [SIM=0.852] Mitochondria are made out of lipids [{"source":"https://example.com"}]

```

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

You can also transform the vector store into a
[retriever](https://js.langchain.com/docs/concepts/retrievers) for easier usage in your chains.

```codeBlockLines_AdAo
const retriever = vectorStore.asRetriever({
  // Optional filter
  // filter: filter,
  k: 2,
});
await retriever.invoke("biology");

```

```codeBlockLines_AdAo
[\
  Document {\
    pageContent: 'The powerhouse of the cell is the mitochondria',\
    metadata: { source: 'https://example.com' },\
    id: undefined\
  },\
  Document {\
    pageContent: 'Mitochondria are made out of lipids',\
    metadata: { source: 'https://example.com' },\
    id: undefined\
  }\
]

```

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## Advanced: reusing connections [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#advanced-reusing-connections "Direct link to Advanced: reusing connections")

You can reuse connections by creating a pool, then creating new
`MariaDBStore` instances directly via the constructor.

Note that you should call `.initialize()` to set up your database at
least once to set up your tables properly before using the constructor.

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import { MariaDBStore } from "@langchain/community/vectorstores/mariadb";
import mariadb from "mariadb";

// First, follow set-up instructions at
// https://js.langchain.com/docs/modules/indexes/vector_stores/integrations/mariadb

const reusablePool = mariadb.createPool({
  host: "127.0.0.1",
  port: 3306,
  user: "myuser",
  password: "ChangeMe",
  database: "api",
});

const originalConfig = {
  pool: reusablePool,
  tableName: "testlangchainjs",
  collectionName: "sample",
  collectionTableName: "collections",
  columns: {
    idColumnName: "id",
    vectorColumnName: "vect",
    contentColumnName: "content",
    metadataColumnName: "metadata",
  },
};

// Set up the DB.
// Can skip this step if you've already initialized the DB.
// await MariaDBStore.initialize(new OpenAIEmbeddings(), originalConfig);
const mariadbStore = new MariaDBStore(new OpenAIEmbeddings(), originalConfig);

await mariadbStore.addDocuments([\
  { pageContent: "what's this", metadata: { a: 2 } },\
  { pageContent: "Cat drinks milk", metadata: { a: 1 } },\
]);

const results = await mariadbStore.similaritySearch("water", 1);

console.log(results);

/*
  [ Document { pageContent: 'Cat drinks milk', metadata: { a: 1 } } ]
*/

const mariadbStore2 = new MariaDBStore(new OpenAIEmbeddings(), {
  pool: reusablePool,
  tableName: "testlangchainjs",
  collectionTableName: "collections",
  collectionName: "some_other_collection",
  columns: {
    idColumnName: "id",
    vectorColumnName: "vector",
    contentColumnName: "content",
    metadataColumnName: "metadata",
  },
});

const results2 = await mariadbStore2.similaritySearch("water", 1);

console.log(results2);

/*
  []
*/

await reusablePool.end();

```

## Closing connections [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#closing-connections "Direct link to Closing connections")

Make sure you close the connection when you are finished to avoid
excessive resource consumption:

```codeBlockLines_AdAo
await vectorStore.end();

```

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#api-reference "Direct link to API reference")

For detailed documentation of all `MariaDBStore` features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_mariadb.MariaDBStore.html).

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/mariadb/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/mariadb/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#setup)
  - [Setting up an instance](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#setting-up-an-instance)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#add-items-to-vector-store)
  - [Delete items from vector store](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#delete-items-from-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#query-directly)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#usage-for-retrieval-augmented-generation)
- [Advanced: reusing connections](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#advanced-reusing-connections)
- [Closing connections](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#closing-connections)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/mariadb/#related)