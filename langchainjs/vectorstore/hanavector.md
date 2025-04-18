[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/hanavector/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# SAP HANA Cloud Vector Engine

[SAP HANA Cloud Vector Engine](https://www.sap.com/events/teched/news-guide/ai.html#article8) is a vector store fully integrated into the `SAP HANA Cloud database`.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/hanavector/\#setup "Direct link to Setup")

You'll first need to install either the [`@sap/hana-client`](https://www.npmjs.com/package/@sap/hana-client) or the [`hdb`](https://www.npmjs.com/package/hdb) package, and the [`@langchain/community`](https://www.npmjs.com/package/@langchain/community) package:

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S @langchain/community @langchain/core @sap/hana-client
# or
npm install -S @langchain/community @langchain/core hdb

```

```codeBlockLines_AdAo
yarn add @langchain/community @langchain/core @sap/hana-client
# or
yarn add @langchain/community @langchain/core hdb

```

```codeBlockLines_AdAo
pnpm add @langchain/community @langchain/core @sap/hana-client
# or
pnpm add @langchain/community @langchain/core hdb

```

You'll also need to have database connection to a HANA Cloud instance.

```codeBlockLines_AdAo
OPENAI_API_KEY = "Your OpenAI API key"
HANA_HOST = "HANA_DB_ADDRESS"
HANA_PORT = "HANA_DB_PORT"
HANA_UID =  "HANA_DB_USER"
HANA_PWD = "HANA_DB_PASSWORD"

```

#### API Reference:

## Create a new index from texts [​](https://js.langchain.com/docs/integrations/vectorstores/hanavector/\#create-a-new-index-from-texts "Direct link to Create a new index from texts")

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import hanaClient from "hdb";
import {
  HanaDB,
  HanaDBArgs,
} from "@langchain/community/vectorstores/hanavector";

const connectionParams = {
  host: process.env.HANA_HOST,
  port: process.env.HANA_PORT,
  user: process.env.HANA_UID,
  password: process.env.HANA_PWD,
  // useCesu8 : false
};
const client = hanaClient.createClient(connectionParams);
// connet to hanaDB
await new Promise<void>((resolve, reject) => {
  client.connect((err: Error) => {
    // Use arrow function here
    if (err) {
      reject(err);
    } else {
      console.log("Connected to SAP HANA successfully.");
      resolve();
    }
  });
});
const embeddings = new OpenAIEmbeddings();
const args: HanaDBArgs = {
  connection: client,
  tableName: "test_fromTexts",
};
// This function will create a table "test_fromTexts" if not exist, if exists,
// then the value will be appended to the table.
const vectorStore = await HanaDB.fromTexts(
  ["Bye bye", "Hello world", "hello nice world"],
  [\
    { id: 2, name: "2" },\
    { id: 1, name: "1" },\
    { id: 3, name: "3" },\
  ],
  embeddings,
  args
);

const response = await vectorStore.similaritySearch("hello world", 2);

console.log(response);

/* This result is based on no table "test_fromTexts" existing in the database.
  [\
    { pageContent: 'Hello world', metadata: { id: 1, name: '1' } },\
    { pageContent: 'hello nice world', metadata: { id: 3, name: '3' } }\
  ]
*/
client.disconnect();

```

#### API Reference:

- OpenAIEmbeddingsfrom `@langchain/openai`
- HanaDBfrom `@langchain/community/vectorstores/hanavector`
- HanaDBArgsfrom `@langchain/community/vectorstores/hanavector`

## Create a new index from a loader and perform similarity searches [​](https://js.langchain.com/docs/integrations/vectorstores/hanavector/\#create-a-new-index-from-a-loader-and-perform-similarity-searches "Direct link to Create a new index from a loader and perform similarity searches")

```codeBlockLines_AdAo
import hanaClient from "hdb";
import {
  HanaDB,
  HanaDBArgs,
} from "@langchain/community/vectorstores/hanavector";
import { OpenAIEmbeddings } from "@langchain/openai";
import { TextLoader } from "langchain/document_loaders/fs/text";
import { CharacterTextSplitter } from "@langchain/textsplitters";

const connectionParams = {
  host: process.env.HANA_HOST,
  port: process.env.HANA_PORT,
  user: process.env.HANA_UID,
  password: process.env.HANA_PWD,
  // useCesu8 : false
};
const client = hanaClient.createClient(connectionParams);
// connet to hanaDB
await new Promise<void>((resolve, reject) => {
  client.connect((err: Error) => {
    // Use arrow function here
    if (err) {
      reject(err);
    } else {
      console.log("Connected to SAP HANA successfully.");
      resolve();
    }
  });
});
const embeddings = new OpenAIEmbeddings();
const args: HanaDBArgs = {
  connection: client,
  tableName: "test_fromDocs",
};
// Load documents from file
const loader = new TextLoader("./state_of_the_union.txt");
const rawDocuments = await loader.load();
const splitter = new CharacterTextSplitter({
  chunkSize: 500,
  chunkOverlap: 0,
});
const documents = await splitter.splitDocuments(rawDocuments);
// Create a LangChain VectorStore interface for the HANA database and specify the table (collection) to use in args.
const vectorStore = new HanaDB(embeddings, args);
await vectorStore.initialize();
// Delete already existing documents from the table
await vectorStore.delete({ filter: {} });
// add the loaded document chunks
await vectorStore.addDocuments(documents);

// similarity search (default:“Cosine Similarity”, options:["euclidean", "cosine"])
const query = "What did the president say about Ketanji Brown Jackson";
const docs = await vectorStore.similaritySearch(query, 2);
docs.forEach((doc) => {
  console.log("-".repeat(80));
  console.log(doc.pageContent);
});
/*
  --------------------------------------------------------------------------------
  One of the most serious constitutional responsibilities a President has is nominating
  someone to serve on the United States Supreme Court.

  And I did that 4 days ago, when I nominated Circuit Court of Appeals Judge Ketanji Brown Jackson.
  One of our nation’s top legal minds, who will continue Justice Breyer’s legacy of excellence.
  --------------------------------------------------------------------------------
  As I said last year, especially to our younger transgender Americans, I will always have your back as your President,
  so you can be yourself and reach your God-given potential.

  While it often appears that we never agree, that isn’t true. I signed 80 bipartisan bills into law last year.
  From preventing government shutdowns to protecting Asian-Americans from still-too-common hate crimes to reforming military justice
*/

// similiarity search using euclidean distance method
const argsL2d: HanaDBArgs = {
  connection: client,
  tableName: "test_fromDocs",
  distanceStrategy: "euclidean",
};
const vectorStoreL2d = new HanaDB(embeddings, argsL2d);
const docsL2d = await vectorStoreL2d.similaritySearch(query, 2);
docsL2d.forEach((docsL2d) => {
  console.log("-".repeat(80));
  console.log(docsL2d.pageContent);
});

// Output should be the same as the cosine similarity search method.

// Maximal Marginal Relevance Search (MMR)
const docsMMR = await vectorStore.maxMarginalRelevanceSearch(query, {
  k: 2,
  fetchK: 20,
});
docsMMR.forEach((docsMMR) => {
  console.log("-".repeat(80));
  console.log(docsMMR.pageContent);
});
/*
  --------------------------------------------------------------------------------
  One of the most serious constitutional responsibilities a President has is nominating someone
  to serve on the United States Supreme Court.

  And I did that 4 days ago, when I nominated Circuit Court of Appeals Judge Ketanji Brown Jackson.
  One of our nation’s top legal minds, who will continue Justice Breyer’s legacy of excellence.
  --------------------------------------------------------------------------------
  Groups of citizens blocking tanks with their bodies. Everyone from students to retirees teachers turned
  soldiers defending their homeland.

  In this struggle as President Zelenskyy said in his speech to the European Parliament “Light will win over darkness.”
  The Ukrainian Ambassador to the United States is here tonight.

  Let each of us here tonight in this Chamber send an unmistakable signal to Ukraine and to the world.
*/
client.disconnect();

```

#### API Reference:

- HanaDBfrom `@langchain/community/vectorstores/hanavector`
- HanaDBArgsfrom `@langchain/community/vectorstores/hanavector`
- OpenAIEmbeddingsfrom `@langchain/openai`
- TextLoaderfrom `langchain/document_loaders/fs/text`
- CharacterTextSplitterfrom `@langchain/textsplitters`

## Creating an HNSW Vector Index [​](https://js.langchain.com/docs/integrations/vectorstores/hanavector/\#creating-an-hnsw-vector-index "Direct link to Creating an HNSW Vector Index")

A vector index can significantly speed up top-k nearest neighbor queries for vectors. Users can create a Hierarchical Navigable Small World (HNSW) vector index using the `create_hnsw_index` function.

For more information about creating an index at the database level, such as parameters requirement, please refer to the [official documentation](https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-vector-engine-guide/create-vector-index-statement-data-definition).

```codeBlockLines_AdAo
import hanaClient from "hdb";
import {
  HanaDB,
  HanaDBArgs,
} from "@langchain/community/vectorstores/hanavector";
import { OpenAIEmbeddings } from "@langchain/openai";

// table "test_fromDocs" is already created with the previous example.
// Now, we will use this existing table to create indexes and perform similarity search.

const connectionParams = {
  host: process.env.HANA_HOST,
  port: process.env.HANA_PORT,
  user: process.env.HANA_UID,
  password: process.env.HANA_PWD,
};
const client = hanaClient.createClient(connectionParams);

// Connect to SAP HANA
await new Promise<void>((resolve, reject) => {
  client.connect((err: Error) => {
    if (err) {
      reject(err);
    } else {
      console.log("Connected to SAP HANA successfully.");
      resolve();
    }
  });
});

// Initialize embeddings
const embeddings = new OpenAIEmbeddings();

// First instance using the existing table "test_fromDocs" (default: Cosine similarity)
const argsCosine: HanaDBArgs = {
  connection: client,
  tableName: "test_fromDocs",
};

// Second instance using the existing table "test_fromDocs" but with L2 Euclidean distance
const argsL2: HanaDBArgs = {
  connection: client,
  tableName: "test_fromDocs",
  distanceStrategy: "euclidean", // Use Euclidean distance for this instance
};

// Initialize both HanaDB instances
const vectorStoreCosine = new HanaDB(embeddings, argsCosine);
const vectorStoreL2 = new HanaDB(embeddings, argsL2);

// Create HNSW index with Cosine similarity (default)
await vectorStoreCosine.createHnswIndex({
  indexName: "hnsw_cosine_index",
  efSearch: 400,
  m: 50,
  efConstruction: 150,
});

// Create HNSW index with Euclidean (L2) distance
await vectorStoreL2.createHnswIndex({
  indexName: "hnsw_l2_index",
  efSearch: 400,
  m: 50,
  efConstruction: 150,
});

// Query text for similarity search
const query = "What did the president say about Ketanji Brown Jackson";

// Perform similarity search using the default Cosine index
const docsCosine = await vectorStoreCosine.similaritySearch(query, 2);
console.log("Cosine Similarity Results:");
docsCosine.forEach((doc) => {
  console.log("-".repeat(80));
  console.log(doc.pageContent);
});
/*
Cosine Similarity Results:
----------------------------------------------------------------------
One of the most serious constitutional ...

And I did that 4 days ago, when I ...
----------------------------------------------------------------------
As I said last year, especially ...

While it often appears that we never agree, that isn’t true...
*/
// Perform similarity search using Euclidean distance (L2 index)
const docsL2 = await vectorStoreL2.similaritySearch(query, 2);
console.log("Euclidean (L2) Distance Results:");
docsL2.forEach((doc) => {
  console.log("-".repeat(80));
  console.log(doc.pageContent);
});
// The L2 distance results should be the same as cosine search results.

// Disconnect from SAP HANA after the operations
client.disconnect();

```

#### API Reference:

- HanaDBfrom `@langchain/community/vectorstores/hanavector`
- HanaDBArgsfrom `@langchain/community/vectorstores/hanavector`
- OpenAIEmbeddingsfrom `@langchain/openai`

## Basic Vectorstore Operations [​](https://js.langchain.com/docs/integrations/vectorstores/hanavector/\#basic-vectorstore-operations "Direct link to Basic Vectorstore Operations")

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import hanaClient from "hdb";
// or import another node.js driver
// import hanaClient from "@sap/haha-client";
import { Document } from "@langchain/core/documents";
import {
  HanaDB,
  HanaDBArgs,
} from "@langchain/community/vectorstores/hanavector";

const connectionParams = {
  host: process.env.HANA_HOST,
  port: process.env.HANA_PORT,
  user: process.env.HANA_UID,
  password: process.env.HANA_PWD,
  // useCesu8 : false
};
const client = hanaClient.createClient(connectionParams);
// connet to hanaDB
await new Promise<void>((resolve, reject) => {
  client.connect((err: Error) => {
    // Use arrow function here
    if (err) {
      reject(err);
    } else {
      console.log("Connected to SAP HANA successfully.");
      resolve();
    }
  });
});
const embeddings = new OpenAIEmbeddings();
// define instance args
const args: HanaDBArgs = {
  connection: client,
  tableName: "testBasics",
};

// Add documents with metadata.
const docs: Document[] = [\
  {\
    pageContent: "foo",\
    metadata: { start: 100, end: 150, docName: "foo.txt", quality: "bad" },\
  },\
  {\
    pageContent: "bar",\
    metadata: { start: 200, end: 250, docName: "bar.txt", quality: "good" },\
  },\
];

// Create a LangChain VectorStore interface for the HANA database and specify the table (collection) to use in args.
const vectorStore = new HanaDB(embeddings, args);
// need to initialize once an instance is created.
await vectorStore.initialize();
// Delete already existing documents from the table
await vectorStore.delete({ filter: {} });
await vectorStore.addDocuments(docs);
// Query documents with specific metadata.
const filterMeta = { quality: "bad" };
const query = "foobar";
// With filtering on {"quality": "bad"}, only one document should be returned
const results = await vectorStore.similaritySearch(query, 1, filterMeta);
console.log(results);
/*
    [  {\
        pageContent: "foo",\
        metadata: { start: 100, end: 150, docName: "foo.txt", quality: "bad" }\
      }\
    ]
*/
// Delete documents with specific metadata.
await vectorStore.delete({ filter: filterMeta });
// Now the similarity search with the same filter will return no results
const resultsAfterFilter = await vectorStore.similaritySearch(
  query,
  1,
  filterMeta
);
console.log(resultsAfterFilter);
/*
    []
*/
client.disconnect();

```

#### API Reference:

- OpenAIEmbeddingsfrom `@langchain/openai`
- Documentfrom `@langchain/core/documents`
- HanaDBfrom `@langchain/community/vectorstores/hanavector`
- HanaDBArgsfrom `@langchain/community/vectorstores/hanavector`

## Advanced filtering [​](https://js.langchain.com/docs/integrations/vectorstores/hanavector/\#advanced-filtering "Direct link to Advanced filtering")

In addition to the basic value-based filtering capabilities, it is possible to use more advanced filtering. The table below shows the available filter operators.

| Operator | Semantic |
| --- | --- |
| `$eq` | Equality (==) |
| `$ne` | Inequality (!=) |
| `$lt` | Less than (<) |
| `$lte` | Less than or equal (<=) |
| `$gt` | Greater than (>) |
| `$gte` | Greater than or equal (>=) |
| `$in` | Contained in a set of given values (in) |
| `$nin` | Not contained in a set of given values (not in) |
| `$between` | Between the range of two boundary values |
| `$like` | Text equality based on the "LIKE" semantics in SQL (using "%" as wildcard) |
| `$and` | Logical "and", supporting 2 or more operands |
| `$or` | Logical "or", supporting 2 or more operands |

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import hanaClient from "hdb";
import { Document } from "@langchain/core/documents";
import {
  HanaDB,
  HanaDBArgs,
} from "@langchain/community/vectorstores/hanavector";

const connectionParams = {
  host: process.env.HANA_HOST,
  port: process.env.HANA_PORT,
  user: process.env.HANA_UID,
  password: process.env.HANA_PWD,
};
const client = hanaClient.createClient(connectionParams);

// Connect to SAP HANA
await new Promise<void>((resolve, reject) => {
  client.connect((err: Error) => {
    if (err) {
      reject(err);
    } else {
      console.log("Connected to SAP HANA successfully.");
      resolve();
    }
  });
});

const docs: Document[] = [\
  {\
    pageContent: "First",\
    metadata: { name: "adam", is_active: true, id: 1, height: 10.0 },\
  },\
  {\
    pageContent: "Second",\
    metadata: { name: "bob", is_active: false, id: 2, height: 5.7 },\
  },\
  {\
    pageContent: "Third",\
    metadata: { name: "jane", is_active: true, id: 3, height: 2.4 },\
  },\
];

// Initialize embeddings
const embeddings = new OpenAIEmbeddings();

const args: HanaDBArgs = {
  connection: client,
  tableName: "testAdvancedFilters",
};

// Create a LangChain VectorStore interface for the HANA database and specify the table (collection) to use in args.
const vectorStore = new HanaDB(embeddings, args);
// need to initialize once an instance is created.
await vectorStore.initialize();
// Delete already existing documents from the table
await vectorStore.delete({ filter: {} });
await vectorStore.addDocuments(docs);

// Helper function to print filter results
function printFilterResult(result: Document[]) {
  if (result.length === 0) {
    console.log("<empty result>");
  } else {
    result.forEach((doc) => console.log(doc.metadata));
  }
}

let advancedFilter;

// Not equal
advancedFilter = { id: { $ne: 1 } };
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"id":{"$ne":1}}
{ name: 'bob', is_active: false, id: 2, height: 5.7 }
{ name: 'jane', is_active: true, id: 3, height: 2.4 }
*/

// Between range
advancedFilter = { id: { $between: [1, 2] } };
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"id":{"$between":[1,2]}}
{ name: 'adam', is_active: true, id: 1, height: 10 }
{ name: 'bob', is_active: false, id: 2, height: 5.7 } */

// In list
advancedFilter = { name: { $in: ["adam", "bob"] } };
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"name":{"$in":["adam","bob"]}}
{ name: 'adam', is_active: true, id: 1, height: 10 }
{ name: 'bob', is_active: false, id: 2, height: 5.7 } */

// Not in list
advancedFilter = { name: { $nin: ["adam", "bob"] } };
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"name":{"$nin":["adam","bob"]}}
{ name: 'jane', is_active: true, id: 3, height: 2.4 } */

// Greater than
advancedFilter = { id: { $gt: 1 } };
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"id":{"$gt":1}}
{ name: 'bob', is_active: false, id: 2, height: 5.7 }
{ name: 'jane', is_active: true, id: 3, height: 2.4 } */

// Greater than or equal to
advancedFilter = { id: { $gte: 1 } };
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"id":{"$gte":1}}
{ name: 'adam', is_active: true, id: 1, height: 10 }
{ name: 'bob', is_active: false, id: 2, height: 5.7 }
{ name: 'jane', is_active: true, id: 3, height: 2.4 } */

// Less than
advancedFilter = { id: { $lt: 1 } };
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"id":{"$lt":1}}
<empty result> */

// Less than or equal to
advancedFilter = { id: { $lte: 1 } };
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"id":{"$lte":1}}
{ name: 'adam', is_active: true, id: 1, height: 10 } */

// Text filtering with $like
advancedFilter = { name: { $like: "a%" } };
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"name":{"$like":"a%"}}
{ name: 'adam', is_active: true, id: 1, height: 10 } */

advancedFilter = { name: { $like: "%a%" } };
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"name":{"$like":"%a%"}}
{ name: 'adam', is_active: true, id: 1, height: 10 }
{ name: 'jane', is_active: true, id: 3, height: 2.4 } */

// Combined filtering with $or
advancedFilter = { $or: [{ id: 1 }, { name: "bob" }] };
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"$or":[{"id":1},{"name":"bob"}]}
{ name: 'adam', is_active: true, id: 1, height: 10 }
{ name: 'bob', is_active: false, id: 2, height: 5.7 } */

// Combined filtering with $and
advancedFilter = { $and: [{ id: 1 }, { id: 2 }] };
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"$and":[{"id":1},{"id":2}]}
<empty result> */

advancedFilter = { $or: [{ id: 1 }, { id: 2 }, { id: 3 }] };
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"$or":[{"id":1},{"id":2},{"id":3}]}
{ name: 'adam', is_active: true, id: 1, height: 10 }
{ name: 'bob', is_active: false, id: 2, height: 5.7 }
{ name: 'jane', is_active: true, id: 3, height: 2.4 } */

// You can also define a nested filter with $and and $or.
advancedFilter = {
  $and: [{ $or: [{ id: 1 }, { id: 2 }] }, { height: { $gte: 5.0 } }],
};
console.log(`Filter: ${JSON.stringify(advancedFilter)}`);
printFilterResult(
  await vectorStore.similaritySearch("just testing", 5, advancedFilter)
);
/* Filter: {"$and":[{"$or":[{"id":1},{"id":2}]},{"height":{"$gte":5.0}}]}
{ name: 'adam', is_active: true, id: 1, height: 10 }
{ name: 'bob', is_active: false, id: 2, height: 5.7 } */

// Disconnect from SAP HANA aft er the operations
client.disconnect();

```

#### API Reference:

- OpenAIEmbeddingsfrom `@langchain/openai`
- Documentfrom `@langchain/core/documents`
- HanaDBfrom `@langchain/community/vectorstores/hanavector`
- HanaDBArgsfrom `@langchain/community/vectorstores/hanavector`

## Using a VectorStore as a retriever in chains for retrieval augmented generation (RAG) [​](https://js.langchain.com/docs/integrations/vectorstores/hanavector/\#using-a-vectorstore-as-a-retriever-in-chains-for-retrieval-augmented-generation-rag "Direct link to Using a VectorStore as a retriever in chains for retrieval augmented generation (RAG)")

```codeBlockLines_AdAo
import { ChatPromptTemplate } from "@langchain/core/prompts";
import { ChatOpenAI, OpenAIEmbeddings } from "@langchain/openai";
import { createStuffDocumentsChain } from "langchain/chains/combine_documents";
import { createRetrievalChain } from "langchain/chains/retrieval";
import hanaClient from "hdb";
import {
  HanaDB,
  HanaDBArgs,
} from "@langchain/community/vectorstores/hanavector";

// Connection parameters
const connectionParams = {
  host: process.env.HANA_HOST,
  port: process.env.HANA_PORT,
  user: process.env.HANA_UID,
  password: process.env.HANA_PWD,
  // useCesu8 : false
};
const client = hanaClient.createClient(connectionParams);
// connet to hanaDB
await new Promise<void>((resolve, reject) => {
  client.connect((err: Error) => {
    // Use arrow function here
    if (err) {
      reject(err);
    } else {
      console.log("Connected to SAP HANA successfully.");
      resolve();
    }
  });
});
const embeddings = new OpenAIEmbeddings();

const args: HanaDBArgs = {
  connection: client,
  tableName: "test_fromDocs",
};
const vectorStore = new HanaDB(embeddings, args);
await vectorStore.initialize();
// Use the store as part of a chain, under the premise that "test_fromDocs" exists and contains the chunked docs.
const model = new ChatOpenAI({ modelName: "gpt-3.5-turbo-1106" });
const questionAnsweringPrompt = ChatPromptTemplate.fromMessages([\
  [\
    "system",\
    "You are an expert in state of the union topics. You are provided multiple context items that are related to the prompt you have to answer. Use the following pieces of context to answer the question at the end.\n\n{context}",\
  ],\
  ["human", "{input}"],\
]);

const combineDocsChain = await createStuffDocumentsChain({
  llm: model,
  prompt: questionAnsweringPrompt,
});

const chain = await createRetrievalChain({
  retriever: vectorStore.asRetriever(),
  combineDocsChain,
});

// Ask the first question (and verify how many text chunks have been used).
const response = await chain.invoke({
  input: "What about Mexico and Guatemala?",
});

console.log("Chain response:");
console.log(response.answer);
console.log(
  `Number of used source document chunks: ${response.context.length}`
);
/*
 The United States has set up joint patrols with Mexico and Guatemala to catch more human traffickers.
 Number of used source document chunks: 4
*/
const responseOther = await chain.invoke({
  input: "What about other countries?",
});
console.log("Chain response:");
console.log(responseOther.answer);
/* Ask another question on the same conversational chain. The answer should relate to the previous answer given.
....including members of NATO, the European Union, and other allies such as Canada....
*/
client.disconnect();

```

#### API Reference:

- ChatPromptTemplatefrom `@langchain/core/prompts`
- ChatOpenAIfrom `@langchain/openai`
- OpenAIEmbeddingsfrom `@langchain/openai`
- createStuffDocumentsChainfrom `langchain/chains/combine_documents`
- createRetrievalChainfrom `langchain/chains/retrieval`
- HanaDBfrom `@langchain/community/vectorstores/hanavector`
- HanaDBArgsfrom `@langchain/community/vectorstores/hanavector`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/hanavector/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/hanavector/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/hanavector/#setup)
- [Create a new index from texts](https://js.langchain.com/docs/integrations/vectorstores/hanavector/#create-a-new-index-from-texts)
- [Create a new index from a loader and perform similarity searches](https://js.langchain.com/docs/integrations/vectorstores/hanavector/#create-a-new-index-from-a-loader-and-perform-similarity-searches)
- [Creating an HNSW Vector Index](https://js.langchain.com/docs/integrations/vectorstores/hanavector/#creating-an-hnsw-vector-index)
- [Basic Vectorstore Operations](https://js.langchain.com/docs/integrations/vectorstores/hanavector/#basic-vectorstore-operations)
- [Advanced filtering](https://js.langchain.com/docs/integrations/vectorstores/hanavector/#advanced-filtering)
- [Using a VectorStore as a retriever in chains for retrieval augmented generation (RAG)](https://js.langchain.com/docs/integrations/vectorstores/hanavector/#using-a-vectorstore-as-a-retriever-in-chains-for-retrieval-augmented-generation-rag)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/hanavector/#related)