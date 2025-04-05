[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

[Pinecone](https://www.pinecone.io/) is a vector database that helps
power AI for some of the world’s best companies.

This guide provides a quick overview for getting started with Pinecone
[vector stores](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `PineconeStore` features and configurations head to
the [API\\
reference](https://api.js.langchain.com/classes/langchain_pinecone.PineconeStore.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#integration-details "Direct link to Integration details")

| Class | Package | [PY support](https://python.langchain.com/docs/integrations/vectorstores/pinecone/) | Package latest |
| :-- | :-- | :-: | :-: |
| [`PineconeStore`](https://api.js.langchain.com/classes/langchain_pinecone.PineconeStore.html) | [`@langchain/pinecone`](https://npmjs.com/@langchain/pinecone) | ✅ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/pinecone?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#setup "Direct link to Setup")

To use Pinecone vector stores, you’ll need to create a Pinecone account,
initialize an index, and install the `@langchain/pinecone` integration
package. You’ll also want to install the [official Pinecone\\
SDK](https://www.npmjs.com/package/@pinecone-database/pinecone) to
initialize a client to pass into the `PineconeStore` instance.

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
npm i @langchain/pinecone @langchain/openai @langchain/core @pinecone-database/pinecone@5

```

```codeBlockLines_AdAo
yarn add @langchain/pinecone @langchain/openai @langchain/core @pinecone-database/pinecone@5

```

```codeBlockLines_AdAo
pnpm add @langchain/pinecone @langchain/openai @langchain/core @pinecone-database/pinecone@5

```

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#credentials "Direct link to Credentials")

Sign up for a [Pinecone](https://www.pinecone.io/) account and create an
index. Make sure the dimensions match those of the embeddings you want
to use (the default is 1536 for OpenAI’s `text-embedding-3-small`). Once
you’ve done this set the `PINECONE_INDEX`, `PINECONE_API_KEY`, and
(optionally) `PINECONE_ENVIRONMENT` environment variables:

```codeBlockLines_AdAo
process.env.PINECONE_API_KEY = "your-pinecone-api-key";
process.env.PINECONE_INDEX = "your-pinecone-index";

// Optional
process.env.PINECONE_ENVIRONMENT = "your-pinecone-environment";

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

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#instantiation "Direct link to Instantiation")

```codeBlockLines_AdAo
import { PineconeStore } from "@langchain/pinecone";
import { OpenAIEmbeddings } from "@langchain/openai";

import { Pinecone as PineconeClient } from "@pinecone-database/pinecone";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

const pinecone = new PineconeClient();
// Will automatically read the PINECONE_API_KEY and PINECONE_ENVIRONMENT env vars
const pineconeIndex = pinecone.Index(process.env.PINECONE_INDEX!);

const vectorStore = await PineconeStore.fromExistingIndex(embeddings, {
  pineconeIndex,
  // Maximum number of batch requests to allow at once. Each batch is 1000 vectors.
  maxConcurrency: 5,
  // You can pass a namespace here too
  // namespace: "foo",
});

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#add-items-to-vector-store "Direct link to Add items to vector store")

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

**Note:** After adding documents, there is a slight delay before they
become queryable.

### Delete items from vector store [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#delete-items-from-vector-store "Direct link to Delete items from vector store")

```codeBlockLines_AdAo
await vectorStore.delete({ ids: ["4"] });

```

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
// Optional filter
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

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

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

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#api-reference "Direct link to API reference")

For detailed documentation of all `PineconeStore` features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_pinecone.PineconeStore.html).

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/pinecone/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/pinecone/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#setup)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#add-items-to-vector-store)
  - [Delete items from vector store](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#delete-items-from-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#query-directly)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#usage-for-retrieval-augmented-generation)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/pinecone/#related)