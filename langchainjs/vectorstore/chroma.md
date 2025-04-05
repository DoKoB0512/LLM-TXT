[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/chroma/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

[Chroma](https://docs.trychroma.com/getting-started) is a AI-native
open-source vector database focused on developer productivity and
happiness. Chroma is licensed under Apache 2.0.

This guide provides a quick overview for getting started with Chroma
[`vector stores`](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `Chroma` features and configurations head to the
[API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_chroma.Chroma.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#integration-details "Direct link to Integration details")

| Class | Package | [PY support](https://python.langchain.com/docs/integrations/vectorstores/chroma/) | Package latest |
| :-- | :-- | :-: | :-: |
| [`Chroma`](https://api.js.langchain.com/classes/langchain_community_vectorstores_chroma.Chroma.html) | [`@langchain/community`](https://www.npmjs.com/package/@langchain/community) | ✅ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/community?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#setup "Direct link to Setup")

To use Chroma vector stores, you’ll need to install the
`@langchain/community` integration package along with the [Chroma JS\\
SDK](https://www.npmjs.com/package/chromadb) as a peer dependency.

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
npm i @langchain/community @langchain/openai @langchain/core chromadb

```

```codeBlockLines_AdAo
yarn add @langchain/community @langchain/openai @langchain/core chromadb

```

```codeBlockLines_AdAo
pnpm add @langchain/community @langchain/openai @langchain/core chromadb

```

Next, follow the following instructions to run Chroma with Docker on
your computer:

```codeBlockLines_AdAo
docker pull chromadb/chroma
docker run -p 8000:8000 chromadb/chroma

```

You can see alternative setup instructions [in this\\
guide](https://docs.trychroma.com/getting-started).

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#credentials "Direct link to Credentials")

If you are running Chroma through Docker, you do not need to provide any
credentials.

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

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#instantiation "Direct link to Instantiation")

```codeBlockLines_AdAo
import { Chroma } from "@langchain/community/vectorstores/chroma";
import { OpenAIEmbeddings } from "@langchain/openai";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

const vectorStore = new Chroma(embeddings, {
  collectionName: "a-test-collection",
  url: "http://localhost:8000", // Optional, will default to this value
  collectionMetadata: {
    "hnsw:space": "cosine",
  }, // Optional, can be used to specify the distance method of the embedding space https://docs.trychroma.com/usage-guide#changing-the-distance-function
});

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#add-items-to-vector-store "Direct link to Add items to vector store")

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

### Delete items from vector store [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#delete-items-from-vector-store "Direct link to Delete items from vector store")

You can delete documents from Chroma by id as follows:

```codeBlockLines_AdAo
await vectorStore.delete({ ids: ["4"] });

```

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#query-directly "Direct link to Query directly")

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

See [this page](https://docs.trychroma.com/guides#filtering-by-metadata)
for more on Chroma filter syntax.

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

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

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

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#api-reference "Direct link to API reference")

For detailed documentation of all `Chroma` features and configurations
head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_chroma.Chroma.html)

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/chroma/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/chroma/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/chroma/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/chroma/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/chroma/#setup)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/chroma/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/chroma/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/chroma/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/chroma/#add-items-to-vector-store)
  - [Delete items from vector store](https://js.langchain.com/docs/integrations/vectorstores/chroma/#delete-items-from-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/chroma/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/chroma/#query-directly)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/chroma/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/chroma/#usage-for-retrieval-augmented-generation)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/chroma/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/chroma/#related)