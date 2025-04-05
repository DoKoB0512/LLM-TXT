[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/libsql/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# libSQL

[Turso](https://turso.tech/) is a SQLite-compatible database built on [libSQL](https://docs.turso.tech/libsql), the Open Contribution fork of SQLite. Vector Similiarity Search is built into Turso and libSQL as a native datatype, enabling you to store and query vectors directly in the database.

LangChain.js supports using a local libSQL, or remote Turso database as a vector store, and provides a simple API to interact with it.

This guide provides a quick overview for getting started with libSQL vector stores. For detailed documentation of all libSQL features and configurations head to the API reference.

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#overview "Direct link to Overview")

## Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#integration-details "Direct link to Integration details")

| Class | Package | PY support | Package latest |
| --- | --- | --- | --- |
| `LibSQLVectorStore` | `@langchain/community` | ❌ | ![npm version](https://img.shields.io/npm/v/@langchain/community) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#setup "Direct link to Setup")

To use libSQL vector stores, you'll need to create a Turso account or set up a local SQLite database, and install the `@langchain/community` integration package.

This guide will also use OpenAI embeddings, which require you to install the `@langchain/openai` integration package. You can also use other supported embeddings models if you wish.

You can use local SQLite when working with the libSQL vector store, or use a hosted Turso Database.

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @libsql/client @langchain/openai @langchain/community

```

```codeBlockLines_AdAo
yarn add @libsql/client @langchain/openai @langchain/community

```

```codeBlockLines_AdAo
pnpm add @libsql/client @langchain/openai @langchain/community

```

Now it's time to create a database. You can create one locally, or use a hosted Turso database.

### Local libSQL [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#local-libsql "Direct link to Local libSQL")

Create a new local SQLite file and connect to the shell:

```codeBlockLines_AdAo
sqlite3 file.db

```

### Hosted Turso [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#hosted-turso "Direct link to Hosted Turso")

Visit [sqlite.new](https://sqlite.new/) to create a new database, give it a name, and create a database auth token.

Make sure to copy the database auth token, and the database URL, it should look something like:

```codeBlockLines_AdAo
libsql://[database-name]-[your-username].turso.io

```

### Setup the table and index [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#setup-the-table-and-index "Direct link to Setup the table and index")

Execute the following SQL command to create a new table or add the embedding column to an existing table.

Make sure to modify the following parts of the SQL:

- `TABLE_NAME` is the name of the table you want to create.
- `content` is used to store the `Document.pageContent` values.
- `metadata` is used to store the `Document.metadata` object.
- `EMBEDDING_COLUMN` is used to store the vector values, use the dimensions size used by the model you plan to use (1536 for OpenAI).

```codeBlockLines_AdAo
CREATE TABLE IF NOT EXISTS TABLE_NAME (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT,
    metadata TEXT,
    EMBEDDING_COLUMN F32_BLOB(1536) -- 1536-dimensional f32 vector for OpenAI
);

```

Now create an index on the `EMBEDDING_COLUMN` column - the index name is important!:

```codeBlockLines_AdAo
CREATE INDEX IF NOT EXISTS idx_TABLE_NAME_EMBEDDING_COLUMN ON TABLE_NAME(libsql_vector_idx(EMBEDDING_COLUMN));

```

Make sure to replace the `TABLE_NAME` and `EMBEDDING_COLUMN` with the values you used in the previous step.

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#instantiation "Direct link to Instantiation")

To initialize a new `LibSQL` vector store, you need to provide the database URL and Auth Token when working remotely, or by passing the filename for a local SQLite.

```codeBlockLines_AdAo
import { LibSQLVectorStore } from "@langchain/community/vectorstores/libsql";
import { OpenAIEmbeddings } from "@langchain/openai";
import { createClient } from "@libsql/client";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

const libsqlClient = createClient({
  url: "libsql://[database-name]-[your-username].turso.io",
  authToken: "...",
});

// Local instantiation
// const libsqlClient = createClient({
//  url: "file:./dev.db",
// });

const vectorStore = new LibSQLVectorStore(embeddings, {
  db: libsqlClient,
  table: "TABLE_NAME",
  column: "EMBEDDING_COLUMN",
});

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#add-items-to-vector-store "Direct link to Add items to vector store")

```codeBlockLines_AdAo
import type { Document } from "@langchain/core/documents";

const documents: Document[] = [\
  { pageContent: "Hello", metadata: { topic: "greeting" } },\
  { pageContent: "Bye bye", metadata: { topic: "greeting" } },\
];

await vectorStore.addDocuments(documents);

```

### Delete items from vector store [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#delete-items-from-vector-store "Direct link to Delete items from vector store")

```codeBlockLines_AdAo
await vectorStore.deleteDocuments({ ids: [1, 2] });

```

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#query-vector-store "Direct link to Query vector store")

Once you have inserted the documents, you can query the vector store.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
const resultOne = await vectorStore.similaritySearch("hola", 1);

for (const doc of similaritySearchResults) {
  console.log(`${doc.pageContent} [${JSON.stringify(doc.metadata, null)}]`);
}

```

For similarity search with scores:

```codeBlockLines_AdAo
const similaritySearchWithScoreResults =
  await vectorStore.similaritySearchWithScore("hola", 1);

for (const [doc, score] of similaritySearchWithScoreResults) {
  console.log(
    `${score.toFixed(3)} ${doc.pageContent} [${JSON.stringify(doc.metadata)}]`
  );
}

```

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#api-reference "Direct link to API reference")

For detailed documentation of all `LibSQLVectorStore` features and configurations head to the API reference.

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/libsql/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/libsql/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/libsql/#overview)
- [Integration details](https://js.langchain.com/docs/integrations/vectorstores/libsql/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/libsql/#setup)
  - [Local libSQL](https://js.langchain.com/docs/integrations/vectorstores/libsql/#local-libsql)
  - [Hosted Turso](https://js.langchain.com/docs/integrations/vectorstores/libsql/#hosted-turso)
  - [Setup the table and index](https://js.langchain.com/docs/integrations/vectorstores/libsql/#setup-the-table-and-index)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/libsql/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/libsql/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/libsql/#add-items-to-vector-store)
  - [Delete items from vector store](https://js.langchain.com/docs/integrations/vectorstores/libsql/#delete-items-from-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/libsql/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/libsql/#query-directly)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/libsql/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/libsql/#related)