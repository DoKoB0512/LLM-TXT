[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Neo4j Vector Index

Neo4j is an open-source graph database with integrated support for vector similarity search.
It supports:

- approximate nearest neighbor search
- Euclidean similarity and cosine similarity
- Hybrid search combining vector and keyword searches

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/\#setup "Direct link to Setup")

To work with Neo4j Vector Index, you need to install the `neo4j-driver` package:

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install neo4j-driver

```

```codeBlockLines_AdAo
yarn add neo4j-driver

```

```codeBlockLines_AdAo
pnpm add neo4j-driver

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

### Setup a `Neo4j` self hosted instance with `docker-compose` [​](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/\#setup-a-neo4j-self-hosted-instance-with-docker-compose "Direct link to setup-a-neo4j-self-hosted-instance-with-docker-compose")

`Neo4j` provides a prebuilt Docker image that can be used to quickly setup a self-hosted Neo4j database instance.
Create a file below named `docker-compose.yml`:

```codeBlockLines_AdAo
export default {services:{database:{image:'neo4j',ports:['7687:7687','7474:7474'],environment:['NEO4J_AUTH=neo4j/pleaseletmein']}}};

```

#### API Reference:

And then in the same directory, run `docker compose up` to start the container.

You can find more information on how to setup `Neo4j` on their [website](https://neo4j.com/docs/operations-manual/current/installation/).

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/\#usage "Direct link to Usage")

One complete example of using `Neo4jVectorStore` is the following:

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import { Neo4jVectorStore } from "@langchain/community/vectorstores/neo4j_vector";

// Configuration object for Neo4j connection and other related settings
const config = {
  url: "bolt://localhost:7687", // URL for the Neo4j instance
  username: "neo4j", // Username for Neo4j authentication
  password: "pleaseletmein", // Password for Neo4j authentication
  indexName: "vector", // Name of the vector index
  keywordIndexName: "keyword", // Name of the keyword index if using hybrid search
  searchType: "vector" as const, // Type of search (e.g., vector, hybrid)
  nodeLabel: "Chunk", // Label for the nodes in the graph
  textNodeProperty: "text", // Property of the node containing text
  embeddingNodeProperty: "embedding", // Property of the node containing embedding
};

const documents = [\
  { pageContent: "what's this", metadata: { a: 2 } },\
  { pageContent: "Cat drinks milk", metadata: { a: 1 } },\
];

const neo4jVectorIndex = await Neo4jVectorStore.fromDocuments(
  documents,
  new OpenAIEmbeddings(),
  config
);

const results = await neo4jVectorIndex.similaritySearch("water", 1);

console.log(results);

/*
  [ Document { pageContent: 'Cat drinks milk', metadata: { a: 1 } } ]
*/

await neo4jVectorIndex.close();

```

#### API Reference:

- OpenAIEmbeddingsfrom `@langchain/openai`
- Neo4jVectorStorefrom `@langchain/community/vectorstores/neo4j_vector`

### Use retrievalQuery parameter to customize responses [​](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/\#use-retrievalquery-parameter-to-customize-responses "Direct link to Use retrievalQuery parameter to customize responses")

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import { Neo4jVectorStore } from "@langchain/community/vectorstores/neo4j_vector";

/*
 * The retrievalQuery is a customizable Cypher query fragment used in the Neo4jVectorStore class to define how
 * search results should be retrieved and presented from the Neo4j database. It allows developers to specify
 * the format and structure of the data returned after a similarity search.
 * Mandatory columns for `retrievalQuery`:
 *
 * 1. text:
 *    - Description: Represents the textual content of the node.
 *    - Type: String
 *
 * 2. score:
 *    - Description: Represents the similarity score of the node in relation to the search query. A
 *      higher score indicates a closer match.
 *    - Type: Float (ranging between 0 and 1, where 1 is a perfect match)
 *
 * 3. metadata:
 *    - Description: Contains additional properties and information about the node. This can include
 *      any other attributes of the node that might be relevant to the application.
 *    - Type: Object (key-value pairs)
 *    - Example: { "id": "12345", "category": "Books", "author": "John Doe" }
 *
 * Note: While you can customize the `retrievalQuery` to fetch additional columns or perform
 * transformations, never omit the mandatory columns. The names of these columns (`text`, `score`,
 * and `metadata`) should remain consistent. Renaming them might lead to errors or unexpected behavior.
 */

// Configuration object for Neo4j connection and other related settings
const config = {
  url: "bolt://localhost:7687", // URL for the Neo4j instance
  username: "neo4j", // Username for Neo4j authentication
  password: "pleaseletmein", // Password for Neo4j authentication
  retrievalQuery: `
    RETURN node.text AS text, score, {a: node.a * 2} AS metadata
  `,
};

const documents = [\
  { pageContent: "what's this", metadata: { a: 2 } },\
  { pageContent: "Cat drinks milk", metadata: { a: 1 } },\
];

const neo4jVectorIndex = await Neo4jVectorStore.fromDocuments(
  documents,
  new OpenAIEmbeddings(),
  config
);

const results = await neo4jVectorIndex.similaritySearch("water", 1);

console.log(results);

/*
  [ Document { pageContent: 'Cat drinks milk', metadata: { a: 2 } } ]
*/

await neo4jVectorIndex.close();

```

#### API Reference:

- OpenAIEmbeddingsfrom `@langchain/openai`
- Neo4jVectorStorefrom `@langchain/community/vectorstores/neo4j_vector`

### Instantiate Neo4jVectorStore from existing graph [​](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/\#instantiate-neo4jvectorstore-from-existing-graph "Direct link to Instantiate Neo4jVectorStore from existing graph")

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import { Neo4jVectorStore } from "@langchain/community/vectorstores/neo4j_vector";

/**
 * `fromExistingGraph` Method:
 *
 * Description:
 * This method initializes a `Neo4jVectorStore` instance using an existing graph in the Neo4j database.
 * It's designed to work with nodes that already have textual properties but might not have embeddings.
 * The method will compute and store embeddings for nodes that lack them.
 *
 * Note:
 * This method is particularly useful when you have a pre-existing graph with textual data and you want
 * to enhance it with vector embeddings for similarity searches without altering the original data structure.
 */

// Configuration object for Neo4j connection and other related settings
const config = {
  url: "bolt://localhost:7687", // URL for the Neo4j instance
  username: "neo4j", // Username for Neo4j authentication
  password: "pleaseletmein", // Password for Neo4j authentication
  indexName: "wikipedia",
  nodeLabel: "Wikipedia",
  textNodeProperties: ["title", "description"],
  embeddingNodeProperty: "embedding",
  searchType: "hybrid" as const,
};

// You should have a populated Neo4j database to use this method
const neo4jVectorIndex = await Neo4jVectorStore.fromExistingGraph(
  new OpenAIEmbeddings(),
  config
);

await neo4jVectorIndex.close();

```

#### API Reference:

- OpenAIEmbeddingsfrom `@langchain/openai`
- Neo4jVectorStorefrom `@langchain/community/vectorstores/neo4j_vector`

### Metadata filtering [​](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/\#metadata-filtering "Direct link to Metadata filtering")

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import { Neo4jVectorStore } from "@langchain/community/vectorstores/neo4j_vector";

/**
 * `similaritySearch` Method with Metadata Filtering:
 *
 * Description:
 * This method facilitates advanced similarity searches within a Neo4j vector index, leveraging both text embeddings and metadata attributes.
 * The third parameter, `filter`, allows for the specification of metadata-based conditions that pre-filter the nodes before performing the similarity search.
 * This approach enhances the search precision by allowing users to query based on complex metadata criteria alongside textual similarity.
 * Metadata filtering also support the following operators:
 *
 *  $eq: Equal
 *  $ne: Not Equal
 *  $lt: Less than
 *  $lte: Less than or equal
 *  $gt: Greater than
 *  $gte: Greater than or equal
 *  $in: In a list of values
 *  $nin: Not in a list of values
 *  $between: Between two values
 *  $like: Text contains value
 *  $ilike: lowered text contains value
 *
 * The filter supports a range of query operations such as equality checks, range queries, and compound conditions (using logical operators like $and, $or).
 * This makes it highly adaptable to varied use cases requiring detailed and specific retrieval of documents based on both content and contextual information.
 *
 * Note:
 * Effective use of this method requires a well-structured Neo4j database where nodes are enriched with both text and metadata properties.
 * The method is particularly useful in scenarios where the integration of text analysis with detailed metadata querying is crucial, such as in content recommendation systems, detailed archival searches, or any application where contextual relevance is key.
 */

// Configuration object for Neo4j connection and other related settings
const config = {
  url: "bolt://localhost:7687", // URL for the Neo4j instance
  username: "neo4j", // Username for Neo4j authentication
  password: "pleaseletmein", // Password for Neo4j authentication
  indexName: "vector", // Name of the vector index
  keywordIndexName: "keyword", // Name of the keyword index if using hybrid search
  searchType: "vector" as const, // Type of search (e.g., vector, hybrid)
  nodeLabel: "Chunk", // Label for the nodes in the graph
  textNodeProperty: "text", // Property of the node containing text
  embeddingNodeProperty: "embedding", // Property of the node containing embedding
};

const documents = [\
  { pageContent: "what's this", metadata: { a: 2 } },\
  { pageContent: "Cat drinks milk", metadata: { a: 1 } },\
];

const neo4jVectorIndex = await Neo4jVectorStore.fromDocuments(
  documents,
  new OpenAIEmbeddings(),
  config
);

const filter = { a: { $eq: 1 } };
const results = await neo4jVectorIndex.similaritySearch("water", 1, { filter });

console.log(results);

/*
  [ Document { pageContent: 'Cat drinks milk', metadata: { a: 1 } } ]
*/

await neo4jVectorIndex.close();

```

#### API Reference:

- OpenAIEmbeddingsfrom `@langchain/openai`
- Neo4jVectorStorefrom `@langchain/community/vectorstores/neo4j_vector`

# Disclaimer ⚠️

_Security note_: Make sure that the database connection uses credentials
that are narrowly-scoped to only include necessary permissions.
Failure to do so may result in data corruption or loss, since the calling
code may attempt commands that would result in deletion, mutation
of data if appropriately prompted or reading sensitive data if such
data is present in the database.
The best way to guard against such negative outcomes is to (as appropriate)
limit the permissions granted to the credentials used with this tool.
For example, creating read only users for the database is a good way to
ensure that the calling code cannot mutate or delete data.
See the [security page](https://js.langchain.com/docs/security) for more information.

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/neo4jvector/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/#setup)
  - [Setup a `Neo4j` self hosted instance with `docker-compose`](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/#setup-a-neo4j-self-hosted-instance-with-docker-compose)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/#usage)
  - [Use retrievalQuery parameter to customize responses](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/#use-retrievalquery-parameter-to-customize-responses)
  - [Instantiate Neo4jVectorStore from existing graph](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/#instantiate-neo4jvectorstore-from-existing-graph)
  - [Metadata filtering](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/#metadata-filtering)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/neo4jvector/#related)