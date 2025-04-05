[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

Compatibility

Only available on Node.js.

[Elasticsearch](https://github.com/elastic/elasticsearch) is a
distributed, RESTful search engine optimized for speed and relevance on
production-scale workloads. It supports also vector search using the
[k-nearest\\
neighbor](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm)
(kNN) algorithm and also [custom models for Natural Language\\
Processing](https://www.elastic.co/blog/how-to-deploy-nlp-text-embeddings-and-vector-search)
(NLP). You can read more about the support of vector search in
Elasticsearch
[here](https://www.elastic.co/guide/en/elasticsearch/reference/current/knn-search.html).

This guide provides a quick overview for getting started with
Elasticsearch [vector stores](https://js.langchain.com/docs/concepts/#vectorstores). For
detailed documentation of all `ElasticVectorSearch` features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_elasticsearch.ElasticVectorSearch.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#integration-details "Direct link to Integration details")

| Class | Package | [PY support](https://python.langchain.com/docs/integrations/vectorstores/elasticsearch/) | Package latest |
| :-- | :-- | :-: | :-: |
| [`ElasticVectorSearch`](https://api.js.langchain.com/classes/langchain_community_vectorstores_elasticsearch.ElasticVectorSearch.html) | [`@langchain/community`](https://www.npmjs.com/package/@langchain/community) | ✅ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/community?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#setup "Direct link to Setup")

To use Elasticsearch vector stores, you’ll need to install the
`@langchain/community` integration package.

LangChain.js accepts
[`@elastic/elasticsearch`](https://github.com/elastic/elasticsearch-js)
as the client for Elasticsearch vectorstore. You’ll need to install it
as a peer dependency.

This guide will also use [OpenAI\\
embeddings](https://js.langchain.com/docs/integrations/text_embedding/openai), which require you
to install the `@langchain/openai` integration package. You can also use
[other supported embeddings models](https://js.langchain.com/docs/integrations/text_embedding)
if you wish.

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/community @elastic/elasticsearch @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/community @elastic/elasticsearch @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/community @elastic/elasticsearch @langchain/openai @langchain/core

```

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#credentials "Direct link to Credentials")

To use Elasticsearch vector stores, you’ll need to have an Elasticsearch
instance running.

You can use the [official Docker\\
image](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)
to get started, or you can use [Elastic\\
Cloud](https://www.elastic.co/cloud/), Elastic’s official cloud service.

For connecting to Elastic Cloud you can read the documentation reported
[here](https://www.elastic.co/guide/en/kibana/current/api-keys.html) for
obtaining an API key.

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

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#instantiation "Direct link to Instantiation")

Instatiating Elasticsearch will vary depending on where your instance is
hosted.

```codeBlockLines_AdAo
import {
  ElasticVectorSearch,
  type ElasticClientArgs,
} from "@langchain/community/vectorstores/elasticsearch";
import { OpenAIEmbeddings } from "@langchain/openai";

import { Client, type ClientOptions } from "@elastic/elasticsearch";

import * as fs from "node:fs";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

const config: ClientOptions = {
  node: process.env.ELASTIC_URL ?? "https://127.0.0.1:9200",
};

if (process.env.ELASTIC_API_KEY) {
  config.auth = {
    apiKey: process.env.ELASTIC_API_KEY,
  };
} else if (process.env.ELASTIC_USERNAME && process.env.ELASTIC_PASSWORD) {
  config.auth = {
    username: process.env.ELASTIC_USERNAME,
    password: process.env.ELASTIC_PASSWORD,
  };
}
// Local Docker deploys require a TLS certificate
if (process.env.ELASTIC_CERT_PATH) {
  config.tls = {
    ca: fs.readFileSync(process.env.ELASTIC_CERT_PATH),
    rejectUnauthorized: false,
  };
}
const clientArgs: ElasticClientArgs = {
  client: new Client(config),
  indexName: process.env.ELASTIC_INDEX ?? "test_vectorstore",
};

const vectorStore = new ElasticVectorSearch(embeddings, clientArgs);

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#add-items-to-vector-store "Direct link to Add items to vector store")

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

### Delete items from vector store [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#delete-items-from-vector-store "Direct link to Delete items from vector store")

You can delete values from the store by passing the same id you passed
in:

```codeBlockLines_AdAo
await vectorStore.delete({ ids: ["4"] });

```

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
const filter = [\
  {\
    operator: "match",\
    field: "source",\
    value: "https://example.com",\
  },\
];

const similaritySearchResults = await vectorStore.similaritySearch(
  "biology",
  2,
  filter
);

for (const doc of similaritySearchResults) {
  console.log(`* ${doc.pageContent} [${JSON.stringify(doc.metadata, null)}]`);
}

```

```codeBlockLines_AdAo
* The powerhouse of the cell is the mitochondria [{"source":"https://example.com"}]
* Mitochondria are made out of lipids [{"source":"https://example.com"}]

```

The vector store supports [Elasticsearch filter\\
syntax](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-filter-context.html)
operators.

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
* [SIM=0.374] The powerhouse of the cell is the mitochondria [{"source":"https://example.com"}]
* [SIM=0.370] Mitochondria are made out of lipids [{"source":"https://example.com"}]

```

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

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
    metadata: { source: 'https://example.com' },\
    id: undefined\
  },\
  Document {\
    pageContent: 'Mitochondria are made out of lipids',\
    metadata: { source: 'https://example.com' },\
    id: undefined\
  }\
]

```

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#api-reference "Direct link to API reference")

For detailed documentation of all `ElasticVectorSearch` features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_elasticsearch.ElasticVectorSearch.html).

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/elasticsearch/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#setup)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#add-items-to-vector-store)
  - [Delete items from vector store](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#delete-items-from-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#query-directly)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#usage-for-retrieval-augmented-generation)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch/#related)