[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/cassandra/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Cassandra

Compatibility

Only available on Node.js.

[Apache Cassandra®](https://cassandra.apache.org/_/index.html) is a NoSQL, row-oriented, highly scalable and highly available database.

The [latest version](https://cwiki.apache.org/confluence/display/CASSANDRA/CEP-30%3A+Approximate+Nearest+Neighbor(ANN)+Vector+Search+via+Storage-Attached+Indexes) of Apache Cassandra natively supports Vector Similarity Search.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/cassandra/\#setup "Direct link to Setup")

First, install the Cassandra Node.js driver:

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install cassandra-driver @langchain/community @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
yarn add cassandra-driver @langchain/community @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
pnpm add cassandra-driver @langchain/community @langchain/openai @langchain/core

```

Depending on your database providers, the specifics of how to connect to the database will vary. We will create a document `configConnection` which will be used as part of the vector store configuration.

### Apache Cassandra® [​](https://js.langchain.com/docs/integrations/vectorstores/cassandra/\#apache-cassandra "Direct link to Apache Cassandra®")

Vector search is supported in [Apache Cassandra® 5.0](https://cassandra.apache.org/_/Apache-Cassandra-5.0-Moving-Toward-an-AI-Driven-Future.html) and above. You can use a standard connection document, for example:

```codeBlockLines_AdAo
const configConnection = {
  contactPoints: ['h1', 'h2'],
  localDataCenter: 'datacenter1',
  credentials: {
    username: <...> as string,
    password: <...> as string,
  },
};

```

### Astra DB [​](https://js.langchain.com/docs/integrations/vectorstores/cassandra/\#astra-db "Direct link to Astra DB")

Astra DB is a cloud-native Cassandra-as-a-Service platform.

1. Create an [Astra DB account](https://astra.datastax.com/register).
2. Create a [vector enabled database](https://astra.datastax.com/createDatabase).
3. Create a [token](https://docs.datastax.com/en/astra/docs/manage-application-tokens.html) for your database.

```codeBlockLines_AdAo
const configConnection = {
  serviceProviderArgs: {
    astra: {
      token: <...> as string,
      endpoint: <...> as string,
    },
  },
};

```

Instead of `endpoint:`, you many provide property `datacenterID:` and optionally `regionName:`.

## Indexing docs [​](https://js.langchain.com/docs/integrations/vectorstores/cassandra/\#indexing-docs "Direct link to Indexing docs")

```codeBlockLines_AdAo
import { CassandraStore } from "langchain/vectorstores/cassandra";
import { OpenAIEmbeddings } from "@langchain/openai";

// The configConnection document is defined above
const config = {
  ...configConnection,
  keyspace: "test",
  dimensions: 1536,
  table: "test",
  indices: [{ name: "name", value: "(name)" }],
  primaryKey: {
    name: "id",
    type: "int",
  },
  metadataColumns: [\
    {\
      name: "name",\
      type: "text",\
    },\
  ],
};

const vectorStore = await CassandraStore.fromTexts(
  ["I am blue", "Green yellow purple", "Hello there hello"],
  [\
    { id: 2, name: "2" },\
    { id: 1, name: "1" },\
    { id: 3, name: "3" },\
  ],
  new OpenAIEmbeddings(),
  cassandraConfig
);

```

## Querying docs [​](https://js.langchain.com/docs/integrations/vectorstores/cassandra/\#querying-docs "Direct link to Querying docs")

```codeBlockLines_AdAo
const results = await vectorStore.similaritySearch("Green yellow purple", 1);

```

or filtered query:

```codeBlockLines_AdAo
const results = await vectorStore.similaritySearch("B", 1, { name: "Bubba" });

```

## Vector Types [​](https://js.langchain.com/docs/integrations/vectorstores/cassandra/\#vector-types "Direct link to Vector Types")

Cassandra supports `cosine` (the default), `dot_product`, and `euclidean` similarity search; this is defined when the
vector store is first created, and specifed in the constructor parameter `vectorType`, for example:

```codeBlockLines_AdAo
  ...,
  vectorType: "dot_product",
  ...

```

## Indices [​](https://js.langchain.com/docs/integrations/vectorstores/cassandra/\#indices "Direct link to Indices")

With Version 5, Cassandra introduced Storage Attached Indexes, or SAIs. These allow `WHERE` filtering without specifying
the partition key, and allow for additional operator types such as non-equalities. You can define these with the `indices`
parameter, which accepts zero or more dictionaries each containing `name` and `value` entries.

Indices are optional, though required if using filtered queries on non-partition columns.

- The `name` entry is part of the object name; on a table named `test_table` an index with `name: "some_column"`
would be `idx_test_table_some_column`.
- The `value` entry is the column on which the index is created, surrounded by `(` and `)`. With the above column
`some_column` it would be specified as `value: "(some_column)"`.
- An optional `options` entry is a map passed to the `WITH OPTIONS =` clause of the `CREATE CUSTOM INDEX` statement.
The specific entries on this map are index type specific.

```codeBlockLines_AdAo
  indices: [{ name: "some_column", value: "(some_column)" }],

```

## Advanced Filtering [​](https://js.langchain.com/docs/integrations/vectorstores/cassandra/\#advanced-filtering "Direct link to Advanced Filtering")

By default, filters are applied with an equality `=`. For those fields that have an `indices` entry, you may
provide an `operator` with a string of a value supported by the index; in this case, you specify one or
more filters, as either a singleton or in a list (which will be `AND`-ed together). For example:

```codeBlockLines_AdAo
   { name: "create_datetime", operator: ">", value: some_datetime_variable }

```

or

```codeBlockLines_AdAo
[\
  { userid: userid_variable },\
  { name: "create_datetime", operator: ">", value: some_date_variable },\
];

```

`value` can be a single value or an array. If it is not an array, or there is only one element in `value`,
the resulting query will be along the lines of `${name} ${operator} ?` with `value` bound to the `?`.

If there is more than one element in the `value` array, the number of unquoted `?` in `name` are counted
and subtracted from the length of `value`, and this number of `?` is put on the right side of the operator;
if there are more than one `?` then they will be encapsulated in `(` and `)`, e.g. `(?, ?, ?)`.

This faciliates bind values on the left of the operator, which is useful for some functions; for example
a geo-distance filter:

```codeBlockLines_AdAo
{
  name: "GEO_DISTANCE(coord, ?)",
  operator: "<",
  value: [new Float32Array([53.3730617,-6.3000515]), 10000],
},

```

## Data Partitioning and Composite Keys [​](https://js.langchain.com/docs/integrations/vectorstores/cassandra/\#data-partitioning-and-composite-keys "Direct link to Data Partitioning and Composite Keys")

In some systems, you may wish to partition the data for various reasons, perhaps by user or by session. Data in Cassandra
is always partitioned; by default this library will partition by the first primary key field. You may specify multiple
columns which comprise the primary (unique) key of a record, and optionally indicate those fields which should be
part of the partition key. For example, the vector store could be partitioned by both `userid` and `collectionid`, with
additional fields `docid` and `docpart` making an individual entry unique:

```codeBlockLines_AdAo
  ...,
  primaryKey: [\
    {name: "userid", type: "text", partition: true},\
    {name: "collectionid", type: "text", partition: true},\
    {name: "docid", type: "text"},\
    {name: "docpart", type: "int"},\
  ],
  ...

```

When searching, you may include partition keys on the filter without defining `indices` for these columns; you do
not need to specify all partition keys, but must specify those in the key first. In the above example, you could
specify a filter of `{userid: userid_variable}` and `{userid: userid_variable, collectionid: collectionid_variable}`,
but if you wanted to specify a filter of only `{collectionid: collectionid_variable}` you would have to include
`collectionid` on the `indices` list.

## Additional Configuration Options [​](https://js.langchain.com/docs/integrations/vectorstores/cassandra/\#additional-configuration-options "Direct link to Additional Configuration Options")

In the configuration document, further optional parameters are provided; their defaults are:

```codeBlockLines_AdAo
  ...,
  maxConcurrency: 25,
  batchSize: 1,
  withClause: "",
  ...

```

| Parameter | Usage |
| --- | --- |
| `maxConcurrency` | How many concurrent requests will be sent to Cassandra at a given time. |
| `batchSize` | How many documents will be sent on a single request to Cassandra. When using a value > 1, you should ensure your batch size will not exceed the Cassandra parameter `batch_size_fail_threshold_in_kb`. Batches are unlogged. |
| `withClause` | Cassandra tables may be created with an optional `WITH` clause; this is generally not needed but provided for completeness. |

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/cassandra/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/cassandra/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/cassandra/#setup)
  - [Apache Cassandra®](https://js.langchain.com/docs/integrations/vectorstores/cassandra/#apache-cassandra)
  - [Astra DB](https://js.langchain.com/docs/integrations/vectorstores/cassandra/#astra-db)
- [Indexing docs](https://js.langchain.com/docs/integrations/vectorstores/cassandra/#indexing-docs)
- [Querying docs](https://js.langchain.com/docs/integrations/vectorstores/cassandra/#querying-docs)
- [Vector Types](https://js.langchain.com/docs/integrations/vectorstores/cassandra/#vector-types)
- [Indices](https://js.langchain.com/docs/integrations/vectorstores/cassandra/#indices)
- [Advanced Filtering](https://js.langchain.com/docs/integrations/vectorstores/cassandra/#advanced-filtering)
- [Data Partitioning and Composite Keys](https://js.langchain.com/docs/integrations/vectorstores/cassandra/#data-partitioning-and-composite-keys)
- [Additional Configuration Options](https://js.langchain.com/docs/integrations/vectorstores/cassandra/#additional-configuration-options)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/cassandra/#related)