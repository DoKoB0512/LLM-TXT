[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/zep/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Zep Open Source

> [Zep](https://www.getzep.com/) is a long-term memory service for AI Assistant apps.
> With Zep, you can provide AI assistants with the ability to recall past conversations, no matter how distant,
> while also reducing hallucinations, latency, and cost.

> Interested in Zep Cloud? See [Zep Cloud Installation Guide](https://help.getzep.com/sdks)

**Note:** The `ZepVectorStore` works with `Documents` and is intended to be used as a `Retriever`.
It offers separate functionality to Zep's `ZepMemory` class, which is designed for persisting, enriching
and searching your user's chat history.

## Why Zep's VectorStore? 🤖🚀 [​](https://js.langchain.com/docs/integrations/vectorstores/zep/\#why-zeps-vectorstore- "Direct link to Why Zep's VectorStore? 🤖🚀")

Zep automatically embeds documents added to the Zep Vector Store using low-latency models local to the Zep server.
The Zep TS/JS client can be used in non-Node edge environments. These two together with Zep's chat memory functionality
make Zep ideal for building conversational LLM apps where latency and performance are important.

### Supported Search Types [​](https://js.langchain.com/docs/integrations/vectorstores/zep/\#supported-search-types "Direct link to Supported Search Types")

Zep supports both similarity search and Maximal Marginal Relevance (MMR) search. MMR search is particularly useful
for Retrieval Augmented Generation applications as it re-ranks results to ensure diversity in the returned documents.

## Installation [​](https://js.langchain.com/docs/integrations/vectorstores/zep/\#installation "Direct link to Installation")

Follow the [Zep Open Source Quickstart Guide](https://docs.getzep.com/deployment/quickstart/) to install and get started with Zep.

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/zep/\#usage "Direct link to Usage")

You'll need your Zep API URL and optionally an API key to use the Zep VectorStore. See the [Zep docs](https://docs.getzep.com/) for more information.

In the examples below, we're using Zep's auto-embedding feature which automatically embed documents on the Zep server using
low-latency embedding models. Since LangChain requires passing in a `Embeddings` instance, we pass in `FakeEmbeddings`.

**Note:** If you pass in an `Embeddings` instance other than `FakeEmbeddings`, this class will be used to embed documents.
You must also set your document collection to `isAutoEmbedded === false`. See the `OpenAIEmbeddings` example below.

### Example: Creating a ZepVectorStore from Documents & Querying [​](https://js.langchain.com/docs/integrations/vectorstores/zep/\#example-creating-a-zepvectorstore-from-documents--querying "Direct link to Example: Creating a ZepVectorStore from Documents & Querying")

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @langchain/openai @langchain/community @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/openai @langchain/community @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/openai @langchain/community @langchain/core

```

```codeBlockLines_AdAo
import { ZepVectorStore } from "@langchain/community/vectorstores/zep";
import { FakeEmbeddings } from "@langchain/core/utils/testing";
import { TextLoader } from "langchain/document_loaders/fs/text";
import { randomUUID } from "crypto";

const loader = new TextLoader("src/document_loaders/example_data/example.txt");
const docs = await loader.load();
export const run = async () => {
  const collectionName = `collection${randomUUID().split("-")[0]}`;

  const zepConfig = {
    apiUrl: "http://localhost:8000", // this should be the URL of your Zep implementation
    collectionName,
    embeddingDimensions: 1536, // this much match the width of the embeddings you're using
    isAutoEmbedded: true, // If true, the vector store will automatically embed documents when they are added
  };

  const embeddings = new FakeEmbeddings();

  const vectorStore = await ZepVectorStore.fromDocuments(
    docs,
    embeddings,
    zepConfig
  );

  // Wait for the documents to be embedded
  // eslint-disable-next-line no-constant-condition
  while (true) {
    const c = await vectorStore.client.document.getCollection(collectionName);
    console.log(
      `Embedding status: ${c.document_embedded_count}/${c.document_count} documents embedded`
    );
    // eslint-disable-next-line no-promise-executor-return
    await new Promise((resolve) => setTimeout(resolve, 1000));
    if (c.status === "ready") {
      break;
    }
  }

  const results = await vectorStore.similaritySearchWithScore("bar", 3);

  console.log("Similarity Results:");
  console.log(JSON.stringify(results));

  const results2 = await vectorStore.maxMarginalRelevanceSearch("bar", {
    k: 3,
  });

  console.log("MMR Results:");
  console.log(JSON.stringify(results2));
};

```

#### API Reference:

- ZepVectorStorefrom `@langchain/community/vectorstores/zep`
- FakeEmbeddingsfrom `@langchain/core/utils/testing`
- TextLoaderfrom `langchain/document_loaders/fs/text`

### Example: Querying a ZepVectorStore using a metadata filter [​](https://js.langchain.com/docs/integrations/vectorstores/zep/\#example-querying-a-zepvectorstore-using-a-metadata-filter "Direct link to Example: Querying a ZepVectorStore using a metadata filter")

```codeBlockLines_AdAo
import { ZepVectorStore } from "@langchain/community/vectorstores/zep";
import { FakeEmbeddings } from "@langchain/core/utils/testing";
import { randomUUID } from "crypto";
import { Document } from "@langchain/core/documents";

const docs = [\
  new Document({\
    metadata: { album: "Led Zeppelin IV", year: 1971 },\
    pageContent:\
      "Stairway to Heaven is one of the most iconic songs by Led Zeppelin.",\
  }),\
  new Document({\
    metadata: { album: "Led Zeppelin I", year: 1969 },\
    pageContent:\
      "Dazed and Confused was a standout track on Led Zeppelin's debut album.",\
  }),\
  new Document({\
    metadata: { album: "Physical Graffiti", year: 1975 },\
    pageContent:\
      "Kashmir, from Physical Graffiti, showcases Led Zeppelin's unique blend of rock and world music.",\
  }),\
  new Document({\
    metadata: { album: "Houses of the Holy", year: 1973 },\
    pageContent:\
      "The Rain Song is a beautiful, melancholic piece from Houses of the Holy.",\
  }),\
  new Document({\
    metadata: { band: "Black Sabbath", album: "Paranoid", year: 1970 },\
    pageContent:\
      "Paranoid is Black Sabbath's second studio album and includes some of their most notable songs.",\
  }),\
  new Document({\
    metadata: {\
      band: "Iron Maiden",\
      album: "The Number of the Beast",\
      year: 1982,\
    },\
    pageContent:\
      "The Number of the Beast is often considered Iron Maiden's best album.",\
  }),\
  new Document({\
    metadata: { band: "Metallica", album: "Master of Puppets", year: 1986 },\
    pageContent:\
      "Master of Puppets is widely regarded as Metallica's finest work.",\
  }),\
  new Document({\
    metadata: { band: "Megadeth", album: "Rust in Peace", year: 1990 },\
    pageContent:\
      "Rust in Peace is Megadeth's fourth studio album and features intricate guitar work.",\
  }),\
];

export const run = async () => {
  const collectionName = `collection${randomUUID().split("-")[0]}`;

  const zepConfig = {
    apiUrl: "http://localhost:8000", // this should be the URL of your Zep implementation
    collectionName,
    embeddingDimensions: 1536, // this much match the width of the embeddings you're using
    isAutoEmbedded: true, // If true, the vector store will automatically embed documents when they are added
  };

  const embeddings = new FakeEmbeddings();

  const vectorStore = await ZepVectorStore.fromDocuments(
    docs,
    embeddings,
    zepConfig
  );

  // Wait for the documents to be embedded
  // eslint-disable-next-line no-constant-condition
  while (true) {
    const c = await vectorStore.client.document.getCollection(collectionName);
    console.log(
      `Embedding status: ${c.document_embedded_count}/${c.document_count} documents embedded`
    );
    // eslint-disable-next-line no-promise-executor-return
    await new Promise((resolve) => setTimeout(resolve, 1000));
    if (c.status === "ready") {
      break;
    }
  }

  vectorStore
    .similaritySearchWithScore("sad music", 3, {
      where: { jsonpath: "$[*] ? (@.year == 1973)" }, // We should see a single result: The Rain Song
    })
    .then((results) => {
      console.log(`\n\nSimilarity Results:\n${JSON.stringify(results)}`);
    })
    .catch((e) => {
      if (e.name === "NotFoundError") {
        console.log("No results found");
      } else {
        throw e;
      }
    });

  // We're not filtering here, but rather demonstrating MMR at work.
  // We could also add a filter to the MMR search, as we did with the similarity search above.
  vectorStore
    .maxMarginalRelevanceSearch("sad music", {
      k: 3,
    })
    .then((results) => {
      console.log(`\n\nMMR Results:\n${JSON.stringify(results)}`);
    })
    .catch((e) => {
      if (e.name === "NotFoundError") {
        console.log("No results found");
      } else {
        throw e;
      }
    });
};

```

#### API Reference:

- ZepVectorStorefrom `@langchain/community/vectorstores/zep`
- FakeEmbeddingsfrom `@langchain/core/utils/testing`
- Documentfrom `@langchain/core/documents`

### Example: Using a LangChain Embedding Class such as `OpenAIEmbeddings` [​](https://js.langchain.com/docs/integrations/vectorstores/zep/\#example-using-a-langchain-embedding-class-such-as-openaiembeddings "Direct link to example-using-a-langchain-embedding-class-such-as-openaiembeddings")

```codeBlockLines_AdAo
import { ZepVectorStore } from "@langchain/community/vectorstores/zep";
import { OpenAIEmbeddings } from "@langchain/openai";
import { TextLoader } from "langchain/document_loaders/fs/text";
import { randomUUID } from "crypto";

const loader = new TextLoader("src/document_loaders/example_data/example.txt");
const docs = await loader.load();
export const run = async () => {
  const collectionName = `collection${randomUUID().split("-")[0]}`;

  const zepConfig = {
    apiUrl: "http://localhost:8000", // this should be the URL of your Zep implementation
    collectionName,
    embeddingDimensions: 1536, // this much match the width of the embeddings you're using
    isAutoEmbedded: false, // set to false to disable auto-embedding
  };

  const embeddings = new OpenAIEmbeddings();

  const vectorStore = await ZepVectorStore.fromDocuments(
    docs,
    embeddings,
    zepConfig
  );

  const results = await vectorStore.similaritySearchWithScore("bar", 3);

  console.log("Similarity Results:");
  console.log(JSON.stringify(results));

  const results2 = await vectorStore.maxMarginalRelevanceSearch("bar", {
    k: 3,
  });

  console.log("MMR Results:");
  console.log(JSON.stringify(results2));
};

```

#### API Reference:

- ZepVectorStorefrom `@langchain/community/vectorstores/zep`
- OpenAIEmbeddingsfrom `@langchain/openai`
- TextLoaderfrom `langchain/document_loaders/fs/text`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/zep/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/zep/%3E).

- [Why Zep's VectorStore? 🤖🚀](https://js.langchain.com/docs/integrations/vectorstores/zep/#why-zeps-vectorstore-)
  - [Supported Search Types](https://js.langchain.com/docs/integrations/vectorstores/zep/#supported-search-types)
- [Installation](https://js.langchain.com/docs/integrations/vectorstores/zep/#installation)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/zep/#usage)
  - [Example: Creating a ZepVectorStore from Documents & Querying](https://js.langchain.com/docs/integrations/vectorstores/zep/#example-creating-a-zepvectorstore-from-documents--querying)
  - [Example: Querying a ZepVectorStore using a metadata filter](https://js.langchain.com/docs/integrations/vectorstores/zep/#example-querying-a-zepvectorstore-using-a-metadata-filter)
  - [Example: Using a LangChain Embedding Class such as `OpenAIEmbeddings`](https://js.langchain.com/docs/integrations/vectorstores/zep/#example-using-a-langchain-embedding-class-such-as-openaiembeddings)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/zep/#related)