[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Momento Vector Index (MVI)

[MVI](https://gomomento.com/): the most productive, easiest to use, serverless vector index for your data. To get started with MVI, simply sign up for an account. There's no need to handle infrastructure, manage servers, or be concerned about scaling. MVI is a service that scales automatically to meet your needs. Whether in Node.js, browser, or edge, Momento has you covered.

To sign up and access MVI, visit the [Momento Console](https://console.gomomento.com/).

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index/\#setup "Direct link to Setup")

1. Sign up for an API key in the [Momento Console](https://console.gomomento.com/).

2. Install the SDK for your environment.

2.1. For **Node.js**:



- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @gomomento/sdk

```

```codeBlockLines_AdAo
yarn add @gomomento/sdk

```

```codeBlockLines_AdAo
pnpm add @gomomento/sdk

```

2.2. For **browser or edge environments**:

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @gomomento/sdk-web

```

```codeBlockLines_AdAo
yarn add @gomomento/sdk-web

```

```codeBlockLines_AdAo
pnpm add @gomomento/sdk-web

```

3. Setup Env variables for Momento before running the code

3.1 OpenAI





```codeBlockLines_AdAo
export OPENAI_API_KEY=YOUR_OPENAI_API_KEY_HERE

```









3.2 Momento





```codeBlockLines_AdAo
export MOMENTO_API_KEY=YOUR_MOMENTO_API_KEY_HERE # https://console.gomomento.com

```


## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index/\#usage "Direct link to Usage")

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

### Index documents using `fromTexts` and search [​](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index/\#index-documents-using-fromtexts-and-search "Direct link to index-documents-using-fromtexts-and-search")

This example demonstrates using the `fromTexts` method to instantiate the vector store and index documents.
If the index does not exist, then it will be created. If the index already exists, then the documents will be
added to the existing index.

The `ids` are optional; if you omit them, then Momento will generate UUIDs for you.

```codeBlockLines_AdAo
import { MomentoVectorIndex } from "@langchain/community/vectorstores/momento_vector_index";
// For browser/edge, adjust this to import from "@gomomento/sdk-web";
import {
  PreviewVectorIndexClient,
  VectorIndexConfigurations,
  CredentialProvider,
} from "@gomomento/sdk";
import { OpenAIEmbeddings } from "@langchain/openai";
import { sleep } from "langchain/util/time";

const vectorStore = await MomentoVectorIndex.fromTexts(
  ["hello world", "goodbye world", "salutations world", "farewell world"],
  {},
  new OpenAIEmbeddings(),
  {
    client: new PreviewVectorIndexClient({
      configuration: VectorIndexConfigurations.Laptop.latest(),
      credentialProvider: CredentialProvider.fromEnvironmentVariable({
        environmentVariableName: "MOMENTO_API_KEY",
      }),
    }),
    indexName: "langchain-example-index",
  },
  { ids: ["1", "2", "3", "4"] }
);

// because indexing is async, wait for it to finish to search directly after
await sleep();

const response = await vectorStore.similaritySearch("hello", 2);

console.log(response);

/*
[\
  Document { pageContent: 'hello world', metadata: {} },\
  Document { pageContent: 'salutations world', metadata: {} }\
]
*/

```

#### API Reference:

- MomentoVectorIndexfrom `@langchain/community/vectorstores/momento_vector_index`
- OpenAIEmbeddingsfrom `@langchain/openai`
- sleepfrom `langchain/util/time`

### Index documents using `fromDocuments` and search [​](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index/\#index-documents-using-fromdocuments-and-search "Direct link to index-documents-using-fromdocuments-and-search")

Similar to the above, this example demonstrates using the `fromDocuments` method to instantiate the vector store and index documents.
If the index does not exist, then it will be created. If the index already exists, then the documents will be
added to the existing index.

Using `fromDocuments` allows you to seamlessly chain the various document loaders with indexing.

```codeBlockLines_AdAo
import { MomentoVectorIndex } from "@langchain/community/vectorstores/momento_vector_index";
// For browser/edge, adjust this to import from "@gomomento/sdk-web";
import {
  PreviewVectorIndexClient,
  VectorIndexConfigurations,
  CredentialProvider,
} from "@gomomento/sdk";
import { OpenAIEmbeddings } from "@langchain/openai";
import { TextLoader } from "langchain/document_loaders/fs/text";
import { sleep } from "langchain/util/time";

// Create docs with a loader
const loader = new TextLoader("src/document_loaders/example_data/example.txt");
const docs = await loader.load();

const vectorStore = await MomentoVectorIndex.fromDocuments(
  docs,
  new OpenAIEmbeddings(),
  {
    client: new PreviewVectorIndexClient({
      configuration: VectorIndexConfigurations.Laptop.latest(),
      credentialProvider: CredentialProvider.fromEnvironmentVariable({
        environmentVariableName: "MOMENTO_API_KEY",
      }),
    }),
    indexName: "langchain-example-index",
  }
);

// because indexing is async, wait for it to finish to search directly after
await sleep();

// Search for the most similar document
const response = await vectorStore.similaritySearch("hello", 1);

console.log(response);
/*
[\
  Document {\
    pageContent: 'Foo\nBar\nBaz\n\n',\
    metadata: { source: 'src/document_loaders/example_data/example.txt' }\
  }\
]
*/

```

#### API Reference:

- MomentoVectorIndexfrom `@langchain/community/vectorstores/momento_vector_index`
- OpenAIEmbeddingsfrom `@langchain/openai`
- TextLoaderfrom `langchain/document_loaders/fs/text`
- sleepfrom `langchain/util/time`

### Search from an existing collection [​](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index/\#search-from-an-existing-collection "Direct link to Search from an existing collection")

```codeBlockLines_AdAo
import { MomentoVectorIndex } from "@langchain/community/vectorstores/momento_vector_index";
// For browser/edge, adjust this to import from "@gomomento/sdk-web";
import {
  PreviewVectorIndexClient,
  VectorIndexConfigurations,
  CredentialProvider,
} from "@gomomento/sdk";
import { OpenAIEmbeddings } from "@langchain/openai";

const vectorStore = new MomentoVectorIndex(new OpenAIEmbeddings(), {
  client: new PreviewVectorIndexClient({
    configuration: VectorIndexConfigurations.Laptop.latest(),
    credentialProvider: CredentialProvider.fromEnvironmentVariable({
      environmentVariableName: "MOMENTO_API_KEY",
    }),
  }),
  indexName: "langchain-example-index",
});

const response = await vectorStore.similaritySearch("hello", 1);

console.log(response);
/*
[\
  Document {\
    pageContent: 'Foo\nBar\nBaz\n\n',\
    metadata: { source: 'src/document_loaders/example_data/example.txt' }\
  }\
]
*/

```

#### API Reference:

- MomentoVectorIndexfrom `@langchain/community/vectorstores/momento_vector_index`
- OpenAIEmbeddingsfrom `@langchain/openai`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/momento_vector_index/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index/#setup)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index/#usage)
  - [Index documents using `fromTexts` and search](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index/#index-documents-using-fromtexts-and-search)
  - [Index documents using `fromDocuments` and search](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index/#index-documents-using-fromdocuments-and-search)
  - [Search from an existing collection](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index/#search-from-an-existing-collection)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index/#related)