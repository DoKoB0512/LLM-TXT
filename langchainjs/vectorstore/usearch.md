[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/usearch/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# USearch

Compatibility

Only available on Node.js.

[USearch](https://github.com/unum-cloud/usearch) is a library for efficient similarity search and clustering of dense vectors.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/usearch/\#setup "Direct link to Setup")

Install the [usearch](https://github.com/unum-cloud/usearch/tree/main/javascript) package, which is a Node.js binding for [USearch](https://github.com/unum-cloud/usearch).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S usearch

```

```codeBlockLines_AdAo
yarn add usearch

```

```codeBlockLines_AdAo
pnpm add usearch

```

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

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/usearch/\#usage "Direct link to Usage")

### Create a new index from texts [​](https://js.langchain.com/docs/integrations/vectorstores/usearch/\#create-a-new-index-from-texts "Direct link to Create a new index from texts")

```codeBlockLines_AdAo
import { USearch } from "@langchain/community/vectorstores/usearch";
import { OpenAIEmbeddings } from "@langchain/openai";

const vectorStore = await USearch.fromTexts(
  ["Hello world", "Bye bye", "hello nice world"],
  [{ id: 2 }, { id: 1 }, { id: 3 }],
  new OpenAIEmbeddings()
);

const resultOne = await vectorStore.similaritySearch("hello world", 1);
console.log(resultOne);

```

#### API Reference:

- USearchfrom `@langchain/community/vectorstores/usearch`
- OpenAIEmbeddingsfrom `@langchain/openai`

### Create a new index from a loader [​](https://js.langchain.com/docs/integrations/vectorstores/usearch/\#create-a-new-index-from-a-loader "Direct link to Create a new index from a loader")

```codeBlockLines_AdAo
import { USearch } from "@langchain/community/vectorstores/usearch";
import { OpenAIEmbeddings } from "@langchain/openai";
import { TextLoader } from "langchain/document_loaders/fs/text";

// Create docs with a loader
const loader = new TextLoader("src/document_loaders/example_data/example.txt");
const docs = await loader.load();

// Load the docs into the vector store
const vectorStore = await USearch.fromDocuments(docs, new OpenAIEmbeddings());

// Search for the most similar document
const resultOne = await vectorStore.similaritySearch("hello world", 1);
console.log(resultOne);

```

#### API Reference:

- USearchfrom `@langchain/community/vectorstores/usearch`
- OpenAIEmbeddingsfrom `@langchain/openai`
- TextLoaderfrom `langchain/document_loaders/fs/text`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/usearch/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/usearch/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/usearch/#setup)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/usearch/#usage)
  - [Create a new index from texts](https://js.langchain.com/docs/integrations/vectorstores/usearch/#create-a-new-index-from-texts)
  - [Create a new index from a loader](https://js.langchain.com/docs/integrations/vectorstores/usearch/#create-a-new-index-from-a-loader)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/usearch/#related)