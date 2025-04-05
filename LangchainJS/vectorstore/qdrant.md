[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

Compatibility

Only available on Node.js.

[Qdrant](https://qdrant.tech/) is a vector similarity search engine. It
provides a production-ready service with a convenient API to store,
search, and manage points - vectors with an additional payload.

This guide provides a quick overview for getting started with Qdrant
[vector stores](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `QdrantVectorStore` features and configurations
head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_qdrant.QdrantVectorStore.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/qdrant/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/qdrant/\#integration-details "Direct link to Integration details")

| Class | Package | [PY support](https://python.langchain.com/docs/integrations/vectorstores/qdrant/) | Package latest |
| :-- | :-- | :-: | :-: |
| [`QdrantVectorStore`](https://api.js.langchain.com/classes/langchain_qdrant.QdrantVectorStore.html) | [`@langchain/qdrant`](https://npmjs.com/@langchain/qdrant) | ✅ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/qdrant?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/qdrant/\#setup "Direct link to Setup")

To use Qdrant vector stores, you’ll need to set up a Qdrant instance and
install the `@langchain/qdrant` integration package.

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
npm i @langchain/qdrant @langchain/core @langchain/openai

```

```codeBlockLines_AdAo
yarn add @langchain/qdrant @langchain/core @langchain/openai

```

```codeBlockLines_AdAo
pnpm add @langchain/qdrant @langchain/core @langchain/openai

```

After installing the required dependencies, run a Qdrant instance with
Docker on your computer by following the [Qdrant setup\\
instructions](https://qdrant.tech/documentation/quickstart/). Note the
URL your container runs on.

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/qdrant/\#credentials "Direct link to Credentials")

Once you’ve done this set a `QDRANT_URL` environment variable:

```codeBlockLines_AdAo
// e.g. http://localhost:6333
process.env.QDRANT_URL = "your-qdrant-url";

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

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/qdrant/\#instantiation "Direct link to Instantiation")

```codeBlockLines_AdAo
import { QdrantVectorStore } from "@langchain/qdrant";
import { OpenAIEmbeddings } from "@langchain/openai";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

const vectorStore = await QdrantVectorStore.fromExistingCollection(embeddings, {
  url: process.env.QDRANT_URL,
  collectionName: "langchainjs-testing",
});

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/qdrant/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/qdrant/\#add-items-to-vector-store "Direct link to Add items to vector store")

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

await vectorStore.addDocuments(documents);

```

Top-level document ids and deletion are currently not supported.

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/qdrant/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/qdrant/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
const filter = {
  must: [{ key: "metadata.source", match: { value: "https://example.com" } }],
};

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

See [this page](https://qdrant.tech/documentation/concepts/filtering/)
for more on Qdrant filter syntax. Note that all values must be prefixed
with `metadata.`

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

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/qdrant/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

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

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/qdrant/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/qdrant/\#api-reference "Direct link to API reference")

For detailed documentation of all `QdrantVectorStore` features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_qdrant.QdrantVectorStore.html).

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/qdrant/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/qdrant/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#setup)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#add-items-to-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#query-directly)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#usage-for-retrieval-augmented-generation)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/qdrant/#related)