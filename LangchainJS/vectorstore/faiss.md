[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/faiss/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

Compatibility

Only available on Node.js.

[Faiss](https://github.com/facebookresearch/faiss) is a library for
efficient similarity search and clustering of dense vectors.

LangChain.js supports using Faiss as a locally-running vectorstore that
can be saved to a file. It also provides the ability to read the saved
file from the [LangChain Python\\
implementation](https://python.langchain.com/docs/integrations/vectorstores/faiss#saving-and-loading).

This guide provides a quick overview for getting started with Faiss
[vector stores](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `FaissStore` features and configurations head to
the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_faiss.FaissStore.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#integration-details "Direct link to Integration details")

| Class | Package | [PY support](https://python.langchain.com/docs/integrations/vectorstores/faiss) | Package latest |
| :-- | :-- | :-: | :-: |
| [`FaissStore`](https://api.js.langchain.com/classes/langchain_community_vectorstores_faiss.FaissStore.html) | [`@langchain/community`](https://npmjs.com/@langchain/community) | ✅ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/community?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#setup "Direct link to Setup")

To use Faiss vector stores, you’ll need to install the
`@langchain/community` integration package and the
[`faiss-node`](https://github.com/ewfian/faiss-node) package as a peer
dependency.

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
npm i @langchain/community faiss-node @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/community faiss-node @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/community faiss-node @langchain/openai @langchain/core

```

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#credentials "Direct link to Credentials")

Because Faiss runs locally, you do not need any credentials to use it.

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

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#instantiation "Direct link to Instantiation")

```codeBlockLines_AdAo
import { FaissStore } from "@langchain/community/vectorstores/faiss";
import { OpenAIEmbeddings } from "@langchain/openai";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

const vectorStore = new FaissStore(embeddings, {});

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#add-items-to-vector-store "Direct link to Add items to vector store")

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

### Delete items from vector store [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#delete-items-from-vector-store "Direct link to Delete items from vector store")

```codeBlockLines_AdAo
await vectorStore.delete({ ids: ["4"] });

```

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#query-directly "Direct link to Query directly")

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

```codeBlockLines_AdAo
* The powerhouse of the cell is the mitochondria [{"source":"https://example.com"}]
* Mitochondria are made out of lipids [{"source":"https://example.com"}]

```

Filtering by metadata is currently not supported.

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
* [SIM=1.671] The powerhouse of the cell is the mitochondria [{"source":"https://example.com"}]
* [SIM=1.705] Mitochondria are made out of lipids [{"source":"https://example.com"}]

```

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

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

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## Merging indexes [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#merging-indexes "Direct link to Merging indexes")

Faiss also supports merging existing indexes:

```codeBlockLines_AdAo
// Create an initial vector store
const initialStore = await FaissStore.fromTexts(
  ["Hello world", "Bye bye", "hello nice world"],
  [{ id: 2 }, { id: 1 }, { id: 3 }],
  new OpenAIEmbeddings()
);

// Create another vector store from texts
const newStore = await FaissStore.fromTexts(
  ["Some text"],
  [{ id: 1 }],
  new OpenAIEmbeddings()
);

// merge the first vector store into vectorStore2
await newStore.mergeFrom(initialStore);

// You can also create a new vector store from another FaissStore index
const newStore2 = await FaissStore.fromIndex(newStore, new OpenAIEmbeddings());

await newStore2.similaritySearch("Bye bye", 1);

```

## Save an index to file and load it again [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#save-an-index-to-file-and-load-it-again "Direct link to Save an index to file and load it again")

To persist an index on disk, use the `.save` and static `.load` methods:

```codeBlockLines_AdAo
// Create a vector store through any method, here from texts as an example
const persistentStore = await FaissStore.fromTexts(
  ["Hello world", "Bye bye", "hello nice world"],
  [{ id: 2 }, { id: 1 }, { id: 3 }],
  new OpenAIEmbeddings()
);

// Save the vector store to a directory
const directory = "your/directory/here";

await persistentStore.save(directory);

// Load the vector store from the same directory
const loadedVectorStore = await FaissStore.load(
  directory,
  new OpenAIEmbeddings()
);

// vectorStore and loadedVectorStore are identical
const result = await loadedVectorStore.similaritySearch("hello world", 1);
console.log(result);

```

## Reading saved files from Python [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#reading-saved-files-from-python "Direct link to Reading saved files from Python")

To enable the ability to read the saved file from [LangChain Python’s\\
implementation](https://python.langchain.com/docs/integrations/vectorstores/faiss#saving-and-loading),
you’ll need to install the
[`pickleparser`](https://github.com/ewfian/pickleparser) package.

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i pickleparser

```

```codeBlockLines_AdAo
yarn add pickleparser

```

```codeBlockLines_AdAo
pnpm add pickleparser

```

Then you can use the `.loadFromPython` static method:

```codeBlockLines_AdAo
// The directory of data saved from Python
const directoryWithSavedPythonStore = "your/directory/here";

// Load the vector store from the directory
const pythonLoadedStore = await FaissStore.loadFromPython(
  directoryWithSavedPythonStore,
  new OpenAIEmbeddings()
);

// Search for the most similar document
await pythonLoadedStore.similaritySearch("test", 2);

```

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#api-reference "Direct link to API reference")

For detailed documentation of all `FaissStore` features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_faiss.FaissStore.html)

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/faiss/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/faiss/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/faiss/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/faiss/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/faiss/#setup)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/faiss/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/faiss/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/faiss/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/faiss/#add-items-to-vector-store)
  - [Delete items from vector store](https://js.langchain.com/docs/integrations/vectorstores/faiss/#delete-items-from-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/faiss/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/faiss/#query-directly)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/faiss/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/faiss/#usage-for-retrieval-augmented-generation)
- [Merging indexes](https://js.langchain.com/docs/integrations/vectorstores/faiss/#merging-indexes)
- [Save an index to file and load it again](https://js.langchain.com/docs/integrations/vectorstores/faiss/#save-an-index-to-file-and-load-it-again)
- [Reading saved files from Python](https://js.langchain.com/docs/integrations/vectorstores/faiss/#reading-saved-files-from-python)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/faiss/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/faiss/#related)