[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/closevector/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# CloseVector

Compatibility

available on both browser and Node.js

[CloseVector](https://closevector.getmegaportal.com/) is a cross-platform vector database that can run in both the browser and Node.js. For example, you can create your index on Node.js and then load/query it on browser. For more information, please visit [CloseVector Docs](https://closevector-docs.getmegaportal.com/).

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/closevector/\#setup "Direct link to Setup")

### CloseVector Web [​](https://js.langchain.com/docs/integrations/vectorstores/closevector/\#closevector-web "Direct link to CloseVector Web")

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S closevector-web

```

```codeBlockLines_AdAo
yarn add closevector-web

```

```codeBlockLines_AdAo
pnpm add closevector-web

```

### CloseVector Node [​](https://js.langchain.com/docs/integrations/vectorstores/closevector/\#closevector-node "Direct link to CloseVector Node")

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S closevector-node

```

```codeBlockLines_AdAo
yarn add closevector-node

```

```codeBlockLines_AdAo
pnpm add closevector-node

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

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/closevector/\#usage "Direct link to Usage")

### Create a new index from texts [​](https://js.langchain.com/docs/integrations/vectorstores/closevector/\#create-a-new-index-from-texts "Direct link to Create a new index from texts")

```codeBlockLines_AdAo
// If you want to import the browser version, use the following line instead:
// import { CloseVectorWeb } from "@langchain/community/vectorstores/closevector/web";
import { CloseVectorNode } from "@langchain/community/vectorstores/closevector/node";
import { OpenAIEmbeddings } from "@langchain/openai";

export const run = async () => {
  // If you want to import the browser version, use the following line instead:
  // const vectorStore = await CloseVectorWeb.fromTexts(
  const vectorStore = await CloseVectorNode.fromTexts(
    ["Hello world", "Bye bye", "hello nice world"],
    [{ id: 2 }, { id: 1 }, { id: 3 }],
    new OpenAIEmbeddings()
  );

  const resultOne = await vectorStore.similaritySearch("hello world", 1);
  console.log(resultOne);
};

```

#### API Reference:

- CloseVectorNodefrom `@langchain/community/vectorstores/closevector/node`
- OpenAIEmbeddingsfrom `@langchain/openai`

### Create a new index from a loader [​](https://js.langchain.com/docs/integrations/vectorstores/closevector/\#create-a-new-index-from-a-loader "Direct link to Create a new index from a loader")

```codeBlockLines_AdAo
// If you want to import the browser version, use the following line instead:
// import { CloseVectorWeb } from "@langchain/community/vectorstores/closevector/web";
import { CloseVectorNode } from "@langchain/community/vectorstores/closevector/node";
import { OpenAIEmbeddings } from "@langchain/openai";
import { TextLoader } from "langchain/document_loaders/fs/text";

// Create docs with a loader
const loader = new TextLoader("src/document_loaders/example_data/example.txt");
const docs = await loader.load();

// Load the docs into the vector store
// If you want to import the browser version, use the following line instead:
// const vectorStore = await CloseVectorWeb.fromDocuments(
const vectorStore = await CloseVectorNode.fromDocuments(
  docs,
  new OpenAIEmbeddings()
);

// Search for the most similar document
const resultOne = await vectorStore.similaritySearch("hello world", 1);
console.log(resultOne);

```

#### API Reference:

- CloseVectorNodefrom `@langchain/community/vectorstores/closevector/node`
- OpenAIEmbeddingsfrom `@langchain/openai`
- TextLoaderfrom `langchain/document_loaders/fs/text`

### Save an index to CloseVector CDN and load it again [​](https://js.langchain.com/docs/integrations/vectorstores/closevector/\#save-an-index-to-closevector-cdn-and-load-it-again "Direct link to Save an index to CloseVector CDN and load it again")

CloseVector supports saving/loading indexes to/from cloud. To use this feature, you need to create an account on [CloseVector](https://closevector.getmegaportal.com/). Please read [CloseVector Docs](https://closevector-docs.getmegaportal.com/) and generate your API key first by [loging in](https://closevector.getmegaportal.com/).

```codeBlockLines_AdAo
// If you want to import the browser version, use the following line instead:
// import { CloseVectorWeb } from "@langchain/community/vectorstores/closevector/web";
import { CloseVectorNode } from "@langchain/community/vectorstores/closevector/node";
import { CloseVectorWeb } from "@langchain/community/vectorstores/closevector/web";
import { OpenAIEmbeddings } from "@langchain/openai";

// Create a vector store through any method, here from texts as an example
// If you want to import the browser version, use the following line instead:
// const vectorStore = await CloseVectorWeb.fromTexts(
const vectorStore = await CloseVectorNode.fromTexts(
  ["Hello world", "Bye bye", "hello nice world"],
  [{ id: 2 }, { id: 1 }, { id: 3 }],
  new OpenAIEmbeddings(),
  undefined,
  {
    key: "your access key",
    secret: "your secret",
  }
);

// Save the vector store to cloud
await vectorStore.saveToCloud({
  description: "example",
  public: true,
});

const { uuid } = vectorStore.instance;

// Load the vector store from cloud
// const loadedVectorStore = await CloseVectorWeb.load(
const loadedVectorStore = await CloseVectorNode.loadFromCloud({
  uuid,
  embeddings: new OpenAIEmbeddings(),
  credentials: {
    key: "your access key",
    secret: "your secret",
  },
});

// If you want to import the node version, use the following lines instead:
// const loadedVectorStoreOnNode = await CloseVectorNode.loadFromCloud({
//   uuid,
//   embeddings: new OpenAIEmbeddings(),
//   credentials: {
//     key: "your access key",
//     secret: "your secret"
//   }
// });

const loadedVectorStoreOnBrowser = await CloseVectorWeb.loadFromCloud({
  uuid,
  embeddings: new OpenAIEmbeddings(),
  credentials: {
    key: "your access key",
    secret: "your secret",
  },
});

// vectorStore and loadedVectorStore are identical
const result = await loadedVectorStore.similaritySearch("hello world", 1);
console.log(result);

// or
const resultOnBrowser = await loadedVectorStoreOnBrowser.similaritySearch(
  "hello world",
  1
);
console.log(resultOnBrowser);

```

#### API Reference:

- CloseVectorNodefrom `@langchain/community/vectorstores/closevector/node`
- CloseVectorWebfrom `@langchain/community/vectorstores/closevector/web`
- OpenAIEmbeddingsfrom `@langchain/openai`

### Save an index to file and load it again [​](https://js.langchain.com/docs/integrations/vectorstores/closevector/\#save-an-index-to-file-and-load-it-again "Direct link to Save an index to file and load it again")

```codeBlockLines_AdAo
// If you want to import the browser version, use the following line instead:
// import { CloseVectorWeb } from "@langchain/community/vectorstores/closevector/web";
import { CloseVectorNode } from "@langchain/community/vectorstores/closevector/node";
import { OpenAIEmbeddings } from "@langchain/openai";

// Create a vector store through any method, here from texts as an example
// If you want to import the browser version, use the following line instead:
// const vectorStore = await CloseVectorWeb.fromTexts(
const vectorStore = await CloseVectorNode.fromTexts(
  ["Hello world", "Bye bye", "hello nice world"],
  [{ id: 2 }, { id: 1 }, { id: 3 }],
  new OpenAIEmbeddings()
);

// Save the vector store to a directory
const directory = "your/directory/here";

await vectorStore.save(directory);

// Load the vector store from the same directory
// If you want to import the browser version, use the following line instead:
// const loadedVectorStore = await CloseVectorWeb.load(
const loadedVectorStore = await CloseVectorNode.load(
  directory,
  new OpenAIEmbeddings()
);

// vectorStore and loadedVectorStore are identical
const result = await loadedVectorStore.similaritySearch("hello world", 1);
console.log(result);

```

#### API Reference:

- CloseVectorNodefrom `@langchain/community/vectorstores/closevector/node`
- OpenAIEmbeddingsfrom `@langchain/openai`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/closevector/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/closevector/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/closevector/#setup)
  - [CloseVector Web](https://js.langchain.com/docs/integrations/vectorstores/closevector/#closevector-web)
  - [CloseVector Node](https://js.langchain.com/docs/integrations/vectorstores/closevector/#closevector-node)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/closevector/#usage)
  - [Create a new index from texts](https://js.langchain.com/docs/integrations/vectorstores/closevector/#create-a-new-index-from-texts)
  - [Create a new index from a loader](https://js.langchain.com/docs/integrations/vectorstores/closevector/#create-a-new-index-from-a-loader)
  - [Save an index to CloseVector CDN and load it again](https://js.langchain.com/docs/integrations/vectorstores/closevector/#save-an-index-to-closevector-cdn-and-load-it-again)
  - [Save an index to file and load it again](https://js.langchain.com/docs/integrations/vectorstores/closevector/#save-an-index-to-file-and-load-it-again)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/closevector/#related)