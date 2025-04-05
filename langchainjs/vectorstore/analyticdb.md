[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/analyticdb/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# AnalyticDB

[AnalyticDB for PostgreSQL](https://www.alibabacloud.com/help/en/analyticdb-for-postgresql/latest/product-introduction-overview) is a massively parallel processing (MPP) data warehousing service that is designed to analyze large volumes of data online.

`AnalyticDB for PostgreSQL` is developed based on the open source `Greenplum Database` project and is enhanced with in-depth extensions by `Alibaba Cloud`. AnalyticDB for PostgreSQL is compatible with the ANSI SQL 2003 syntax and the PostgreSQL and Oracle database ecosystems. AnalyticDB for PostgreSQL also supports row store and column store. AnalyticDB for PostgreSQL processes petabytes of data offline at a high performance level and supports highly concurrent online queries.

This notebook shows how to use functionality related to the `AnalyticDB` vector database.

To run, you should have an [AnalyticDB](https://www.alibabacloud.com/help/en/analyticdb-for-postgresql/latest/product-introduction-overview) instance up and running:

- Using [AnalyticDB Cloud Vector Database](https://www.alibabacloud.com/product/hybriddb-postgresql).

Compatibility

Only available on Node.js.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/analyticdb/\#setup "Direct link to Setup")

LangChain.js accepts [node-postgres](https://node-postgres.com/) as the connections pool for AnalyticDB vectorstore.

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S pg

```

```codeBlockLines_AdAo
yarn add pg

```

```codeBlockLines_AdAo
pnpm add pg

```

And we need [pg-copy-streams](https://github.com/brianc/node-pg-copy-streams) to add batch vectors quickly.

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S pg-copy-streams

```

```codeBlockLines_AdAo
yarn add pg-copy-streams

```

```codeBlockLines_AdAo
pnpm add pg-copy-streams

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

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/analyticdb/\#usage "Direct link to Usage")

Security

User-generated data such as usernames should not be used as input for the collection name.

**This may lead to SQL Injection!**

```codeBlockLines_AdAo
import { AnalyticDBVectorStore } from "@langchain/community/vectorstores/analyticdb";
import { OpenAIEmbeddings } from "@langchain/openai";

const connectionOptions = {
  host: process.env.ANALYTICDB_HOST || "localhost",
  port: Number(process.env.ANALYTICDB_PORT) || 5432,
  database: process.env.ANALYTICDB_DATABASE || "your_database",
  user: process.env.ANALYTICDB_USERNAME || "username",
  password: process.env.ANALYTICDB_PASSWORD || "password",
};

const vectorStore = await AnalyticDBVectorStore.fromTexts(
  ["foo", "bar", "baz"],
  [{ page: 1 }, { page: 2 }, { page: 3 }],
  new OpenAIEmbeddings(),
  { connectionOptions }
);
const result = await vectorStore.similaritySearch("foo", 1);
console.log(JSON.stringify(result));
// [{"pageContent":"foo","metadata":{"page":1}}]

await vectorStore.addDocuments([{ pageContent: "foo", metadata: { page: 4 } }]);

const filterResult = await vectorStore.similaritySearch("foo", 1, {
  page: 4,
});
console.log(JSON.stringify(filterResult));
// [{"pageContent":"foo","metadata":{"page":4}}]

const filterWithScoreResult = await vectorStore.similaritySearchWithScore(
  "foo",
  1,
  { page: 3 }
);
console.log(JSON.stringify(filterWithScoreResult));
// [[{"pageContent":"baz","metadata":{"page":3}},0.26075905561447144]]

const filterNoMatchResult = await vectorStore.similaritySearchWithScore(
  "foo",
  1,
  { page: 5 }
);
console.log(JSON.stringify(filterNoMatchResult));
// []

// need to manually close the Connection pool
await vectorStore.end();

```

#### API Reference:

- AnalyticDBVectorStorefrom `@langchain/community/vectorstores/analyticdb`
- OpenAIEmbeddingsfrom `@langchain/openai`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/analyticdb/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/analyticdb/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/analyticdb/#setup)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/analyticdb/#usage)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/analyticdb/#related)