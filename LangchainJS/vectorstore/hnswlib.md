[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

Compatibility

Only available on Node.js.

HNSWLib is an in-memory vector store that can be saved to a file. It
uses the [HNSWLib library](https://github.com/nmslib/hnswlib).

This guide provides a quick overview for getting started with HNSWLib
[vector stores](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `HNSWLib` features and configurations head to the
[API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_hnswlib.HNSWLib.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#integration-details "Direct link to Integration details")

| Class | Package | PY support | Package latest |
| :-- | :-- | :-: | :-: |
| [`HNSWLib`](https://api.js.langchain.com/classes/langchain_community_vectorstores_hnswlib.HNSWLib.html) | [`@langchain/community`](https://npmjs.com/@langchain/community) | ❌ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/community?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#setup "Direct link to Setup")

To use HNSWLib vector stores, you’ll need to install the
`@langchain/community` integration package with the
[`hnswlib-node`](https://www.npmjs.com/package/hnswlib-node) package as
a peer dependency.

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
npm i @langchain/community hnswlib-node @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/community hnswlib-node @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/community hnswlib-node @langchain/openai @langchain/core

```

caution

**On Windows**, you might need to install [Visual Studio](https://visualstudio.microsoft.com/downloads/) first in order to properly build the `hnswlib-node` package.

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#credentials "Direct link to Credentials")

Because HNSWLib runs locally, you do not need any credentials to use it.

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

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#instantiation "Direct link to Instantiation")

```codeBlockLines_AdAo
import { HNSWLib } from "@langchain/community/vectorstores/hnswlib";
import { OpenAIEmbeddings } from "@langchain/openai";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

const vectorStore = await HNSWLib.fromDocuments([], embeddings);

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#add-items-to-vector-store "Direct link to Add items to vector store")

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

Deletion and ids for individual documents are not currently supported.

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#query-directly "Direct link to Query directly")

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
* [SIM=0.835] The powerhouse of the cell is the mitochondria [{"source":"https://example.com"}]
* [SIM=0.852] Mitochondria are made out of lipids [{"source":"https://example.com"}]

```

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

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
  {\
    pageContent: 'The powerhouse of the cell is the mitochondria',\
    metadata: { source: 'https://example.com' }\
  },\
  {\
    pageContent: 'Mitochondria are made out of lipids',\
    metadata: { source: 'https://example.com' }\
  }\
]

```

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## Save to/load from file [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#save-toload-from-file "Direct link to Save to/load from file")

HNSWLib supports saving your index to a file, then reloading it at a
later date:

```codeBlockLines_AdAo
// Save the vector store to a directory
const directory = "your/directory/here";
await vectorStore.save(directory);

// Load the vector store from the same directory
const loadedVectorStore = await HNSWLib.load(directory, new OpenAIEmbeddings());

// vectorStore and loadedVectorStore are identical
await loadedVectorStore.similaritySearch("hello world", 1);

```

### Delete a saved index [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#delete-a-saved-index "Direct link to Delete a saved index")

You can use the `.delete` method to clear an index saved to a given
directory:

```codeBlockLines_AdAo
// Load the vector store from the same directory
const savedVectorStore = await HNSWLib.load(directory, new OpenAIEmbeddings());

await savedVectorStore.delete({ directory });

```

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#api-reference "Direct link to API reference")

For detailed documentation of all `HNSWLib` features and configurations
head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_hnswlib.HNSWLib.html).

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/hnswlib/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#setup)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#add-items-to-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#query-directly)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#usage-for-retrieval-augmented-generation)
- [Save to/load from file](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#save-toload-from-file)
  - [Delete a saved index](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#delete-a-saved-index)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/hnswlib/#related)