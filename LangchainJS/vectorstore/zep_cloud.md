[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Zep Cloud

> [Zep](https://www.getzep.com/) is a long-term memory service for AI Assistant apps.
> With Zep, you can provide AI assistants with the ability to recall past conversations, no matter how distant,
> while also reducing hallucinations, latency, and cost.

**Note:** The `ZepCloudVectorStore` works with `Documents` and is intended to be used as a `Retriever`.
It offers separate functionality to Zep's `ZepCloudMemory` class, which is designed for persisting, enriching
and searching your user's chat history.

## Why Zep's VectorStore? 🤖🚀 [​](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/\#why-zeps-vectorstore- "Direct link to Why Zep's VectorStore? 🤖🚀")

Zep automatically embeds documents added to the Zep Vector Store using low-latency models local to the Zep server.
The Zep TS/JS client can be used in non-Node edge environments. These two together with Zep's chat memory functionality
make Zep ideal for building conversational LLM apps where latency and performance are important.

### Supported Search Types [​](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/\#supported-search-types "Direct link to Supported Search Types")

Zep supports both similarity search and Maximal Marginal Relevance (MMR) search. MMR search is particularly useful
for Retrieval Augmented Generation applications as it re-ranks results to ensure diversity in the returned documents.

## Installation [​](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/\#installation "Direct link to Installation")

Sign up for [Zep Cloud](https://app.getzep.com/) and create a project.

Follow the [Zep Cloud Typescript SDK Installation Guide](https://help.getzep.com/sdks) to install and get started with Zep.

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/\#usage "Direct link to Usage")

You'll need your Zep Cloud Project API Key to use the Zep VectorStore. See the [Zep Cloud docs](https://help.getzep.com/projects) for more information.

Zep auto embeds all documents by default, and it's not expecting to receive any embeddings from the user.
Since LangChain requires passing in a `Embeddings` instance, we pass in `FakeEmbeddings`.

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

### Example: Creating a ZepVectorStore from Documents & Querying [​](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/\#example-creating-a-zepvectorstore-from-documents--querying "Direct link to Example: Creating a ZepVectorStore from Documents & Querying")

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @getzep/zep-cloud @langchain/openai @langchain/community @langchain/core

```

```codeBlockLines_AdAo
yarn add @getzep/zep-cloud @langchain/openai @langchain/community @langchain/core

```

```codeBlockLines_AdAo
pnpm add @getzep/zep-cloud @langchain/openai @langchain/community @langchain/core

```

```codeBlockLines_AdAo
import { ZepCloudVectorStore } from "@langchain/community/vectorstores/zep_cloud";
import { FakeEmbeddings } from "@langchain/core/utils/testing";
import { TextLoader } from "langchain/document_loaders/fs/text";
import { randomUUID } from "crypto";

const loader = new TextLoader("src/document_loaders/example_data/example.txt");
const docs = await loader.load();
const collectionName = `collection${randomUUID().split("-")[0]}`;

const zepConfig = {
  // Your Zep Cloud Project API key https://help.getzep.com/projects
  apiKey: "<Zep Api Key>",
  collectionName,
};

// We're using fake embeddings here, because Zep Cloud handles embedding for you
const embeddings = new FakeEmbeddings();

const vectorStore = await ZepCloudVectorStore.fromDocuments(
  docs,
  embeddings,
  zepConfig
);

// Wait for the documents to be embedded
// eslint-disable-next-line no-constant-condition
while (true) {
  const c = await vectorStore.client.document.getCollection(collectionName);
  console.log(
    `Embedding status: ${c.documentEmbeddedCount}/${c.documentCount} documents embedded`
  );
  // eslint-disable-next-line no-promise-executor-return
  await new Promise((resolve) => setTimeout(resolve, 1000));
  if (c.documentEmbeddedCount === c.documentCount) {
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

```

#### API Reference:

- ZepCloudVectorStorefrom `@langchain/community/vectorstores/zep_cloud`
- FakeEmbeddingsfrom `@langchain/core/utils/testing`
- TextLoaderfrom `langchain/document_loaders/fs/text`

### Example: Using ZepCloudVectorStore with Expression Language [​](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/\#example-using-zepcloudvectorstore-with-expression-language "Direct link to Example: Using ZepCloudVectorStore with Expression Language")

```codeBlockLines_AdAo
import { ZepClient } from "@getzep/zep-cloud";
import { ChatPromptTemplate } from "@langchain/core/prompts";
import { ConsoleCallbackHandler } from "@langchain/core/tracers/console";
import { ChatOpenAI } from "@langchain/openai";
import { Document } from "@langchain/core/documents";
import {
  RunnableLambda,
  RunnableMap,
  RunnablePassthrough,
} from "@langchain/core/runnables";
import { ZepCloudVectorStore } from "@langchain/community/vectorstores/zep_cloud";
import { StringOutputParser } from "@langchain/core/output_parsers";

async function combineDocuments(docs: Document[], documentSeparator = "\n\n") {
  const docStrings: string[] = await Promise.all(
    docs.map((doc) => doc.pageContent)
  );
  return docStrings.join(documentSeparator);
}

// Your Zep Collection Name
const collectionName = "<Zep Collection Name>";

const zepClient = new ZepClient({
  // Your Zep Cloud Project API key https://help.getzep.com/projects
  apiKey: "<Zep Api Key>",
});

const vectorStore = await ZepCloudVectorStore.init({
  client: zepClient,
  collectionName,
});

const prompt = ChatPromptTemplate.fromMessages([\
  [\
    "system",\
    `Answer the question based only on the following context: {context}`,\
  ],\
  ["human", "{question}"],\
]);

const model = new ChatOpenAI({
  temperature: 0.8,
  modelName: "gpt-3.5-turbo-1106",
});
const retriever = vectorStore.asRetriever();

const setupAndRetrieval = RunnableMap.from({
  context: new RunnableLambda({
    func: (input: string) => retriever.invoke(input).then(combineDocuments),
  }),
  question: new RunnablePassthrough(),
});
const outputParser = new StringOutputParser();

const chain = setupAndRetrieval
  .pipe(prompt)
  .pipe(model)
  .pipe(outputParser)
  .withConfig({
    callbacks: [new ConsoleCallbackHandler()],
  });

const result = await chain.invoke("Project Gutenberg?");

console.log("result", result);

```

#### API Reference:

- ChatPromptTemplatefrom `@langchain/core/prompts`
- ConsoleCallbackHandlerfrom `@langchain/core/tracers/console`
- ChatOpenAIfrom `@langchain/openai`
- Documentfrom `@langchain/core/documents`
- RunnableLambdafrom `@langchain/core/runnables`
- RunnableMapfrom `@langchain/core/runnables`
- RunnablePassthroughfrom `@langchain/core/runnables`
- ZepCloudVectorStorefrom `@langchain/community/vectorstores/zep_cloud`
- StringOutputParserfrom `@langchain/core/output_parsers`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/zep_cloud/%3E).

- [Why Zep's VectorStore? 🤖🚀](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/#why-zeps-vectorstore-)
  - [Supported Search Types](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/#supported-search-types)
- [Installation](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/#installation)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/#usage)
  - [Example: Creating a ZepVectorStore from Documents & Querying](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/#example-creating-a-zepvectorstore-from-documents--querying)
  - [Example: Using ZepCloudVectorStore with Expression Language](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/#example-using-zepcloudvectorstore-with-expression-language)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud/#related)