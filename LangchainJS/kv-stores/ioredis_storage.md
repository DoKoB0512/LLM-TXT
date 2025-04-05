[Skip to main content](https://js.langchain.com/docs/integrations/stores/ioredis_storage/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# IORedis

This example demonstrates how to setup chat history storage using the `RedisByteStore` `BaseStore` integration.

## Setup [​](https://js.langchain.com/docs/integrations/stores/ioredis_storage/\#setup "Direct link to Setup")

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @langchain/community @langchain/core ioredis

```

```codeBlockLines_AdAo
yarn add @langchain/community @langchain/core ioredis

```

```codeBlockLines_AdAo
pnpm add @langchain/community @langchain/core ioredis

```

## Usage [​](https://js.langchain.com/docs/integrations/stores/ioredis_storage/\#usage "Direct link to Usage")

```codeBlockLines_AdAo
import { Redis } from "ioredis";
import { RedisByteStore } from "@langchain/community/storage/ioredis";
import { AIMessage, HumanMessage } from "@langchain/core/messages";

// Define the client and store
const client = new Redis({});
const store = new RedisByteStore({
  client,
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
// and close the Redis connection.
await store.mdelete(yieldedKeys);
client.disconnect();

```

#### API Reference:

- RedisByteStorefrom `@langchain/community/storage/ioredis`
- AIMessagefrom `@langchain/core/messages`
- HumanMessagefrom `@langchain/core/messages`

## Related [​](https://js.langchain.com/docs/integrations/stores/ioredis_storage/\#related "Direct link to Related")

- [Key-value store conceptual guide](https://js.langchain.com/docs/concepts/key_value_stores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/stores/ioredis_storage/%3E).

- [Setup](https://js.langchain.com/docs/integrations/stores/ioredis_storage/#setup)
- [Usage](https://js.langchain.com/docs/integrations/stores/ioredis_storage/#usage)
- [Related](https://js.langchain.com/docs/integrations/stores/ioredis_storage/#related)