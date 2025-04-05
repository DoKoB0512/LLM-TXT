[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

# Vector stores

A [vector store](https://js.langchain.com/docs/concepts/#vectorstores) stores [embedded](https://js.langchain.com/docs/concepts/embedding_models) data and performs similarity search.

### Pick your embedding model:

- OpenAI
- Azure
- AWS
- VertexAI
- MistralAI
- Cohere

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/openai

```

```codeBlockLines_AdAo
yarn add @langchain/openai

```

```codeBlockLines_AdAo
pnpm add @langchain/openai

```

```codeBlockLines_AdAo
OPENAI_API_KEY=your-api-key

```

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-large"
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/openai

```

```codeBlockLines_AdAo
yarn add @langchain/openai

```

```codeBlockLines_AdAo
pnpm add @langchain/openai

```

```codeBlockLines_AdAo
AZURE_OPENAI_API_INSTANCE_NAME=<YOUR_INSTANCE_NAME>
AZURE_OPENAI_API_KEY=<YOUR_KEY>
AZURE_OPENAI_API_VERSION="2024-02-01"

```

```codeBlockLines_AdAo
import { AzureOpenAIEmbeddings } from "@langchain/openai";

const embeddings = new AzureOpenAIEmbeddings({
  azureOpenAIApiEmbeddingsDeploymentName: "text-embedding-ada-002"
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/aws

```

```codeBlockLines_AdAo
yarn add @langchain/aws

```

```codeBlockLines_AdAo
pnpm add @langchain/aws

```

```codeBlockLines_AdAo
BEDROCK_AWS_REGION=your-region

```

```codeBlockLines_AdAo
import { BedrockEmbeddings } from "@langchain/aws";

const embeddings = new BedrockEmbeddings({
  model: "amazon.titan-embed-text-v1"
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/google-vertexai

```

```codeBlockLines_AdAo
yarn add @langchain/google-vertexai

```

```codeBlockLines_AdAo
pnpm add @langchain/google-vertexai

```

```codeBlockLines_AdAo
GOOGLE_APPLICATION_CREDENTIALS=credentials.json

```

```codeBlockLines_AdAo
import { VertexAIEmbeddings } from "@langchain/google-vertexai";

const embeddings = new VertexAIEmbeddings({
  model: "text-embedding-004"
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/mistralai

```

```codeBlockLines_AdAo
yarn add @langchain/mistralai

```

```codeBlockLines_AdAo
pnpm add @langchain/mistralai

```

```codeBlockLines_AdAo
MISTRAL_API_KEY=your-api-key

```

```codeBlockLines_AdAo
import { MistralAIEmbeddings } from "@langchain/mistralai";

const embeddings = new MistralAIEmbeddings({
  model: "mistral-embed"
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/cohere

```

```codeBlockLines_AdAo
yarn add @langchain/cohere

```

```codeBlockLines_AdAo
pnpm add @langchain/cohere

```

```codeBlockLines_AdAo
COHERE_API_KEY=your-api-key

```

```codeBlockLines_AdAo
import { CohereEmbeddings } from "@langchain/cohere";

const embeddings = new CohereEmbeddings({
  model: "embed-english-v3.0"
});

```

### Pick your vector store:

- Memory
- Chroma
- FAISS
- MongoDB
- PGVector
- Pinecone
- Qdrant

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i langchain

```

```codeBlockLines_AdAo
yarn add langchain

```

```codeBlockLines_AdAo
pnpm add langchain

```

```codeBlockLines_AdAo
import { MemoryVectorStore } from "langchain/vectorstores/memory";

const vectorStore = new MemoryVectorStore(embeddings);

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/community

```

```codeBlockLines_AdAo
yarn add @langchain/community

```

```codeBlockLines_AdAo
pnpm add @langchain/community

```

```codeBlockLines_AdAo
import { Chroma } from "@langchain/community/vectorstores/chroma";

const vectorStore = new Chroma(embeddings, {
  collectionName: "a-test-collection",
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/community

```

```codeBlockLines_AdAo
yarn add @langchain/community

```

```codeBlockLines_AdAo
pnpm add @langchain/community

```

```codeBlockLines_AdAo
import { FaissStore } from "@langchain/community/vectorstores/faiss";

const vectorStore = new FaissStore(embeddings, {});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/mongodb

```

```codeBlockLines_AdAo
yarn add @langchain/mongodb

```

```codeBlockLines_AdAo
pnpm add @langchain/mongodb

```

```codeBlockLines_AdAo
import { MongoDBAtlasVectorSearch } from "@langchain/mongodb"
import { MongoClient } from "mongodb";

const client = new MongoClient(process.env.MONGODB_ATLAS_URI || "");
const collection = client
  .db(process.env.MONGODB_ATLAS_DB_NAME)
  .collection(process.env.MONGODB_ATLAS_COLLECTION_NAME);

const vectorStore = new MongoDBAtlasVectorSearch(embeddings, {
  collection: collection,
  indexName: "vector_index",
  textKey: "text",
  embeddingKey: "embedding",
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/community

```

```codeBlockLines_AdAo
yarn add @langchain/community

```

```codeBlockLines_AdAo
pnpm add @langchain/community

```

```codeBlockLines_AdAo
import { PGVectorStore } from "@langchain/community/vectorstores/pgvector";

const vectorStore = await PGVectorStore.initialize(embeddings, {})

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/pinecone

```

```codeBlockLines_AdAo
yarn add @langchain/pinecone

```

```codeBlockLines_AdAo
pnpm add @langchain/pinecone

```

```codeBlockLines_AdAo
import { PineconeStore } from "@langchain/pinecone";
import { Pinecone as PineconeClient } from "@pinecone-database/pinecone";

const pinecone = new PineconeClient();
const vectorStore = new PineconeStore(embeddings, {
  pineconeIndex,
  maxConcurrency: 5,
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/qdrant

```

```codeBlockLines_AdAo
yarn add @langchain/qdrant

```

```codeBlockLines_AdAo
pnpm add @langchain/qdrant

```

```codeBlockLines_AdAo
import { QdrantVectorStore } from "@langchain/qdrant";

const vectorStore = await QdrantVectorStore.fromExistingCollection(embeddings, {
  url: process.env.QDRANT_URL,
  collectionName: "langchainjs-testing",
});

```

LangChain.js integrates with a variety of vector stores. You can check out a full list below:

| Name | Description |
| --- | --- |
| [AnalyticDB](https://js.langchain.com/docs/integrations/vectorstores/analyticdb) | AnalyticDB for PostgreSQL is a massively parallel processing (MPP) da... |
| [Astra DB](https://js.langchain.com/docs/integrations/vectorstores/astradb) | Only available on Node.js. |
| [Azion EdgeSQL](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql) | The AzionVectorStore is used to manage and search through a collection |
| [Azure AI Search](https://js.langchain.com/docs/integrations/vectorstores/azure_aisearch) | Azure AI Search (formerly known as Azure Search and Azure Cognitive S... |
| [Azure Cosmos DB for MongoDB vCore](https://js.langchain.com/docs/integrations/vectorstores/azure_cosmosdb_mongodb) | Azure Cosmos DB for MongoDB vCore makes it easy to create a database ... |
| [Azure Cosmos DB for NoSQL](https://js.langchain.com/docs/integrations/vectorstores/azure_cosmosdb_nosql) | Azure Cosmos DB for NoSQL provides support for querying items with fl... |
| [Cassandra](https://js.langchain.com/docs/integrations/vectorstores/cassandra) | Only available on Node.js. |
| [Chroma](https://js.langchain.com/docs/integrations/vectorstores/chroma) | Chroma is a AI-native |
| [ClickHouse](https://js.langchain.com/docs/integrations/vectorstores/clickhouse) | Only available on Node.js. |
| [CloseVector](https://js.langchain.com/docs/integrations/vectorstores/closevector) | available on both browser and Node.js |
| [Cloudflare Vectorize](https://js.langchain.com/docs/integrations/vectorstores/cloudflare_vectorize) | If you're deploying your project in a Cloudflare worker, you can use ... |
| [Convex](https://js.langchain.com/docs/integrations/vectorstores/convex) | LangChain.js supports Convex as a vector store, and supports the stan... |
| [Couchbase](https://js.langchain.com/docs/integrations/vectorstores/couchbase) | Couchbase is an award-winning distributed NoSQL cloud database that d... |
| [Elasticsearch](https://js.langchain.com/docs/integrations/vectorstores/elasticsearch) | Elasticsearch is a |
| [Faiss](https://js.langchain.com/docs/integrations/vectorstores/faiss) | Faiss is a library for |
| [Google Cloud SQL for PostgreSQL](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg) | Cloud SQL is a fully managed relational |
| [Google Vertex AI Matching Engine](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai) | Only available on Node.js. |
| [SAP HANA Cloud Vector Engine](https://js.langchain.com/docs/integrations/vectorstores/hanavector) | SAP HANA Cloud Vector Engine is a vector store fully integrated into ... |
| [HNSWLib](https://js.langchain.com/docs/integrations/vectorstores/hnswlib) | HNSWLib is an in-memory vector store that can be saved to a file. It |
| [LanceDB](https://js.langchain.com/docs/integrations/vectorstores/lancedb) | LanceDB is an embedded vector database for AI applications. It is ope... |
| [libSQL](https://js.langchain.com/docs/integrations/vectorstores/libsql) | Turso is a SQLite-compatible database built on libSQL, the Open Contr... |
| [MariaDB](https://js.langchain.com/docs/integrations/vectorstores/mariadb) | This requires MariaDB 11.7 or later version |
| [In-memory](https://js.langchain.com/docs/integrations/vectorstores/memory) | LangChain offers is an in-memory, ephemeral vectorstore that stores |
| [Milvus](https://js.langchain.com/docs/integrations/vectorstores/milvus) | Milvus is a vector database built for embeddings similarity search an... |
| [Momento Vector Index (MVI)](https://js.langchain.com/docs/integrations/vectorstores/momento_vector_index) | MVI: the most productive, easiest to use, serverless vector index for... |
| [MongoDB Atlas](https://js.langchain.com/docs/integrations/vectorstores/mongodb_atlas) | This guide provides a quick overview for getting started with MongoDB |
| [MyScale](https://js.langchain.com/docs/integrations/vectorstores/myscale) | Only available on Node.js. |
| [Neo4j Vector Index](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector) | Neo4j is an open-source graph database with integrated support for ve... |
| [Neon Postgres](https://js.langchain.com/docs/integrations/vectorstores/neon) | Neon is a fully managed serverless PostgreSQL database. It separates ... |
| [OpenSearch](https://js.langchain.com/docs/integrations/vectorstores/opensearch) | Only available on Node.js. |
| [PGVector](https://js.langchain.com/docs/integrations/vectorstores/pgvector) | To enable vector search in generic PostgreSQL databases, LangChain.js |
| [Pinecone](https://js.langchain.com/docs/integrations/vectorstores/pinecone) | Pinecone is a vector database that helps |
| [Prisma](https://js.langchain.com/docs/integrations/vectorstores/prisma) | For augmenting existing models in PostgreSQL database with vector sea... |
| [Qdrant](https://js.langchain.com/docs/integrations/vectorstores/qdrant) | Qdrant is a vector similarity search engine. It |
| [Redis](https://js.langchain.com/docs/integrations/vectorstores/redis) | Redis is a fast open source, in-memory data store. |
| [Rockset](https://js.langchain.com/docs/integrations/vectorstores/rockset) | Rockset is a real-time analyitics SQL database that runs in the cloud. |
| [SingleStore](https://js.langchain.com/docs/integrations/vectorstores/singlestore) | SingleStoreDB is a robust, high-performance distributed SQL database ... |
| [Supabase](https://js.langchain.com/docs/integrations/vectorstores/supabase) | Supabase is an open-source Firebase |
| [Tigris](https://js.langchain.com/docs/integrations/vectorstores/tigris) | Tigris makes it easy to build AI applications with vector embeddings. |
| [Turbopuffer](https://js.langchain.com/docs/integrations/vectorstores/turbopuffer) | Setup |
| [TypeORM](https://js.langchain.com/docs/integrations/vectorstores/typeorm) | To enable vector search in a generic PostgreSQL database, LangChain.j... |
| [Typesense](https://js.langchain.com/docs/integrations/vectorstores/typesense) | Vector store that utilizes the Typesense search engine. |
| [Upstash Vector](https://js.langchain.com/docs/integrations/vectorstores/upstash) | Upstash Vector is a REST based serverless vector |
| [USearch](https://js.langchain.com/docs/integrations/vectorstores/usearch) | Only available on Node.js. |
| [Vectara](https://js.langchain.com/docs/integrations/vectorstores/vectara) | Vectara is a platform for building GenAI applications. It provides an... |
| [Vercel Postgres](https://js.langchain.com/docs/integrations/vectorstores/vercel_postgres) | LangChain.js supports using the @vercel/postgres package to use gener... |
| [Voy](https://js.langchain.com/docs/integrations/vectorstores/voy) | Voy is a WASM vector similarity search engine written in Rust. |
| [Weaviate](https://js.langchain.com/docs/integrations/vectorstores/weaviate) | Weaviate is an open source vector database that |
| [Xata](https://js.langchain.com/docs/integrations/vectorstores/xata) | Xata is a serverless data platform, based on PostgreSQL. It provides ... |
| [Zep Open Source](https://js.langchain.com/docs/integrations/vectorstores/zep) | Zep is a long-term memory service for AI Assistant apps. |
| [Zep Cloud](https://js.langchain.com/docs/integrations/vectorstores/zep_cloud) | Zep is a long-term memory service for AI Assistant apps. |

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/%3E).