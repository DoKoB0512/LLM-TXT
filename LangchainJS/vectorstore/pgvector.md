[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

Compatibility

Only available on Node.js.

To enable vector search in generic PostgreSQL databases, LangChain.js
supports using the [`pgvector`](https://github.com/pgvector/pgvector)
Postgres extension.

This guide provides a quick overview for getting started with PGVector
[vector stores](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `PGVectorStore` features and configurations head to
the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_pgvector.PGVectorStore.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#integration-details "Direct link to Integration details")

| Class | Package | [PY support](https://python.langchain.com/docs/integrations/vectorstores/pgvector/) | Package latest |
| :-- | :-- | :-: | :-: |
| [`PGVectorStore`](https://api.js.langchain.com/classes/langchain_community_vectorstores_pgvector.PGVectorStore.html) | [`@langchain/community`](https://npmjs.com/@langchain/community) | ✅ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/community?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#setup "Direct link to Setup")

To use PGVector vector stores, you’ll need to set up a Postgres instance
with the [`pgvector`](https://github.com/pgvector/pgvector) extension
enabled. You’ll also need to install the `@langchain/community`
integration package with the [`pg`](https://www.npmjs.com/package/pg)
package as a peer dependency.

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
npm i @langchain/community @langchain/openai @langchain/core pg uuid

```

```codeBlockLines_AdAo
yarn add @langchain/community @langchain/openai @langchain/core pg uuid

```

```codeBlockLines_AdAo
pnpm add @langchain/community @langchain/openai @langchain/core pg uuid

```

### Setting up an instance [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#setting-up-an-instance "Direct link to Setting up an instance")

There are many ways to connect to Postgres depending on how you’ve set
up your instance. Here’s one example of a local setup using a prebuilt
Docker image provided by the `pgvector` team.

Create a file with the below content named docker-compose.yml:

```codeBlockLines_AdAo
# Run this command to start the database:
# docker compose up
services:
  db:
    hostname: 127.0.0.1
    image: pgvector/pgvector:pg16
    ports:
      - 5432:5432
    restart: always
    environment:
      - POSTGRES_DB=api
      - POSTGRES_USER=myuser
      - POSTGRES_PASSWORD=ChangeMe

```

And then in the same directory, run `docker compose up` to start the
container.

You can find more information on how to setup pgvector in the [official\\
repository](https://github.com/pgvector/pgvector/).

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#credentials "Direct link to Credentials")

To connect to you Postgres instance, you’ll need corresponding
credentials. For a full list of supported options, see the
[`node-postgres` docs](https://node-postgres.com/apis/client).

If you are using OpenAI embeddings for this guide, you’ll need to set
your OpenAI key as well:

```codeBlockLines_AdAo
process.env.OPENAI_API_KEY = "YOUR_API_KEY";

```

If you want to get automated tracing of your model calls you can also
set your [LangSmith](https://docs.smith.langchain.com/) API key by
uncommenting below:

```codeBlockLines_AdAo
// process.env.LANGSMITH_TRACING="true"
// process.env.LANGSMITH_API_KEY="your-api-key"

```

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#instantiation "Direct link to Instantiation")

To instantiate the vector store, call the `.initialize()` static method.
This will automatically check for the presence of a table, given by
`tableName` in the passed `config`. If it is not there, it will create
it with the required columns.

Security

User-generated data such as usernames should not be used as input for table and column names.
**This may lead to SQL Injection!**

```codeBlockLines_AdAo
import {
  PGVectorStore,
  DistanceStrategy,
} from "@langchain/community/vectorstores/pgvector";
import { OpenAIEmbeddings } from "@langchain/openai";
import { PoolConfig } from "pg";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

// Sample config
const config = {
  postgresConnectionOptions: {
    type: "postgres",
    host: "127.0.0.1",
    port: 5433,
    user: "myuser",
    password: "ChangeMe",
    database: "api",
  } as PoolConfig,
  tableName: "testlangchainjs",
  columns: {
    idColumnName: "id",
    vectorColumnName: "vector",
    contentColumnName: "content",
    metadataColumnName: "metadata",
  },
  // supported distance strategies: cosine (default), innerProduct, or euclidean
  distanceStrategy: "cosine" as DistanceStrategy,
};

const vectorStore = await PGVectorStore.initialize(embeddings, config);

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#add-items-to-vector-store "Direct link to Add items to vector store")

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

await vectorStore.addDocuments(documents, { ids: ids });

```

### Delete items from vector store [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#delete-items-from-vector-store "Direct link to Delete items from vector store")

```codeBlockLines_AdAo
const id4 = ids[ids.length - 1];

await vectorStore.delete({ ids: [id4] });

```

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
const filter = { source: "https://example.com" };

const similaritySearchResults = await vectorStore.similaritySearch(
  "biology",
  2,
  filter
);

for (const doc of similaritySearchResults) {
  console.log(`* ${doc.pageContent} [${JSON.stringify(doc.metadata, null)}]`);
}

```

```codeBlockLines_AdAo
* The powerhouse of the cell is the mitochondria [{"source":"https://example.com"}]
* Mitochondria are made out of lipids [{"source":"https://example.com"}]

```

The above filter syntax supports exact match, but the following are also
supported:

#### Using the `in` operator [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#using-the-in-operator "Direct link to using-the-in-operator")

```codeBlockLines_AdAo
{
  "field": {
    "in": ["value1", "value2"]
  }
}

```

#### Using the `arrayContains` operator [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#using-the-arraycontains-operator "Direct link to using-the-arraycontains-operator")

```codeBlockLines_AdAo
{
  "field": {
    "arrayContains": ["value1", "value2"]
  }
}

```

If you want to execute a similarity search and receive the corresponding
scores you can run:

```codeBlockLines_AdAo
const similaritySearchWithScoreResults =
  await vectorStore.similaritySearchWithScore("biology", 2, filter);

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

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

You can also transform the vector store into a
[retriever](https://js.langchain.com/docs/concepts/retrievers) for easier usage in your chains.

```codeBlockLines_AdAo
const retriever = vectorStore.asRetriever({
  // Optional filter
  filter: filter,
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

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## Advanced: reusing connections [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#advanced-reusing-connections "Direct link to Advanced: reusing connections")

You can reuse connections by creating a pool, then creating new
`PGVectorStore` instances directly via the constructor.

Note that you should call `.initialize()` to set up your database at
least once to set up your tables properly before using the constructor.

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import { PGVectorStore } from "@langchain/community/vectorstores/pgvector";
import pg from "pg";

// First, follow set-up instructions at
// https://js.langchain.com/docs/modules/indexes/vector_stores/integrations/pgvector

const reusablePool = new pg.Pool({
  host: "127.0.0.1",
  port: 5433,
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
    vectorColumnName: "vector",
    contentColumnName: "content",
    metadataColumnName: "metadata",
  },
};

// Set up the DB.
// Can skip this step if you've already initialized the DB.
// await PGVectorStore.initialize(new OpenAIEmbeddings(), originalConfig);
const pgvectorStore = new PGVectorStore(new OpenAIEmbeddings(), originalConfig);

await pgvectorStore.addDocuments([\
  { pageContent: "what's this", metadata: { a: 2 } },\
  { pageContent: "Cat drinks milk", metadata: { a: 1 } },\
]);

const results = await pgvectorStore.similaritySearch("water", 1);

console.log(results);

/*
  [ Document { pageContent: 'Cat drinks milk', metadata: { a: 1 } } ]
*/

const pgvectorStore2 = new PGVectorStore(new OpenAIEmbeddings(), {
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

const results2 = await pgvectorStore2.similaritySearch("water", 1);

console.log(results2);

/*
  []
*/

await reusablePool.end();

```

## Create HNSW Index [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#create-hnsw-index "Direct link to Create HNSW Index")

By default, the extension performs a sequential scan search, with 100%
recall. You might consider creating an HNSW index for approximate
nearest neighbor (ANN) search to speed up
`similaritySearchVectorWithScore` execution time. To create the HNSW
index on your vector column, use the `createHnswIndex()` method.

The method parameters include:

- `dimensions`: Defines the number of dimensions in your vector data
type, up to 2000. For example, use 1536 for OpenAI’s
text-embedding-ada-002 and Amazon’s amazon.titan-embed-text-v1
models.

- `m?`: The max number of connections per layer (16 by default). Index
build time improves with smaller values, while higher values can
speed up search queries.

- `efConstruction?`: The size of the dynamic candidate list for
constructing the graph (64 by default). A higher value can
potentially improve the index quality at the cost of index build
time.

- `distanceFunction?`: The distance function name you want to use, is
automatically selected based on the distanceStrategy.


For more info, see the [Pgvector GitHub\\
repo](https://github.com/pgvector/pgvector?tab=readme-ov-file#hnsw) and
the [HNSW paper from Malkov Yu A. and Yashunin D. A.. 2020. Efficient\\
and robust approximate nearest neighbor search using hierarchical\\
navigable small world graphs](https://arxiv.org/pdf/1603.09320)

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import {
  DistanceStrategy,
  PGVectorStore,
} from "@langchain/community/vectorstores/pgvector";
import { PoolConfig } from "pg";

// First, follow set-up instructions at
// https://js.langchain.com/docs/modules/indexes/vector_stores/integrations/pgvector

const hnswConfig = {
  postgresConnectionOptions: {
    type: "postgres",
    host: "127.0.0.1",
    port: 5433,
    user: "myuser",
    password: "ChangeMe",
    database: "api",
  } as PoolConfig,
  tableName: "testlangchainjs",
  columns: {
    idColumnName: "id",
    vectorColumnName: "vector",
    contentColumnName: "content",
    metadataColumnName: "metadata",
  },
  // supported distance strategies: cosine (default), innerProduct, or euclidean
  distanceStrategy: "cosine" as DistanceStrategy,
};

const hnswPgVectorStore = await PGVectorStore.initialize(
  new OpenAIEmbeddings(),
  hnswConfig
);

// create the index
await hnswPgVectorStore.createHnswIndex({
  dimensions: 1536,
  efConstruction: 64,
  m: 16,
});

await hnswPgVectorStore.addDocuments([\
  { pageContent: "what's this", metadata: { a: 2, b: ["tag1", "tag2"] } },\
  { pageContent: "Cat drinks milk", metadata: { a: 1, b: ["tag2"] } },\
]);

const model = new OpenAIEmbeddings();
const query = await model.embedQuery("water");
const hnswResults = await hnswPgVectorStore.similaritySearchVectorWithScore(
  query,
  1
);

console.log(hnswResults);

await pgvectorStore.end();

```

## Closing connections [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#closing-connections "Direct link to Closing connections")

Make sure you close the connection when you are finished to avoid
excessive resource consumption:

```codeBlockLines_AdAo
await vectorStore.end();

```

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#api-reference "Direct link to API reference")

For detailed documentation of all `PGVectorStore` features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_pgvector.PGVectorStore.html).

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/pgvector/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/pgvector/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#setup)
  - [Setting up an instance](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#setting-up-an-instance)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#add-items-to-vector-store)
  - [Delete items from vector store](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#delete-items-from-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#query-directly)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#usage-for-retrieval-augmented-generation)
- [Advanced: reusing connections](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#advanced-reusing-connections)
- [Create HNSW Index](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#create-hnsw-index)
- [Closing connections](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#closing-connections)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/pgvector/#related)