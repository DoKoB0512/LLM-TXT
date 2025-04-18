[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/couchbase/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

# Couchbase

[Couchbase](http://couchbase.com/) is an award-winning distributed NoSQL cloud database that delivers unmatched versatility, performance, scalability, and financial value for all of your cloud, mobile,
AI, and edge computing applications. Couchbase embraces AI with coding assistance for developers and vector search for their applications.

Vector Search is a part of the [Full Text Search Service](https://docs.couchbase.com/server/current/learn/services-and-indexes/services/search-service.html) (Search Service) in Couchbase.

This tutorial explains how to use Vector Search in Couchbase. You can work with both [Couchbase Capella](https://www.couchbase.com/products/capella/) and your self-managed Couchbase Server.

## Installation [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#installation "Direct link to Installation")

You will need couchbase and langchain community to use couchbase vector store. For this tutorial, we will use OpenAI embeddings

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install couchbase @langchain/openai @langchain/community @langchain/core

```

```codeBlockLines_AdAo
yarn add couchbase @langchain/openai @langchain/community @langchain/core

```

```codeBlockLines_AdAo
pnpm add couchbase @langchain/openai @langchain/community @langchain/core

```

## Create Couchbase Connection Object [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#create-couchbase-connection-object "Direct link to Create Couchbase Connection Object")

We create a connection to the Couchbase cluster initially and then pass the cluster object to the Vector Store. Here, we are connecting using the username and password.
You can also connect using any other supported way to your cluster.

For more information on connecting to the Couchbase cluster, please check the [Node SDK documentation](https://docs.couchbase.com/nodejs-sdk/current/hello-world/start-using-sdk.html#connect).

```codeBlockLines_AdAo
import { Cluster } from "couchbase";

const connectionString = "couchbase://localhost"; // or couchbases://localhost if you are using TLS
const dbUsername = "Administrator"; // valid database user with read access to the bucket being queried
const dbPassword = "Password"; // password for the database user

const couchbaseClient = await Cluster.connect(connectionString, {
  username: dbUsername,
  password: dbPassword,
  configProfile: "wanDevelopment",
});

```

## Create the Search Index [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#create-the-search-index "Direct link to Create the Search Index")

Currently, the Search index needs to be created from the Couchbase Capella or Server UI or using the REST interface.

For this example, let us use the Import Index feature on the Search Service on the UI.

Let us define a Search index with the name `vector-index` on the testing bucket.
We are defining an index on the `testing` bucket's `_default` scope on the `_default` collection with the vector field set to `embedding` with 1536 dimensions and the text field set to `text`.
We are also indexing and storing all the fields under `metadata` in the document as a dynamic mapping to account for varying document structures. The similarity metric is set to `dot_product`.

### How to Import an Index to the Full Text Search service? [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#how-to-import-an-index-to-the-full-text-search-service "Direct link to How to Import an Index to the Full Text Search service?")

- [Couchbase Server](https://docs.couchbase.com/server/current/search/import-search-index.html)
  - Click on Search -> Add Index -> Import
  - Copy the following Index definition in the Import screen
  - Click on Create Index to create the index.
- [Couchbase Capella](https://docs.couchbase.com/cloud/search/import-search-index.html)
  - Copy the following index definition to a new file `index.json`
  - Import the file in Capella using the instructions in the documentation.
  - Click on Create Index to create the index.

### Index Definition [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#index-definition "Direct link to Index Definition")

```codeBlockLines_AdAo
{
  "name": "vector-index",
  "type": "fulltext-index",
  "params": {
    "doc_config": {
      "docid_prefix_delim": "",
      "docid_regexp": "",
      "mode": "type_field",
      "type_field": "type"
    },
    "mapping": {
      "default_analyzer": "standard",
      "default_datetime_parser": "dateTimeOptional",
      "default_field": "_all",
      "default_mapping": {
        "dynamic": true,
        "enabled": true,
        "properties": {
          "metadata": {
            "dynamic": true,
            "enabled": true
          },
          "embedding": {
            "enabled": true,
            "dynamic": false,
            "fields": [\
              {\
                "dims": 1536,\
                "index": true,\
                "name": "embedding",\
                "similarity": "dot_product",\
                "type": "vector",\
                "vector_index_optimized_for": "recall"\
              }\
            ]
          },
          "text": {
            "enabled": true,
            "dynamic": false,
            "fields": [\
              {\
                "index": true,\
                "name": "text",\
                "store": true,\
                "type": "text"\
              }\
            ]
          }
        }
      },
      "default_type": "_default",
      "docvalues_dynamic": false,
      "index_dynamic": true,
      "store_dynamic": true,
      "type_field": "_type"
    },
    "store": {
      "indexType": "scorch",
      "segmentVersion": 16
    }
  },
  "sourceType": "gocbcore",
  "sourceName": "testing",
  "sourceParams": {},
  "planParams": {
    "maxPartitionsPerPIndex": 103,
    "indexPartitions": 10,
    "numReplicas": 0
  }
}

```

For more details on how to create a search index with support for Vector fields, please refer to the documentation:

- [Couchbase Capella](https://docs.couchbase.com/cloud/search/create-search-indexes.html)
- [Couchbase Server](https://docs.couchbase.com/server/current/search/create-search-indexes.html)

For using this vector store, CouchbaseVectorStoreArgs needs to be configured.
textKey and embeddingKey are optional fields, required if you want to use specific keys

```codeBlockLines_AdAo
const couchbaseConfig: CouchbaseVectorStoreArgs = {
  cluster: couchbaseClient,
  bucketName: "testing",
  scopeName: "_default",
  collectionName: "_default",
  indexName: "vector-index",
  textKey: "text",
  embeddingKey: "embedding",
};

```

## Create Vector Store [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#create-vector-store "Direct link to Create Vector Store")

We create the vector store object with the cluster information and the search index name.

```codeBlockLines_AdAo
const store = await CouchbaseVectorStore.initialize(
  embeddings, // embeddings object to create embeddings from text
  couchbaseConfig
);

```

## Basic Vector Search Example [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#basic-vector-search-example "Direct link to Basic Vector Search Example")

The following example showcases how to use couchbase vector search and perform similarity search.
For this example, we are going to load the "state\_of\_the\_union.txt" file via the TextLoader,
chunk the text into 500 character chunks with no overlaps and index all these chunks into Couchbase.

After the data is indexed, we perform a simple query to find the top 4 chunks that are similar to the
query "What did president say about Ketanji Brown Jackson".
At the end, it also shows how to get similarity score

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import {
  CouchbaseVectorStoreArgs,
  CouchbaseVectorStore,
} from "@langchain/community/vectorstores/couchbase";
import { Cluster } from "couchbase";
import { TextLoader } from "langchain/document_loaders/fs/text";
import { CharacterTextSplitter } from "@langchain/textsplitters";

const connectionString =
  process.env.COUCHBASE_DB_CONN_STR ?? "couchbase://localhost";
const databaseUsername = process.env.COUCHBASE_DB_USERNAME ?? "Administrator";
const databasePassword = process.env.COUCHBASE_DB_PASSWORD ?? "Password";

// Load documents from file
const loader = new TextLoader("./state_of_the_union.txt");
const rawDocuments = await loader.load();
const splitter = new CharacterTextSplitter({
  chunkSize: 500,
  chunkOverlap: 0,
});
const docs = await splitter.splitDocuments(rawDocuments);

const couchbaseClient = await Cluster.connect(connectionString, {
  username: databaseUsername,
  password: databasePassword,
  configProfile: "wanDevelopment",
});

// Open AI API Key is required to use OpenAIEmbeddings, some other embeddings may also be used
const embeddings = new OpenAIEmbeddings({
  apiKey: process.env.OPENAI_API_KEY,
});

const couchbaseConfig: CouchbaseVectorStoreArgs = {
  cluster: couchbaseClient,
  bucketName: "testing",
  scopeName: "_default",
  collectionName: "_default",
  indexName: "vector-index",
  textKey: "text",
  embeddingKey: "embedding",
};

const store = await CouchbaseVectorStore.fromDocuments(
  docs,
  embeddings,
  couchbaseConfig
);

const query = "What did president say about Ketanji Brown Jackson";

const resultsSimilaritySearch = await store.similaritySearch(query);
console.log("resulting documents: ", resultsSimilaritySearch[0]);

// Similarity Search With Score
const resultsSimilaritySearchWithScore = await store.similaritySearchWithScore(
  query,
  1
);
console.log("resulting documents: ", resultsSimilaritySearchWithScore[0][0]);
console.log("resulting scores: ", resultsSimilaritySearchWithScore[0][1]);

const result = await store.similaritySearch(query, 1, {
  fields: ["metadata.source"],
});
console.log(result[0]);

```

## Specifying Fields to Return [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#specifying-fields-to-return "Direct link to Specifying Fields to Return")

You can specify the fields to return from the document using `fields` parameter in the filter during searches.
These fields are returned as part of the `metadata` object. You can fetch any field that is stored in the index.
The `textKey` of the document is returned as part of the document's `pageContent`.

If you do not specify any fields to be fetched, all the fields stored in the index are returned.

If you want to fetch one of the fields in the metadata, you need to specify it using `.`
For example, to fetch the `source` field in the metadata, you need to use `metadata.source`.

```codeBlockLines_AdAo
const result = await store.similaritySearch(query, 1, {
  fields: ["metadata.source"],
});
console.log(result[0]);

```

## Hybrid Search [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#hybrid-search "Direct link to Hybrid Search")

Couchbase allows you to do hybrid searches by combining vector search results with searches on non-vector fields of the document like the `metadata` object.

The results will be based on the combination of the results from both vector search and the searches supported by full text search service.
The scores of each of the component searches are added up to get the total score of the result.

To perform hybrid searches, there is an optional key, `searchOptions` in `fields` parameter that can be passed to all the similarity searches.

The different search/query possibilities for the `searchOptions` can be found [here](https://docs.couchbase.com/server/current/search/search-request-params.html#query-object).

### Create Diverse Metadata for Hybrid Search [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#create-diverse-metadata-for-hybrid-search "Direct link to Create Diverse Metadata for Hybrid Search")

In order to simulate hybrid search, let us create some random metadata from the existing documents.
We uniformly add three fields to the metadata, `date` between 2010 & 2020, `rating` between 1 & 5 and `author` set to either John Doe or Jane Doe.
We will also declare few sample queries.

```codeBlockLines_AdAo
for (let i = 0; i < docs.length; i += 1) {
  docs[i].metadata.date = `${2010 + (i % 10)}-01-01`;
  docs[i].metadata.rating = 1 + (i % 5);
  docs[i].metadata.author = ["John Doe", "Jane Doe"][i % 2];
}

const store = await CouchbaseVectorStore.fromDocuments(
  docs,
  embeddings,
  couchbaseConfig
);

const query = "What did the president say about Ketanji Brown Jackson";
const independenceQuery = "Any mention about independence?";

```

### Example: Search by Exact Value [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#example-search-by-exact-value "Direct link to Example: Search by Exact Value")

We can search for exact matches on a textual field like the author in the `metadata` object.

```codeBlockLines_AdAo
const exactValueResult = await store.similaritySearch(query, 4, {
  fields: ["metadata.author"],
  searchOptions: {
    query: { field: "metadata.author", match: "John Doe" },
  },
});
console.log(exactValueResult[0]);

```

### Example: Search by Partial Match [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#example-search-by-partial-match "Direct link to Example: Search by Partial Match")

We can search for partial matches by specifying a fuzziness for the search. This is useful when you want to search for slight variations or misspellings of a search query.

Here, "Johny" is close (fuzziness of 1) to "John Doe".

```codeBlockLines_AdAo
const partialMatchResult = await store.similaritySearch(query, 4, {
  fields: ["metadata.author"],
  searchOptions: {
    query: { field: "metadata.author", match: "Johny", fuzziness: 1 },
  },
});
console.log(partialMatchResult[0]);

```

### Example: Search by Date Range Query [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#example-search-by-date-range-query "Direct link to Example: Search by Date Range Query")

We can search for documents that are within a date range query on a date field like `metadata.date`.

```codeBlockLines_AdAo
const dateRangeResult = await store.similaritySearch(independenceQuery, 4, {
  fields: ["metadata.date", "metadata.author"],
  searchOptions: {
    query: {
      start: "2016-12-31",
      end: "2017-01-02",
      inclusiveStart: true,
      inclusiveEnd: false,
      field: "metadata.date",
    },
  },
});
console.log(dateRangeResult[0]);

```

### Example: Search by Numeric Range Query [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#example-search-by-numeric-range-query "Direct link to Example: Search by Numeric Range Query")

We can search for documents that are within a range for a numeric field like `metadata.rating`.

```codeBlockLines_AdAo
const ratingRangeResult = await store.similaritySearch(independenceQuery, 4, {
  fields: ["metadata.rating"],
  searchOptions: {
    query: {
      min: 3,
      max: 5,
      inclusiveMin: false,
      inclusiveMax: true,
      field: "metadata.rating",
    },
  },
});
console.log(ratingRangeResult[0]);

```

### Example: Combining Multiple Search Conditions [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#example-combining-multiple-search-conditions "Direct link to Example: Combining Multiple Search Conditions")

Different queries can by combined using AND (conjuncts) or OR (disjuncts) operators.

In this example, we are checking for documents with a rating between 3 & 4 and dated between 2015 & 2018.

```codeBlockLines_AdAo
const multipleConditionsResult = await store.similaritySearch(texts[0], 4, {
  fields: ["metadata.rating", "metadata.date"],
  searchOptions: {
    query: {
      conjuncts: [\
        { min: 3, max: 4, inclusive_max: true, field: "metadata.rating" },\
        { start: "2016-12-31", end: "2017-01-02", field: "metadata.date" },\
      ],
    },
  },
});
console.log(multipleConditionsResult[0]);

```

### Other Queries [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#other-queries "Direct link to Other Queries")

Similarly, you can use any of the supported Query methods like Geo Distance, Polygon Search, Wildcard, Regular Expressions, etc in the `searchOptions` Key of `filter` parameter.
Please refer to the documentation for more details on the available query methods and their syntax.

- [Couchbase Capella](https://docs.couchbase.com/cloud/search/search-request-params.html#query-object)
- [Couchbase Server](https://docs.couchbase.com/server/current/search/search-request-params.html#query-object)

# Frequently Asked Questions

## Question: Should I create the Search index before creating the CouchbaseVectorStore object? [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#question-should-i-create-the-search-index-before-creating-the-couchbasevectorstore-object "Direct link to Question: Should I create the Search index before creating the CouchbaseVectorStore object?")

Yes, currently you need to create the Search index before creating the `CouchbaseVectorStore` object.

## Question: I am not seeing all the fields that I specified in my search results. [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#question-i-am-not-seeing-all-the-fields-that-i-specified-in-my-search-results "Direct link to Question: I am not seeing all the fields that I specified in my search results.")

In Couchbase, we can only return the fields stored in the Search index. Please ensure that the field that you are trying to access in the search results is part of the Search index.

One way to handle this is to index and store a document's fields dynamically in the index.

- In Capella, you need to go to "Advanced Mode" then under the chevron "General Settings" you can check "\[X\] Store Dynamic Fields" or "\[X\] Index Dynamic Fields"
- In Couchbase Server, in the Index Editor (not Quick Editor) under the chevron "Advanced" you can check "\[X\] Store Dynamic Fields" or "\[X\] Index Dynamic Fields"

Note that these options will increase the size of the index.

For more details on dynamic mappings, please refer to the [documentation](https://docs.couchbase.com/cloud/search/customize-index.html).

## Question: I am unable to see the metadata object in my search results. [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#question-i-am-unable-to-see-the-metadata-object-in-my-search-results "Direct link to Question: I am unable to see the metadata object in my search results.")

This is most likely due to the `metadata` field in the document not being indexed and/or stored by the Couchbase Search index. In order to index the `metadata` field in the document, you need to add it to the index as a child mapping.

If you select to map all the fields in the mapping, you will be able to search by all metadata fields. Alternatively, to optimize the index, you can select the specific fields inside `metadata` object to be indexed.
You can refer to the [docs](https://docs.couchbase.com/cloud/search/customize-index.html) to learn more about indexing child mappings.

To create Child Mappings, you can refer to the following docs -

- [Couchbase Capella](https://docs.couchbase.com/cloud/search/create-child-mapping.html)
- [Couchbase Server](https://docs.couchbase.com/server/current/fts/fts-creating-index-from-UI-classic-editor-dynamic.html)

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/couchbase/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/couchbase/%3E).