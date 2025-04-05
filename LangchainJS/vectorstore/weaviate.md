[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

[Weaviate](https://weaviate.io/) is an open source vector database that
stores both objects and vectors, allowing for combining vector search
with structured filtering. LangChain connects to Weaviate via the
weaviate-ts-client package, the official Typescript client for Weaviate.

This guide provides a quick overview for getting started with Weaviate
[vector stores](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `WeaviateStore` features and configurations head to
the [API\\
reference](https://api.js.langchain.com/classes/langchain_weaviate.WeaviateStore.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#integration-details "Direct link to Integration details")

| Class | Package | [PY support](https://python.langchain.com/docs/integrations/vectorstores/weaviate/) | Package latest |
| :-- | :-- | :-: | :-: |
| [`WeaviateStore`](https://api.js.langchain.com/classes/langchain_weaviate.WeaviateStore.html) | [`@langchain/weaviate`](https://npmjs.com/@langchain/weaviate) | ✅ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/weaviate?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#setup "Direct link to Setup")

To use Weaviate vector stores, you’ll need to set up a Weaviate instance
and install the `@langchain/weaviate` integration package. You should
also install the `weaviate-ts-client` package to initialize a client to
connect to your instance with, and the `uuid` package if you want to
assign indexed documents ids.

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
npm i @langchain/weaviate @langchain/core weaviate-ts-client uuid @langchain/openai

```

```codeBlockLines_AdAo
yarn add @langchain/weaviate @langchain/core weaviate-ts-client uuid @langchain/openai

```

```codeBlockLines_AdAo
pnpm add @langchain/weaviate @langchain/core weaviate-ts-client uuid @langchain/openai

```

You’ll need to run Weaviate either locally or on a server. See [the\\
Weaviate\\
documentation](https://weaviate.io/developers/weaviate/installation) for
more information.

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#credentials "Direct link to Credentials")

Once you’ve set up your instance, set the following environment
variables:

```codeBlockLines_AdAo
// http or https
process.env.WEAVIATE_SCHEME = "";
// If running locally, include port e.g. "localhost:8080"
process.env.WEAVIATE_HOST = "YOUR_HOSTNAME";
// Optional, for cloud deployments
process.env.WEAVIATE_API_KEY = "YOUR_API_KEY";

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

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#instantiation "Direct link to Instantiation")

```codeBlockLines_AdAo
import { WeaviateStore } from "@langchain/weaviate";
import { OpenAIEmbeddings } from "@langchain/openai";

import weaviate from "weaviate-ts-client";
// import { ApiKey } from "weaviate-ts-client"

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

// The Weaviate SDK has an issue with types
const weaviateClient = (weaviate as any).client({
  scheme: process.env.WEAVIATE_SCHEME ?? "http",
  host: process.env.WEAVIATE_HOST ?? "localhost",
  // If necessary
  // apiKey: new ApiKey(process.env.WEAVIATE_API_KEY ?? "default"),
});

const vectorStore = new WeaviateStore(embeddings, {
  client: weaviateClient,
  // Must start with a capital letter
  indexName: "Langchainjs_test",
  // Default value
  textKey: "text",
  // Any keys you intend to set as metadata
  metadataKeys: ["source"],
});

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#add-items-to-vector-store "Direct link to Add items to vector store")

**Note:** If you want to associate ids with your indexed documents, they
must be UUIDs.

```codeBlockLines_AdAo
import type { Document } from "@langchain/core/documents";
import { v4 as uuidv4 } from "uuid";

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
const uuids = [uuidv4(), uuidv4(), uuidv4(), uuidv4()];

await vectorStore.addDocuments(documents, { ids: uuids });

```

```codeBlockLines_AdAo
[\
  '610f9b92-9bee-473f-a4db-8f2ca6e3442d',\
  '995160fa-441e-41a0-b476-cf3785518a0d',\
  '0cdbe6d4-0df8-4f99-9b67-184009fee9a2',\
  '18a8211c-0649-467b-a7c5-50ebb4b9ca9d'\
]

```

### Delete items from vector store [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#delete-items-from-vector-store "Direct link to Delete items from vector store")

You can delete by id as by passing a `filter` param:

```codeBlockLines_AdAo
await vectorStore.delete({ ids: [uuids[3]] });

```

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
const filter = {
  where: {
    operator: "Equal" as const,
    path: ["source"],
    valueText: "https://example.com",
  },
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

See [this\\
page](https://weaviate.io/developers/weaviate/api/graphql/filters) for
more on Weaviat filter syntax.

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

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

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

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#api-reference "Direct link to API reference")

For detailed documentation of all `WeaviateStore` features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_weaviate.WeaviateStore.html).

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/weaviate/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/weaviate/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#setup)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#add-items-to-vector-store)
  - [Delete items from vector store](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#delete-items-from-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#query-directly)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#usage-for-retrieval-augmented-generation)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/weaviate/#related)