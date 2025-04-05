[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/myscale/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# MyScale

Compatibility

Only available on Node.js.

[MyScale](https://myscale.com/) is an emerging AI database that harmonizes the power of vector search and SQL analytics, providing a managed, efficient, and responsive experience.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/myscale/\#setup "Direct link to Setup")

1. Launch a cluster through [MyScale's Web Console](https://console.myscale.com/). See [MyScale's official documentation](https://docs.myscale.com/en/quickstart/) for more information.
2. After launching a cluster, view your `Connection Details` from your cluster's `Actions` menu. You will need the host, port, username, and password.
3. Install the required Node.js peer dependency in your workspace.

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S @langchain/openai @clickhouse/client @langchain/community @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/openai @clickhouse/client @langchain/community @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/openai @clickhouse/client @langchain/community @langchain/core

```

## Index and Query Docs [​](https://js.langchain.com/docs/integrations/vectorstores/myscale/\#index-and-query-docs "Direct link to Index and Query Docs")

```codeBlockLines_AdAo
import { MyScaleStore } from "@langchain/community/vectorstores/myscale";
import { OpenAIEmbeddings } from "@langchain/openai";

const vectorStore = await MyScaleStore.fromTexts(
  ["Hello world", "Bye bye", "hello nice world"],
  [\
    { id: 2, name: "2" },\
    { id: 1, name: "1" },\
    { id: 3, name: "3" },\
  ],
  new OpenAIEmbeddings(),
  {
    host: process.env.MYSCALE_HOST || "localhost",
    port: process.env.MYSCALE_PORT || "8443",
    username: process.env.MYSCALE_USERNAME || "username",
    password: process.env.MYSCALE_PASSWORD || "password",
    database: "default", // defaults to "default"
    table: "your_table", // defaults to "vector_table"
  }
);

const results = await vectorStore.similaritySearch("hello world", 1);
console.log(results);

const filteredResults = await vectorStore.similaritySearch("hello world", 1, {
  whereStr: "metadata.name = '1'",
});
console.log(filteredResults);

```

#### API Reference:

- MyScaleStorefrom `@langchain/community/vectorstores/myscale`
- OpenAIEmbeddingsfrom `@langchain/openai`

## Query Docs From an Existing Collection [​](https://js.langchain.com/docs/integrations/vectorstores/myscale/\#query-docs-from-an-existing-collection "Direct link to Query Docs From an Existing Collection")

```codeBlockLines_AdAo
import { MyScaleStore } from "@langchain/community/vectorstores/myscale";
import { OpenAIEmbeddings } from "@langchain/openai";

const vectorStore = await MyScaleStore.fromExistingIndex(
  new OpenAIEmbeddings(),
  {
    host: process.env.MYSCALE_HOST || "localhost",
    port: process.env.MYSCALE_PORT || "8443",
    username: process.env.MYSCALE_USERNAME || "username",
    password: process.env.MYSCALE_PASSWORD || "password",
    database: "default", // defaults to "default"
    table: "your_table", // defaults to "vector_table"
  }
);

const results = await vectorStore.similaritySearch("hello world", 1);
console.log(results);

const filteredResults = await vectorStore.similaritySearch("hello world", 1, {
  whereStr: "metadata.name = '1'",
});
console.log(filteredResults);

```

#### API Reference:

- MyScaleStorefrom `@langchain/community/vectorstores/myscale`
- OpenAIEmbeddingsfrom `@langchain/openai`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/myscale/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/myscale/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/myscale/#setup)
- [Index and Query Docs](https://js.langchain.com/docs/integrations/vectorstores/myscale/#index-and-query-docs)
- [Query Docs From an Existing Collection](https://js.langchain.com/docs/integrations/vectorstores/myscale/#query-docs-from-an-existing-collection)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/myscale/#related)