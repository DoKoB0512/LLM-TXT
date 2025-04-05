[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

[Cloud SQL](https://cloud.google.com/sql) is a fully managed relational
database service that offers high performance, seamless integration, and
impressive scalability and offers database engines such as PostgreSQL.

This guide provides a quick overview of how to use Cloud SQL for
PostgreSQL to store vector embeddings with the `PostgresVectorStore`
class.

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#integration-details "Direct link to Integration details")

| Class | Package | [PY support](https://python.langchain.com/docs/integrations/vectorstores/google_cloud_sql_pg/) | Package latest |
| :-- | :-- | :-: | :-: |
| PostgresVectorStore | [`@langchain/google-cloud-sql-pg`](https://www.npmjs.com/package/@langchain/google-cloud-sql-pg) | ✅ | 0.0.1 |

### Before you begin [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#before-you-begin "Direct link to Before you begin")

In order to use this package, you first need to go throught the
following steps:

1. [Select or create a Cloud Platform\\
project.](https://developers.google.com/workspace/guides/create-project)
2. [Enable billing for your\\
project.](https://cloud.google.com/billing/docs/how-to/modify-project#enable_billing_for_a_project)
3. [Enable the Cloud SQL Admin\\
API.](https://console.cloud.google.com/flows/enableapi?apiid=sqladmin.googleapis.com)
4. [Setup\\
Authentication.](https://cloud.google.com/docs/authentication)
5. [Create a CloudSQL\\
instance](https://cloud.google.com/sql/docs/postgres/connect-instance-auth-proxy#create-instance)
6. [Create a CloudSQL\\
database](https://cloud.google.com/sql/docs/postgres/create-manage-databases)
7. [Add a user to the\\
database](https://cloud.google.com/sql/docs/postgres/create-manage-users)

### Authentication [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#authentication "Direct link to Authentication")

Authenticate locally to your Google Cloud account using the
`gcloud auth login` command.

### Set Your Google Cloud Project [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#set-your-google-cloud-project "Direct link to Set Your Google Cloud Project")

Set your Google Cloud project ID to leverage Google Cloud resources
locally:

```codeBlockLines_AdAo
gcloud config set project YOUR-PROJECT-ID

```

If you don’t know your project ID, try the following: \* Run
`gcloud config list`. \* Run `gcloud projects list`. \* See the support
page: [Locate the project\\
ID](https://support.google.com/googleapi/answer/7014113).

## Setting up a PostgresVectorStore instance [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#setting-up-a-postgresvectorstore-instance "Direct link to Setting up a PostgresVectorStore instance")

To use the PostgresVectorStore library, you’ll need to install the
`@langchain/google-cloud-sql-pg` package and then follow the steps
bellow.

First, you’ll need to log in to your Google Cloud account and set the
following environment variables based on your Google Cloud project;
these will be defined based on how you want to configure (fromInstance,
fromEngine, fromEngineArgs) your PostgresEngine instance :

```codeBlockLines_AdAo
PROJECT_ID="your-project-id"
REGION="your-project-region" // example: "us-central1"
INSTANCE_NAME="your-instance"
DB_NAME="your-database-name"
DB_USER="your-database-user"
PASSWORD="your-database-password"

```

### Setting up an instance [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#setting-up-an-instance "Direct link to Setting up an instance")

To instantiate a PostgresVectorStore, you’ll first need to create a
database connection through the PostgresEngine, then initialize the
vector store table and finally call the `.initialize()` method to
instantiate the vector store.

```codeBlockLines_AdAo
import {
  Column,
  PostgresEngine,
  PostgresEngineArgs,
  PostgresVectorStore,
  PostgresVectorStoreArgs,
  VectorStoreTableArgs,
} from "@langchain/google-cloud-sql-pg";
import { SyntheticEmbeddings } from "@langchain/core/utils/testing"; // This is used as an Embedding service
import * as dotenv from "dotenv";

dotenv.config();

const peArgs: PostgresEngineArgs = {
  user: process.env.DB_USER ?? "",
  password: process.env.PASSWORD ?? "",
};

// PostgresEngine instantiation
const engine: PostgresEngine = await PostgresEngine.fromInstance(
  process.env.PROJECT_ID ?? "",
  process.env.REGION ?? "",
  process.env.INSTANCE_NAME ?? "",
  process.env.DB_NAME ?? "",
  peArgs
);

const vectorStoreArgs: VectorStoreTableArgs = {
  metadataColumns: [new Column("page", "TEXT"), new Column("source", "TEXT")],
};

// Vector store table initilization
await engine.initVectorstoreTable("my_vector_store_table", 768, vectorStoreArgs);
const embeddingService = new SyntheticEmbeddings({ vectorSize: 768 });

const pvectorArgs: PostgresVectorStoreArgs = {
  metadataColumns: ["page", "source"],
};

// PostgresVectorStore instantiation
const vectorStore = await PostgresVectorStore.initialize(
  engine,
  embeddingService,
  "my_vector_store_table",
  pvectorArgs
);

```

## Manage Vector Store [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#manage-vector-store "Direct link to Manage Vector Store")

### Add Documents to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#add-documents-to-vector-store "Direct link to Add Documents to vector store")

To add Documents to the vector store, you would be able to it by passing
or not the ids

```codeBlockLines_AdAo
import { v4 as uuidv4 } from "uuid";
import type { Document } from "@langchain/core/documents";

const document1: Document = {
  pageContent: "The powerhouse of the cell is the mitochondria",
  metadata: { page: 0, source: "https://example.com" },
};

const document2: Document = {
  pageContent: "Buildings are made out of brick",
  metadata: { page: 1, source: "https://example.com" },
};

const document3: Document = {
  pageContent: "Mitochondria are made out of lipids",
  metadata: { page: 2, source: "https://example.com" },
};

const document4: Document = {
  pageContent: "The 2024 Olympics are in Paris",
  metadata: { page: 3, source: "https://example.com" },
};

const documents = [document1, document2, document3, document4];

const ids = [uuidv4(), uuidv4(), uuidv4(), uuidv4()];

await vectorStore.addDocuments(documents, { ids: ids });

```

### Delete Documents from vector store [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#delete-documents-from-vector-store "Direct link to Delete Documents from vector store")

You can delete one or more Documents from the vector store by passing
the arrays of ids to be deleted:

```codeBlockLines_AdAo
// deleting a document
const id1 = ids[0];
await vectorStore.delete({ ids: [id1] });

// deleting more than one document
await vectorStore.delete({ ids: ids });

```

## Search for documents [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#search-for-documents "Direct link to Search for documents")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
const filter = `"source" = "https://example.com"`;

const results = await vectorStore.similaritySearch("biology", 2, filter);

for (const doc of results) {
  console.log(`* ${doc.pageContent} [${JSON.stringify(doc.metadata, null)}]`);
}

```

If you want to execute a similarity search and receive the corresponding
scores you can run:

```codeBlockLines_AdAo
const filter = `"source" = "https://example.com"`;
const resultsWithScores = await vectorStore.similaritySearchWithScore(
  "biology",
  2,
  filter
);

for (const [doc, score] of resultsWithScores) {
  console.log(
    `* [SIM=${score.toFixed(3)}] ${doc.pageContent} [${JSON.stringify(doc.metadata)}]`
  );
}

```

### Query by using the max marginal relevance search [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#query-by-using-the-max-marginal-relevance-search "Direct link to Query by using the max marginal relevance search")

The Maximal marginal relevance optimizes for similarity to the query and
diversity among selected documents.

```codeBlockLines_AdAo
const options = {
  k: 4,
  filter: `"source" = 'https://example.com'`,
};

const results = await vectorStoreInstance.maxMarginalRelevanceSearch("biology", options);

for (const doc of results) {
  console.log(`* ${doc.pageContent} [${JSON.stringify(doc.metadata, null)}]`);
}

```

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/google_cloudsql_pg/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#integration-details)
  - [Before you begin](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#before-you-begin)
  - [Authentication](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#authentication)
  - [Set Your Google Cloud Project](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#set-your-google-cloud-project)
- [Setting up a PostgresVectorStore instance](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#setting-up-a-postgresvectorstore-instance)
  - [Setting up an instance](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#setting-up-an-instance)
- [Manage Vector Store](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#manage-vector-store)
  - [Add Documents to vector store](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#add-documents-to-vector-store)
  - [Delete Documents from vector store](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#delete-documents-from-vector-store)
- [Search for documents](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#search-for-documents)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#query-directly)
  - [Query by using the max marginal relevance search](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#query-by-using-the-max-marginal-relevance-search)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/google_cloudsql_pg/#related)