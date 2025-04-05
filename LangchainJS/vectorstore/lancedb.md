[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/lancedb/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# LanceDB

LanceDB is an embedded vector database for AI applications. It is open source and distributed with an Apache-2.0 license.

LanceDB datasets are persisted to disk and can be shared between Node.js and Python.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/lancedb/\#setup "Direct link to Setup")

Install the [LanceDB](https://github.com/lancedb/lancedb) [Node.js bindings](https://www.npmjs.com/package/@lancedb/lancedb):

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S @lancedb/lancedb

```

```codeBlockLines_AdAo
yarn add @lancedb/lancedb

```

```codeBlockLines_AdAo
pnpm add @lancedb/lancedb

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

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/lancedb/\#usage "Direct link to Usage")

### Create a new index from texts [​](https://js.langchain.com/docs/integrations/vectorstores/lancedb/\#create-a-new-index-from-texts "Direct link to Create a new index from texts")

```codeBlockLines_AdAo
import { LanceDB } from "@langchain/community/vectorstores/lancedb";
import { OpenAIEmbeddings } from "@langchain/openai";
import * as fs from "node:fs/promises";
import * as path from "node:path";
import os from "node:os";

export const run = async () => {
  const vectorStore = await LanceDB.fromTexts(
    ["Hello world", "Bye bye", "hello nice world"],
    [{ id: 2 }, { id: 1 }, { id: 3 }],
    new OpenAIEmbeddings()
  );

  const resultOne = await vectorStore.similaritySearch("hello world", 1);
  console.log(resultOne);
  // [ Document { pageContent: 'hello nice world', metadata: { id: 3 } } ]
};

export const run_with_existing_table = async () => {
  const dir = await fs.mkdtemp(path.join(os.tmpdir(), "lancedb-"));
  const vectorStore = await LanceDB.fromTexts(
    ["Hello world", "Bye bye", "hello nice world"],
    [{ id: 2 }, { id: 1 }, { id: 3 }],
    new OpenAIEmbeddings()
  );

  const resultOne = await vectorStore.similaritySearch("hello world", 1);
  console.log(resultOne);
  // [ Document { pageContent: 'hello nice world', metadata: { id: 3 } } ]
};

```

#### API Reference:

- LanceDBfrom `@langchain/community/vectorstores/lancedb`
- OpenAIEmbeddingsfrom `@langchain/openai`

### Create a new index from a loader [​](https://js.langchain.com/docs/integrations/vectorstores/lancedb/\#create-a-new-index-from-a-loader "Direct link to Create a new index from a loader")

```codeBlockLines_AdAo
import { LanceDB } from "@langchain/community/vectorstores/lancedb";
import { OpenAIEmbeddings } from "@langchain/openai";
import { TextLoader } from "langchain/document_loaders/fs/text";
import fs from "node:fs/promises";
import path from "node:path";
import os from "node:os";

// Create docs with a loader
const loader = new TextLoader("src/document_loaders/example_data/example.txt");
const docs = await loader.load();

export const run = async () => {
  const vectorStore = await LanceDB.fromDocuments(docs, new OpenAIEmbeddings());

  const resultOne = await vectorStore.similaritySearch("hello world", 1);
  console.log(resultOne);

  // [\
  //   Document {\
  //     pageContent: 'Foo\nBar\nBaz\n\n',\
  //     metadata: { source: 'src/document_loaders/example_data/example.txt' }\
  //   }\
  // ]
};

export const run_with_existing_table = async () => {
  const dir = await fs.mkdtemp(path.join(os.tmpdir(), "lancedb-"));

  const vectorStore = await LanceDB.fromDocuments(docs, new OpenAIEmbeddings());

  const resultOne = await vectorStore.similaritySearch("hello world", 1);
  console.log(resultOne);

  // [\
  //   Document {\
  //     pageContent: 'Foo\nBar\nBaz\n\n',\
  //     metadata: { source: 'src/document_loaders/example_data/example.txt' }\
  //   }\
  // ]
};

```

#### API Reference:

- LanceDBfrom `@langchain/community/vectorstores/lancedb`
- OpenAIEmbeddingsfrom `@langchain/openai`
- TextLoaderfrom `langchain/document_loaders/fs/text`

### Open an existing dataset [​](https://js.langchain.com/docs/integrations/vectorstores/lancedb/\#open-an-existing-dataset "Direct link to Open an existing dataset")

```codeBlockLines_AdAo
import { LanceDB } from "@langchain/community/vectorstores/lancedb";
import { OpenAIEmbeddings } from "@langchain/openai";
import { connect } from "@lancedb/lancedb";
import * as fs from "node:fs/promises";
import * as path from "node:path";
import os from "node:os";

//
//  You can open a LanceDB dataset created elsewhere, such as LangChain Python, by opening
//     an existing table
//
export const run = async () => {
  const uri = await createdTestDb();
  const db = await connect(uri);
  const table = await db.openTable("vectors");

  const vectorStore = new LanceDB(new OpenAIEmbeddings(), { table });

  const resultOne = await vectorStore.similaritySearch("hello world", 1);
  console.log(resultOne);
  // [ Document { pageContent: 'Hello world', metadata: { id: 1 } } ]
};

async function createdTestDb(): Promise<string> {
  const dir = await fs.mkdtemp(path.join(os.tmpdir(), "lancedb-"));
  const db = await connect(dir);
  await db.createTable("vectors", [\
    { vector: Array(1536), text: "Hello world", id: 1 },\
    { vector: Array(1536), text: "Bye bye", id: 2 },\
    { vector: Array(1536), text: "hello nice world", id: 3 },\
  ]);
  return dir;
}

```

#### API Reference:

- LanceDBfrom `@langchain/community/vectorstores/lancedb`
- OpenAIEmbeddingsfrom `@langchain/openai`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/lancedb/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/lancedb/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/lancedb/#setup)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/lancedb/#usage)
  - [Create a new index from texts](https://js.langchain.com/docs/integrations/vectorstores/lancedb/#create-a-new-index-from-texts)
  - [Create a new index from a loader](https://js.langchain.com/docs/integrations/vectorstores/lancedb/#create-a-new-index-from-a-loader)
  - [Open an existing dataset](https://js.langchain.com/docs/integrations/vectorstores/lancedb/#open-an-existing-dataset)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/lancedb/#related)