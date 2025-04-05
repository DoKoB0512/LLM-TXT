[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/upstash/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

[Upstash Vector](https://upstash.com/) is a REST based serverless vector
database, designed for working with vector embeddings.

This guide provides a quick overview for getting started with Upstash
[vector stores](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `UpstashVectorStore` features and configurations
head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_upstash.UpstashVectorStore.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#integration-details "Direct link to Integration details")

| Class | Package | [PY support](https://python.langchain.com/docs/integrations/vectorstores/upstash/) | Package latest |
| :-- | :-- | :-: | :-: |
| [`UpstashVectorStore`](https://api.js.langchain.com/classes/langchain_community_vectorstores_upstash.UpstashVectorStore.html) | [`@langchain/community`](https://npmjs.com/@langchain/community) | ✅ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/community?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#setup "Direct link to Setup")

To use Upstash vector stores, you’ll need to create an Upstash account,
create an index, and install the `@langchain/community` integration
package. You’ll also need to install the
[`@upstash/vector`](https://www.npmjs.com/package/@upstash/vector)
package as a peer dependency.

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
npm i @langchain/community @langchain/core @upstash/vector @langchain/openai

```

```codeBlockLines_AdAo
yarn add @langchain/community @langchain/core @upstash/vector @langchain/openai

```

```codeBlockLines_AdAo
pnpm add @langchain/community @langchain/core @upstash/vector @langchain/openai

```

You can create an index from the [Upstash\\
Console](https://console.upstash.com/login). For further reference, see
[the official docs](https://upstash.com/docs/vector/overall/getstarted).

Upstash vector also has built in embedding support. Which means you can
use it directly without the need for an additional embedding model.
Check the [embedding models\\
documentation](https://upstash.com/docs/vector/features/embeddingmodels)
for more details.

note

To use the built-in Upstash embeddings, you'll need to select an embedding model when creating the index.

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#credentials "Direct link to Credentials")

Once you’ve set up an index, set the following environment variables:

```codeBlockLines_AdAo
process.env.UPSTASH_VECTOR_REST_URL = "your-rest-url";
process.env.UPSTASH_VECTOR_REST_TOKEN = "your-rest-token";

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

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#instantiation "Direct link to Instantiation")

Make sure your index has the same dimension count as your embeddings.
The default for OpenAI `text-embedding-3-small` is 1536.

```codeBlockLines_AdAo
import { UpstashVectorStore } from "@langchain/community/vectorstores/upstash";
import { OpenAIEmbeddings } from "@langchain/openai";

import { Index } from "@upstash/vector";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

const indexWithCredentials = new Index({
  url: process.env.UPSTASH_VECTOR_REST_URL,
  token: process.env.UPSTASH_VECTOR_REST_TOKEN,
});

const vectorStore = new UpstashVectorStore(embeddings, {
  index: indexWithCredentials,
  // You can use namespaces to partition your data in an index
  // namespace: "test-namespace",
});

```

## Usage with built-in embeddings [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#usage-with-built-in-embeddings "Direct link to Usage with built-in embeddings")

To use the built-in Upstash embeddings, you can pass a `FakeEmbeddings`
instance to the `UpstashVectorStore` constructor. This will make the
`UpstashVectorStore` use the built-in embeddings, which you selected
when creating the index.

```codeBlockLines_AdAo
import { UpstashVectorStore } from "@langchain/community/vectorstores/upstash";
import { FakeEmbeddings } from "@langchain/core/utils/testing";

import { Index } from "@upstash/vector";

const indexWithEmbeddings = new Index({
  url: process.env.UPSTASH_VECTOR_REST_URL,
  token: process.env.UPSTASH_VECTOR_REST_TOKEN,
});

const vectorStore = new UpstashVectorStore(new FakeEmbeddings(), {
  index: indexWithEmbeddings,
});

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#add-items-to-vector-store "Direct link to Add items to vector store")

```codeBlockLines_AdAo
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

await vectorStore.addDocuments(documents, { ids: ["1", "2", "3", "4"] });

```

```codeBlockLines_AdAo
[ '1', '2', '3', '4' ]

```

**Note:** After adding documents, there may be a slight delay before
they become queryable.

### Delete items from vector store [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#delete-items-from-vector-store "Direct link to Delete items from vector store")

```codeBlockLines_AdAo
await vectorStore.delete({ ids: ["4"] });

```

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
const filter = "source = 'https://example.com'";

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

See [this page](https://upstash.com/docs/vector/features/filtering) for
more on Upstash Vector filter syntax.

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
* [SIM=0.576] The powerhouse of the cell is the mitochondria [{"source":"https://example.com"}]
* [SIM=0.557] Mitochondria are made out of lipids [{"source":"https://example.com"}]

```

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

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

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#api-reference "Direct link to API reference")

For detailed documentation of all `UpstashVectorStore` features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_upstash.UpstashVectorStore.html).

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/upstash/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/upstash/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/upstash/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/upstash/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/upstash/#setup)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/upstash/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/upstash/#instantiation)
- [Usage with built-in embeddings](https://js.langchain.com/docs/integrations/vectorstores/upstash/#usage-with-built-in-embeddings)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/upstash/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/upstash/#add-items-to-vector-store)
  - [Delete items from vector store](https://js.langchain.com/docs/integrations/vectorstores/upstash/#delete-items-from-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/upstash/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/upstash/#query-directly)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/upstash/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/upstash/#usage-for-retrieval-augmented-generation)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/upstash/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/upstash/#related)