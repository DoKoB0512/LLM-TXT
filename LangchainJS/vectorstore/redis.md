[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/redis/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

Compatibility

Only available on Node.js.

[Redis](https://redis.io/) is a fast open source, in-memory data store.
As part of the [Redis\\
Stack](https://redis.io/docs/latest/operate/oss_and_stack/install/install-stack/),
[RediSearch](https://redis.io/docs/latest/develop/interact/search-and-query/)
is the module that enables vector similarity semantic search, as well as
many other types of searching.

This guide provides a quick overview for getting started with Redis
[vector stores](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `RedisVectorStore` features and configurations head
to the [API\\
reference](https://api.js.langchain.com/classes/langchain_redis.RedisVectorStore.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#integration-details "Direct link to Integration details")

| Class | Package | [PY support](https://python.langchain.com/docs/integrations/vectorstores/redis/) | Package latest |
| :-- | :-- | :-: | :-: |
| [`RedisVectorStore`](https://api.js.langchain.com/classes/langchain_redis.RedisVectorStore.html) | [`@langchain/redis`](https://npmjs.com/@langchain/redis/) | ✅ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/redis?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#setup "Direct link to Setup")

To use Redis vector stores, you’ll need to set up a Redis instance and
install the `@langchain/redis` integration package. You can also install
the [`node-redis`](https://github.com/redis/node-redis) package to
initialize the vector store with a specific client instance.

This guide will also use [OpenAI\\
embeddings](https://js.langchain.com/docs/integrations/text_embedding/openai), which require you
to install the `@langchain/openai` integration package. You can also use
[other supported embeddings models](https://js.langchain.com/docs/integrations/text_embedding)
if you wish.

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/redis @langchain/core redis @langchain/openai

```

```codeBlockLines_AdAo
yarn add @langchain/redis @langchain/core redis @langchain/openai

```

```codeBlockLines_AdAo
pnpm add @langchain/redis @langchain/core redis @langchain/openai

```

You can set up a Redis instance locally with Docker by following [these\\
instructions](https://redis.io/docs/latest/operate/oss_and_stack/install/install-stack/docker/#redisredis-stack).

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#credentials "Direct link to Credentials")

Once you’ve set up an instance, set the `REDIS_URL` environment
variable:

```codeBlockLines_AdAo
process.env.REDIS_URL = "your-redis-url";

```

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

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#instantiation "Direct link to Instantiation")

```codeBlockLines_AdAo
import { RedisVectorStore } from "@langchain/redis";
import { OpenAIEmbeddings } from "@langchain/openai";

import { createClient } from "redis";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

const client = createClient({
  url: process.env.REDIS_URL ?? "redis://localhost:6379",
});
await client.connect();

const vectorStore = new RedisVectorStore(embeddings, {
  redisClient: client,
  indexName: "langchainjs-testing",
});

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#add-items-to-vector-store "Direct link to Add items to vector store")

```codeBlockLines_AdAo
import type { Document } from "@langchain/core/documents";

const document1: Document = {
  pageContent: "The powerhouse of the cell is the mitochondria",
  metadata: { type: "example" },
};

const document2: Document = {
  pageContent: "Buildings are made out of brick",
  metadata: { type: "example" },
};

const document3: Document = {
  pageContent: "Mitochondria are made out of lipids",
  metadata: { type: "example" },
};

const document4: Document = {
  pageContent: "The 2024 Olympics are in Paris",
  metadata: { type: "example" },
};

const documents = [document1, document2, document3, document4];

await vectorStore.addDocuments(documents);

```

Top-level document ids and deletion are currently not supported.

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
const similaritySearchResults = await vectorStore.similaritySearch(
  "biology",
  2
);

for (const doc of similaritySearchResults) {
  console.log(`* ${doc.pageContent} [${JSON.stringify(doc.metadata, null)}]`);
}

```

Filtering will currently look for any metadata key containing the
provided string.

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
* [SIM=0.835] The powerhouse of the cell is the mitochondria [{"type":"example"}]
* [SIM=0.852] Mitochondria are made out of lipids [{"type":"example"}]

```

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

You can also transform the vector store into a
[retriever](https://js.langchain.com/docs/concepts/retrievers) for easier usage in your chains.

```codeBlockLines_AdAo
const retriever = vectorStore.asRetriever({
  k: 2,
});
await retriever.invoke("biology");

```

```codeBlockLines_AdAo
[\
  Document {\
    pageContent: 'The powerhouse of the cell is the mitochondria',\
    metadata: { type: 'example' },\
    id: undefined\
  },\
  Document {\
    pageContent: 'Mitochondria are made out of lipids',\
    metadata: { type: 'example' },\
    id: undefined\
  }\
]

```

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## Deleting an index [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#deleting-an-index "Direct link to Deleting an index")

You can delete an entire index with the following command:

```codeBlockLines_AdAo
await vectorStore.delete({ deleteAll: true });

```

## Closing connections [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#closing-connections "Direct link to Closing connections")

Make sure you close the client connection when you are finished to avoid
excessive resource consumption:

```codeBlockLines_AdAo
await client.disconnect();

```

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#api-reference "Direct link to API reference")

For detailed documentation of all `RedisVectorSearch` features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_redis.RedisVectorStore.html).

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/redis/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/redis/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/redis/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/redis/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/redis/#setup)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/redis/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/redis/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/redis/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/redis/#add-items-to-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/redis/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/redis/#query-directly)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/redis/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/redis/#usage-for-retrieval-augmented-generation)
- [Deleting an index](https://js.langchain.com/docs/integrations/vectorstores/redis/#deleting-an-index)
- [Closing connections](https://js.langchain.com/docs/integrations/vectorstores/redis/#closing-connections)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/redis/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/redis/#related)