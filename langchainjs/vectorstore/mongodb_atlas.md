[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

Compatibility

Only available on Node.js.

You can still create API routes that use MongoDB with Next.js by setting the `runtime` variable to `nodejs` like so:

`export const runtime = "nodejs";`

You can read more about Edge runtimes in the Next.js documentation [here](https://nextjs.org/docs/app/building-your-application/rendering/edge-and-nodejs-runtimes).

This guide provides a quick overview for getting started with MongoDB
Atlas [vector stores](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `MongoDBAtlasVectorSearch` features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_mongodb.MongoDBAtlasVectorSearch.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#integration-details "Direct link to Integration details")

| Class | Package | [PY support](https://python.langchain.com/docs/integrations/vectorstores/mongodb_atlas/) | Package latest |
| :-- | :-- | :-: | :-: |
| [`MongoDBAtlasVectorSearch`](https://api.js.langchain.com/classes/langchain_mongodb.MongoDBAtlasVectorSearch.html) | [`@langchain/mongodb`](https://www.npmjs.com/package/@langchain/mongodb) | ✅ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/mongodb?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#setup "Direct link to Setup")

To use MongoDB Atlas vector stores, you’ll need to configure a MongoDB
Atlas cluster and install the `@langchain/mongodb` integration package.

### Initial Cluster Configuration [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#initial-cluster-configuration "Direct link to Initial Cluster Configuration")

To create a MongoDB Atlas cluster, navigate to the [MongoDB Atlas\\
website](https://www.mongodb.com/products/platform/atlas-database) and
create an account if you don’t already have one.

Create and name a cluster when prompted, then find it under `Database`.
Select `Browse Collections` and create either a blank collection or one
from the provided sample data.

**Note:** The cluster created must be MongoDB 7.0 or higher.

### Creating an Index [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#creating-an-index "Direct link to Creating an Index")

After configuring your cluster, you’ll need to create an index on the
collection field you want to search over.

Switch to the `Atlas Search` tab and click `Create Search Index`. From
there, make sure you select `Atlas Vector Search - JSON Editor`, then
select the appropriate database and collection and paste the following
into the textbox:

```codeBlockLines_AdAo
{
  "fields": [\
    {\
      "numDimensions": 1536,\
      "path": "embedding",\
      "similarity": "euclidean",\
      "type": "vector"\
    }\
  ]
}

```

Note that the dimensions property should match the dimensionality of the
embeddings you are using. For example, Cohere embeddings have 1024
dimensions, and by default OpenAI embeddings have 1536:

Note: By default the vector store expects an index name of default, an
indexed collection field name of embedding, and a raw text field name of
text. You should initialize the vector store with field names matching
your index name collection schema as shown below.

Finally, proceed to build the index.

### Embeddings [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#embeddings "Direct link to Embeddings")

This guide will also use [OpenAI\\
embeddings](https://js.langchain.com/docs/integrations/text_embedding/openai), which require you
to install the `@langchain/openai` integration package. You can also use
[other supported embeddings models](https://js.langchain.com/docs/integrations/text_embedding)
if you wish.

### Installation [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#installation "Direct link to Installation")

Install the following packages:

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/mongodb mongodb @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/mongodb mongodb @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/mongodb mongodb @langchain/openai @langchain/core

```

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#credentials "Direct link to Credentials")

Once you’ve done the above, set the `MONGODB_ATLAS_URI` environment
variable from the `Connect` button in Mongo’s dashboard. You’ll also
need your DB name and collection name:

```codeBlockLines_AdAo
process.env.MONGODB_ATLAS_URI = "your-atlas-url";
process.env.MONGODB_ATLAS_COLLECTION_NAME = "your-atlas-db-name";
process.env.MONGODB_ATLAS_DB_NAME = "your-atlas-db-name";

```

If you are using OpenAI embeddings for this guide, you’ll need to set
your OpenAI key as well:

```codeBlockLines_AdAo
process.env.OPENAI_API_KEY = "YOUR_API_KEY";

```

If you want to get automated tracing of your model calls you can also
set your [LangSmith](https://docs.smith.langchain.com/) API key by
uncommenting below:

```codeBlockLines_AdAo
// process.env.LANGSMITH_TRACING="true"
// process.env.LANGSMITH_API_KEY="your-api-key"

```

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#instantiation "Direct link to Instantiation")

Once you’ve set up your cluster as shown above, you can initialize your
vector store as follows:

```codeBlockLines_AdAo
import { MongoDBAtlasVectorSearch } from "@langchain/mongodb";
import { OpenAIEmbeddings } from "@langchain/openai";
import { MongoClient } from "mongodb";

const client = new MongoClient(process.env.MONGODB_ATLAS_URI || "");
const collection = client
  .db(process.env.MONGODB_ATLAS_DB_NAME)
  .collection(process.env.MONGODB_ATLAS_COLLECTION_NAME);

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

const vectorStore = new MongoDBAtlasVectorSearch(embeddings, {
  collection: collection,
  indexName: "vector_index", // The name of the Atlas search index. Defaults to "default"
  textKey: "text", // The name of the collection field containing the raw content. Defaults to "text"
  embeddingKey: "embedding", // The name of the collection field containing the embedded text. Defaults to "embedding"
});

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#add-items-to-vector-store "Direct link to Add items to vector store")

You can now add documents to your vector store:

```codeBlockLines_AdAo
import type { Document } from "@langchain/core/documents";

const document1: Document = {
  pageContent: "The powerhouse of the cell is the mitochondria",
  metadata: { source: "https://example.com" },
};

const document2: Document = {
  pageContent: "Buildings are made out of brick",
  metadata: { source: "https://example.com" },
};

const document3: Document = {
  pageContent: "Mitochondria are made out of lipids",
  metadata: { source: "https://example.com" },
};

const document4: Document = {
  pageContent: "The 2024 Olympics are in Paris",
  metadata: { source: "https://example.com" },
};

const documents = [document1, document2, document3, document4];

await vectorStore.addDocuments(documents, { ids: ["1", "2", "3", "4"] });

```

```codeBlockLines_AdAo
[ '1', '2', '3', '4' ]

```

**Note:** After adding documents, there is a slight delay before they
become queryable.

Adding a document with the same `id` as an existing document will update
the existing one.

### Delete items from vector store [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#delete-items-from-vector-store "Direct link to Delete items from vector store")

```codeBlockLines_AdAo
await vectorStore.delete({ ids: ["4"] });

```

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
const similaritySearchResults = await vectorStore.similaritySearch(
  "biology",
  2
);

for (const doc of similaritySearchResults) {
  console.log(`* ${doc.pageContent} [${JSON.stringify(doc.metadata, null)}]`);
}

```

```codeBlockLines_AdAo
* The powerhouse of the cell is the mitochondria [{"_id":"1","source":"https://example.com"}]
* Mitochondria are made out of lipids [{"_id":"3","source":"https://example.com"}]

```

### Filtering [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#filtering "Direct link to Filtering")

MongoDB Atlas supports pre-filtering of results on other fields. They
require you to define which metadata fields you plan to filter on by
updating the index you created initially. Here’s an example:

```codeBlockLines_AdAo
{
  "fields": [\
    {\
      "numDimensions": 1024,\
      "path": "embedding",\
      "similarity": "euclidean",\
      "type": "vector"\
    },\
    {\
      "path": "source",\
      "type": "filter"\
    }\
  ]
}

```

Above, the first item in `fields` is the vector index, and the second
item is the metadata property you want to filter on. The name of the
property is the value of the `path` key. So the above index would allow
us to search on a metadata field named `source`.

Then, in your code you can use [MQL Query\\
Operators](https://www.mongodb.com/docs/manual/reference/operator/query/)
for filtering.

The below example illustrates this:

```codeBlockLines_AdAo
const filter = {
  preFilter: {
    source: {
      $eq: "https://example.com",
    },
  },
};

const filteredResults = await vectorStore.similaritySearch(
  "biology",
  2,
  filter
);

for (const doc of filteredResults) {
  console.log(`* ${doc.pageContent} [${JSON.stringify(doc.metadata, null)}]`);
}

```

```codeBlockLines_AdAo
* The powerhouse of the cell is the mitochondria [{"_id":"1","source":"https://example.com"}]
* Mitochondria are made out of lipids [{"_id":"3","source":"https://example.com"}]

```

### Returning scores [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#returning-scores "Direct link to Returning scores")

If you want to execute a similarity search and receive the corresponding
scores you can run:

```codeBlockLines_AdAo
const similaritySearchWithScoreResults =
  await vectorStore.similaritySearchWithScore("biology", 2, filter);

for (const [doc, score] of similaritySearchWithScoreResults) {
  console.log(
    `* [SIM=${score.toFixed(3)}] ${doc.pageContent} [${JSON.stringify(\
      doc.metadata\
    )}]`
  );
}

```

```codeBlockLines_AdAo
* [SIM=0.374] The powerhouse of the cell is the mitochondria [{"_id":"1","source":"https://example.com"}]
* [SIM=0.370] Mitochondria are made out of lipids [{"_id":"3","source":"https://example.com"}]

```

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

You can also transform the vector store into a
[retriever](https://js.langchain.com/docs/concepts/retrievers) for easier usage in your chains.

```codeBlockLines_AdAo
const retriever = vectorStore.asRetriever({
  // Optional filter
  filter: filter,
  k: 2,
});
await retriever.invoke("biology");

```

```codeBlockLines_AdAo
[\
  Document {\
    pageContent: 'The powerhouse of the cell is the mitochondria',\
    metadata: { _id: '1', source: 'https://example.com' },\
    id: undefined\
  },\
  Document {\
    pageContent: 'Mitochondria are made out of lipids',\
    metadata: { _id: '3', source: 'https://example.com' },\
    id: undefined\
  }\
]

```

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## Closing connections [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#closing-connections "Direct link to Closing connections")

Make sure you close the client instance when you are finished to avoid
excessive resource consumption:

```codeBlockLines_AdAo
await client.close();

```

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#api-reference "Direct link to API reference")

For detailed documentation of all `MongoDBAtlasVectorSearch` features
and configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_mongodb.MongoDBAtlasVectorSearch.html).

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/mongodb_atlas/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#setup)
  - [Initial Cluster Configuration](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#initial-cluster-configuration)
  - [Creating an Index](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#creating-an-index)
  - [Embeddings](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#embeddings)
  - [Installation](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#installation)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#add-items-to-vector-store)
  - [Delete items from vector store](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#delete-items-from-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#query-directly)
  - [Filtering](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#filtering)
  - [Returning scores](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#returning-scores)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#usage-for-retrieval-augmented-generation)
- [Closing connections](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#closing-connections)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas/#related)