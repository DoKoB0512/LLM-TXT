[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/memory/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

LangChain offers is an in-memory, ephemeral vectorstore that stores
embeddings in-memory and does an exact, linear search for the most
similar embeddings. The default similarity metric is cosine similarity,
but can be changed to any of the similarity metrics supported by
[ml-distance](https://mljs.github.io/distance/modules/similarity.html).

As it is intended for demos, it does not yet support ids or deletion.

This guide provides a quick overview for getting started with in-memory
[`vector stores`](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `MemoryVectorStore` features and configurations
head to the [API\\
reference](https://api.js.langchain.com/classes/langchain.vectorstores_memory.MemoryVectorStore.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#integration-details "Direct link to Integration details")

| Class | Package | PY support | Package latest |
| :-- | :-- | :-: | :-: |
| [`MemoryVectorStore`](https://api.js.langchain.com/classes/langchain.vectorstores_memory.MemoryVectorStore.html) | [`langchain`](https://www.npmjs.com/package/langchain) | ❌ | ![NPM - Version](https://img.shields.io/npm/v/langchain?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#setup "Direct link to Setup")

To use in-memory vector stores, you’ll need to install the `langchain`
package:

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
npm i langchain @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
yarn add langchain @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
pnpm add langchain @langchain/openai @langchain/core

```

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#credentials "Direct link to Credentials")

There are no required credentials to use in-memory vector stores.

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

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#instantiation "Direct link to Instantiation")

```codeBlockLines_AdAo
import { MemoryVectorStore } from "langchain/vectorstores/memory";
import { OpenAIEmbeddings } from "@langchain/openai";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

const vectorStore = new MemoryVectorStore(embeddings);

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#add-items-to-vector-store "Direct link to Add items to vector store")

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

const documents = [document1, document2, document3];

await vectorStore.addDocuments(documents);

```

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
const filter = (doc) => doc.metadata.source === "https://example.com";

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

The filter is optional, and must be a predicate function that takes a
document as input, and returns `true` or `false` depending on whether
the document should be returned.

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
* [SIM=0.165] The powerhouse of the cell is the mitochondria [{"source":"https://example.com"}]
* [SIM=0.148] Mitochondria are made out of lipids [{"source":"https://example.com"}]

```

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

You can also transform the vector store into a
[retriever](https://js.langchain.com/docs/concepts/retrievers) for easier usage in your chains:

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

### Maximal marginal relevance [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#maximal-marginal-relevance "Direct link to Maximal marginal relevance")

This vector store also supports maximal marginal relevance (MMR), a
technique that first fetches a larger number of results (given by
`searchKwargs.fetchK`), with classic similarity search, then reranks for
diversity and returns the top `k` results. This helps guard against
redundant information:

```codeBlockLines_AdAo
const mmrRetriever = vectorStore.asRetriever({
  searchType: "mmr",
  searchKwargs: {
    fetchK: 10,
  },
  // Optional filter
  filter: filter,
  k: 2,
});

await mmrRetriever.invoke("biology");

```

```codeBlockLines_AdAo
[\
  Document {\
    pageContent: 'The powerhouse of the cell is the mitochondria',\
    metadata: { source: 'https://example.com' },\
    id: undefined\
  },\
  Document {\
    pageContent: 'Buildings are made out of brick',\
    metadata: { source: 'https://example.com' },\
    id: undefined\
  }\
]

```

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#api-reference "Direct link to API reference")

For detailed documentation of all `MemoryVectorStore` features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain.vectorstores_memory.MemoryVectorStore.html).

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/memory/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/memory/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/memory/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/memory/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/memory/#setup)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/memory/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/memory/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/memory/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/memory/#add-items-to-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/memory/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/memory/#query-directly)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/memory/#query-by-turning-into-retriever)
  - [Maximal marginal relevance](https://js.langchain.com/docs/integrations/vectorstores/memory/#maximal-marginal-relevance)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/memory/#usage-for-retrieval-augmented-generation)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/memory/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/memory/#related)