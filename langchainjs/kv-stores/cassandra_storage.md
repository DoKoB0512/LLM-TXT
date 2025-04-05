[Skip to main content](https://js.langchain.com/docs/integrations/stores/cassandra_storage/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Cassandra KV

This example demonstrates how to setup chat history storage using the `CassandraKVStore` `BaseStore` integration. Note there is a `CassandraChatMessageHistory`
integration which may be easier to use for chat history storage; the `CassandraKVStore` is useful if you want a more general-purpose key-value store with
prefixable keys.

## Setup [​](https://js.langchain.com/docs/integrations/stores/cassandra_storage/\#setup "Direct link to Setup")

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @langchain/community @langchain/core cassandra-driver

```

```codeBlockLines_AdAo
yarn add @langchain/community @langchain/core cassandra-driver

```

```codeBlockLines_AdAo
pnpm add @langchain/community @langchain/core cassandra-driver

```

Depending on your database providers, the specifics of how to connect to the database will vary. We will create a document `configConnection` which will be used as part of the store configuration.

### Apache Cassandra® [​](https://js.langchain.com/docs/integrations/stores/cassandra_storage/\#apache-cassandra "Direct link to Apache Cassandra®")

Storage Attached Indexes (used by `yieldKeys`) are supported in [Apache Cassandra® 5.0](https://cassandra.apache.org/_/blog/Apache-Cassandra-5.0-Features-Storage-Attached-Indexes.html) and above. You can use a standard connection document, for example:

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

### Astra DB [​](https://js.langchain.com/docs/integrations/stores/cassandra_storage/\#astra-db "Direct link to Astra DB")

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

## Usage [​](https://js.langchain.com/docs/integrations/stores/cassandra_storage/\#usage "Direct link to Usage")

```codeBlockLines_AdAo
import { CassandraKVStore } from "@langchain/community/storage/cassandra";
import { AIMessage, HumanMessage } from "@langchain/core/messages";

// This document is the Cassandra driver connection document; the example is to AstraDB but
// any valid Cassandra connection can be used.
const configConnection = {
  serviceProviderArgs: {
    astra: {
      token: "YOUR_TOKEN_OR_LOAD_FROM_ENV" as string,
      endpoint: "YOUR_ENDPOINT_OR_LOAD_FROM_ENV" as string,
    },
  },
};

const store = new CassandraKVStore({
  ...configConnection,
  keyspace: "test", // keyspace must exist
  table: "test_kv", // table will be created if it does not exist
  keyDelimiter: ":", // optional, default is "/"
});

// Define our encoder/decoder for converting between strings and Uint8Arrays
const encoder = new TextEncoder();
const decoder = new TextDecoder();

/**
 * Here you would define your LLM and chat chain, call
 * the LLM and eventually get a list of messages.
 * For this example, we'll assume we already have a list.
 */
const messages = Array.from({ length: 5 }).map((_, index) => {
  if (index % 2 === 0) {
    return new AIMessage("ai stuff...");
  }
  return new HumanMessage("human stuff...");
});

// Set your messages in the store
// The key will be prefixed with `message:id:` and end
// with the index.
await store.mset(
  messages.map((message, index) => [\
    `message:id:${index}`,\
    encoder.encode(JSON.stringify(message)),\
  ])
);

// Now you can get your messages from the store
const retrievedMessages = await store.mget(["message:id:0", "message:id:1"]);
// Make sure to decode the values
console.log(retrievedMessages.map((v) => decoder.decode(v)));

/**
[\
  '{"id":["langchain","AIMessage"],"kwargs":{"content":"ai stuff..."}}',\
  '{"id":["langchain","HumanMessage"],"kwargs":{"content":"human stuff..."}}'\
]
 */

// Or, if you want to get back all the keys you can call
// the `yieldKeys` method.
// Optionally, you can pass a key prefix to only get back
// keys which match that prefix.
const yieldedKeys = [];
for await (const key of store.yieldKeys("message:id:")) {
  yieldedKeys.push(key);
}

// The keys are not encoded, so no decoding is necessary
console.log(yieldedKeys);
/**
[\
  'message:id:2',\
  'message:id:1',\
  'message:id:3',\
  'message:id:0',\
  'message:id:4'\
]
 */

// Finally, let's delete the keys from the store
await store.mdelete(yieldedKeys);

```

#### API Reference:

- CassandraKVStorefrom `@langchain/community/storage/cassandra`
- AIMessagefrom `@langchain/core/messages`
- HumanMessagefrom `@langchain/core/messages`

## Related [​](https://js.langchain.com/docs/integrations/stores/cassandra_storage/\#related "Direct link to Related")

- [Key-value store conceptual guide](https://js.langchain.com/docs/concepts/key_value_stores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/stores/cassandra_storage/%3E).

- [Setup](https://js.langchain.com/docs/integrations/stores/cassandra_storage/#setup)
  - [Apache Cassandra®](https://js.langchain.com/docs/integrations/stores/cassandra_storage/#apache-cassandra)
  - [Astra DB](https://js.langchain.com/docs/integrations/stores/cassandra_storage/#astra-db)
- [Usage](https://js.langchain.com/docs/integrations/stores/cassandra_storage/#usage)
- [Related](https://js.langchain.com/docs/integrations/stores/cassandra_storage/#related)