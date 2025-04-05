[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/clickhouse/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# ClickHouse

Compatibility

Only available on Node.js.

[ClickHouse](https://clickhouse.com/) is a robust and open-source columnar database that is used for handling analytical queries and efficient storage, ClickHouse is designed to provide a powerful combination of vector search and analytics.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/clickhouse/\#setup "Direct link to Setup")

1. Launch a ClickHouse cluster. Refer to the [ClickHouse Installation Guide](https://clickhouse.com/docs/en/getting-started/install/) for details.
2. After launching a ClickHouse cluster, retrieve the `Connection Details` from the cluster's `Actions` menu. You will need the host, port, username, and password.
3. Install the required Node.js peer dependency for ClickHouse in your workspace.

You will need to install the following peer dependencies:

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S @clickhouse/client mysql2

```

```codeBlockLines_AdAo
yarn add @clickhouse/client mysql2

```

```codeBlockLines_AdAo
pnpm add @clickhouse/client mysql2

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

## Index and Query Docs [​](https://js.langchain.com/docs/integrations/vectorstores/clickhouse/\#index-and-query-docs "Direct link to Index and Query Docs")

```codeBlockLines_AdAo
import { ClickHouseStore } from "@langchain/community/vectorstores/clickhouse";
import { OpenAIEmbeddings } from "@langchain/openai";

// Initialize ClickHouse store from texts
const vectorStore = await ClickHouseStore.fromTexts(
  ["Hello world", "Bye bye", "hello nice world"],
  [\
    { id: 2, name: "2" },\
    { id: 1, name: "1" },\
    { id: 3, name: "3" },\
  ],
  new OpenAIEmbeddings(),
  {
    host: process.env.CLICKHOUSE_HOST || "localhost",
    port: process.env.CLICKHOUSE_PORT || 8443,
    username: process.env.CLICKHOUSE_USER || "username",
    password: process.env.CLICKHOUSE_PASSWORD || "password",
    database: process.env.CLICKHOUSE_DATABASE || "default",
    table: process.env.CLICKHOUSE_TABLE || "vector_table",
  }
);

// Sleep 1 second to ensure that the search occurs after the successful insertion of data.
// eslint-disable-next-line no-promise-executor-return
await new Promise((resolve) => setTimeout(resolve, 1000));

// Perform similarity search without filtering
const results = await vectorStore.similaritySearch("hello world", 1);
console.log(results);

// Perform similarity search with filtering
const filteredResults = await vectorStore.similaritySearch("hello world", 1, {
  whereStr: "metadata.name = '1'",
});
console.log(filteredResults);

```

#### API Reference:

- ClickHouseStorefrom `@langchain/community/vectorstores/clickhouse`
- OpenAIEmbeddingsfrom `@langchain/openai`

## Query Docs From an Existing Collection [​](https://js.langchain.com/docs/integrations/vectorstores/clickhouse/\#query-docs-from-an-existing-collection "Direct link to Query Docs From an Existing Collection")

```codeBlockLines_AdAo
import { ClickHouseStore } from "@langchain/community/vectorstores/clickhouse";
import { OpenAIEmbeddings } from "@langchain/openai";

// Initialize ClickHouse store
const vectorStore = await ClickHouseStore.fromExistingIndex(
  new OpenAIEmbeddings(),
  {
    host: process.env.CLICKHOUSE_HOST || "localhost",
    port: process.env.CLICKHOUSE_PORT || 8443,
    username: process.env.CLICKHOUSE_USER || "username",
    password: process.env.CLICKHOUSE_PASSWORD || "password",
    database: process.env.CLICKHOUSE_DATABASE || "default",
    table: process.env.CLICKHOUSE_TABLE || "vector_table",
  }
);

// Sleep 1 second to ensure that the search occurs after the successful insertion of data.
// eslint-disable-next-line no-promise-executor-return
await new Promise((resolve) => setTimeout(resolve, 1000));

// Perform similarity search without filtering
const results = await vectorStore.similaritySearch("hello world", 1);
console.log(results);

// Perform similarity search with filtering
const filteredResults = await vectorStore.similaritySearch("hello world", 1, {
  whereStr: "metadata.name = '1'",
});
console.log(filteredResults);

```

#### API Reference:

- ClickHouseStorefrom `@langchain/community/vectorstores/clickhouse`
- OpenAIEmbeddingsfrom `@langchain/openai`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/clickhouse/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/clickhouse/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/clickhouse/#setup)
- [Index and Query Docs](https://js.langchain.com/docs/integrations/vectorstores/clickhouse/#index-and-query-docs)
- [Query Docs From an Existing Collection](https://js.langchain.com/docs/integrations/vectorstores/clickhouse/#query-docs-from-an-existing-collection)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/clickhouse/#related)