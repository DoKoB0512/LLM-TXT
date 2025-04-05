[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/tigris/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Tigris

Tigris makes it easy to build AI applications with vector embeddings.
It is a fully managed cloud-native database that allows you store and
index documents and vector embeddings for fast and scalable vector search.

Compatibility

Only available on Node.js.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/tigris/\#setup "Direct link to Setup")

### 1\. Install the Tigris SDK [​](https://js.langchain.com/docs/integrations/vectorstores/tigris/\#1-install-the-tigris-sdk "Direct link to 1. Install the Tigris SDK")

Install the SDK as follows

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S @tigrisdata/vector

```

```codeBlockLines_AdAo
yarn add @tigrisdata/vector

```

```codeBlockLines_AdAo
pnpm add @tigrisdata/vector

```

### 2\. Fetch Tigris API credentials [​](https://js.langchain.com/docs/integrations/vectorstores/tigris/\#2-fetch-tigris-api-credentials "Direct link to 2. Fetch Tigris API credentials")

You can sign up for a free Tigris account [here](https://www.tigrisdata.com/).

Once you have signed up for the Tigris account, create a new project called `vectordemo`.
Next, make a note of the `clientId` and `clientSecret`, which you can get from the
Application Keys section of the project.

## Index docs [​](https://js.langchain.com/docs/integrations/vectorstores/tigris/\#index-docs "Direct link to Index docs")

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S @langchain/openai

```

```codeBlockLines_AdAo
yarn add @langchain/openai

```

```codeBlockLines_AdAo
pnpm add @langchain/openai

```

```codeBlockLines_AdAo
import { VectorDocumentStore } from "@tigrisdata/vector";
import { Document } from "langchain/document";
import { OpenAIEmbeddings } from "@langchain/openai";
import { TigrisVectorStore } from "langchain/vectorstores/tigris";

const index = new VectorDocumentStore({
  connection: {
    serverUrl: "api.preview.tigrisdata.cloud",
    projectName: process.env.TIGRIS_PROJECT,
    clientId: process.env.TIGRIS_CLIENT_ID,
    clientSecret: process.env.TIGRIS_CLIENT_SECRET,
  },
  indexName: "examples_index",
  numDimensions: 1536, // match the OpenAI embedding size
});

const docs = [\
  new Document({\
    metadata: { foo: "bar" },\
    pageContent: "tigris is a cloud-native vector db",\
  }),\
  new Document({\
    metadata: { foo: "bar" },\
    pageContent: "the quick brown fox jumped over the lazy dog",\
  }),\
  new Document({\
    metadata: { baz: "qux" },\
    pageContent: "lorem ipsum dolor sit amet",\
  }),\
  new Document({\
    metadata: { baz: "qux" },\
    pageContent: "tigris is a river",\
  }),\
];

await TigrisVectorStore.fromDocuments(docs, new OpenAIEmbeddings(), { index });

```

## Query docs [​](https://js.langchain.com/docs/integrations/vectorstores/tigris/\#query-docs "Direct link to Query docs")

```codeBlockLines_AdAo
import { VectorDocumentStore } from "@tigrisdata/vector";
import { OpenAIEmbeddings } from "@langchain/openai";
import { TigrisVectorStore } from "langchain/vectorstores/tigris";

const index = new VectorDocumentStore({
  connection: {
    serverUrl: "api.preview.tigrisdata.cloud",
    projectName: process.env.TIGRIS_PROJECT,
    clientId: process.env.TIGRIS_CLIENT_ID,
    clientSecret: process.env.TIGRIS_CLIENT_SECRET,
  },
  indexName: "examples_index",
  numDimensions: 1536, // match the OpenAI embedding size
});

const vectorStore = await TigrisVectorStore.fromExistingIndex(
  new OpenAIEmbeddings(),
  { index }
);

/* Search the vector DB independently with metadata filters */
const results = await vectorStore.similaritySearch("tigris", 1, {
  "metadata.foo": "bar",
});
console.log(JSON.stringify(results, null, 2));
/*
[\
  Document {\
    pageContent: 'tigris is a cloud-native vector db',\
    metadata: { foo: 'bar' }\
  }\
]
*/

```

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/tigris/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/tigris/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/tigris/#setup)
  - [1\. Install the Tigris SDK](https://js.langchain.com/docs/integrations/vectorstores/tigris/#1-install-the-tigris-sdk)
  - [2\. Fetch Tigris API credentials](https://js.langchain.com/docs/integrations/vectorstores/tigris/#2-fetch-tigris-api-credentials)
- [Index docs](https://js.langchain.com/docs/integrations/vectorstores/tigris/#index-docs)
- [Query docs](https://js.langchain.com/docs/integrations/vectorstores/tigris/#query-docs)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/tigris/#related)