[Skip to main content](https://js.langchain.com/docs/integrations/stores/in_memory/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

This will help you get started with
[InMemoryStore](https://js.langchain.com/docs/concepts/key_value_stores). For detailed
documentation of all InMemoryStore features and configurations head to
the [API\\
reference](https://api.js.langchain.com/classes/langchain_core.stores.InMemoryStore.html).

The `InMemoryStore` allows for a generic type to be assigned to the
values in the store. We’ll assign type `BaseMessage` as the type of our
values, keeping with the theme of a chat history store.

## Overview [​](https://js.langchain.com/docs/integrations/stores/in_memory/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/stores/in_memory/\#integration-details "Direct link to Integration details")

| Class | Package | Local | [PY support](https://python.langchain.com/docs/integrations/stores/in_memory/) | Package downloads | Package latest |
| :-- | :-- | :-: | :-: | :-: | :-: |
| [InMemoryStore](https://api.js.langchain.com/classes/langchain_core.stores.InMemoryStore.html) | [@langchain/core](https://api.js.langchain.com/modules/langchain_core.stores.html) | ✅ | ✅ | ![NPM - Downloads](https://img.shields.io/npm/dm/@langchain/core?style=flat-square&label=%20&.png) | ![NPM - Version](https://img.shields.io/npm/v/@langchain/core?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/stores/in_memory/\#setup "Direct link to Setup")

### Installation [​](https://js.langchain.com/docs/integrations/stores/in_memory/\#installation "Direct link to Installation")

The LangChain InMemoryStore integration lives in the `@langchain/core`
package:

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/core

```

## Instantiation [​](https://js.langchain.com/docs/integrations/stores/in_memory/\#instantiation "Direct link to Instantiation")

Now we can instantiate our byte store:

```codeBlockLines_AdAo
import { InMemoryStore } from "@langchain/core/stores";
import { BaseMessage } from "@langchain/core/messages";

const kvStore = new InMemoryStore<BaseMessage>();

```

## Usage [​](https://js.langchain.com/docs/integrations/stores/in_memory/\#usage "Direct link to Usage")

You can set data under keys like this using the `mset` method:

```codeBlockLines_AdAo
import { AIMessage, HumanMessage } from "@langchain/core/messages";

await kvStore.mset([\
  ["key1", new HumanMessage("value1")],\
  ["key2", new AIMessage("value2")],\
]);

await kvStore.mget(["key1", "key2"]);

```

```codeBlockLines_AdAo
[\
  HumanMessage {\
    "content": "value1",\
    "additional_kwargs": {},\
    "response_metadata": {}\
  },\
  AIMessage {\
    "content": "value2",\
    "additional_kwargs": {},\
    "response_metadata": {},\
    "tool_calls": [],\
    "invalid_tool_calls": []\
  }\
]

```

And you can delete data using the `mdelete` method:

```codeBlockLines_AdAo
await kvStore.mdelete(["key1", "key2"]);

await kvStore.mget(["key1", "key2"]);

```

```codeBlockLines_AdAo
[ undefined, undefined ]

```

## Yielding values [​](https://js.langchain.com/docs/integrations/stores/in_memory/\#yielding-values "Direct link to Yielding values")

If you want to get back all the keys you can call the `yieldKeys`
method. Optionally, you can pass a key prefix to only get back keys
which match that prefix.

```codeBlockLines_AdAo
import { InMemoryStore } from "@langchain/core/stores";
import { AIMessage, BaseMessage, HumanMessage } from "@langchain/core/messages";

const kvStoreForYield = new InMemoryStore<BaseMessage>();

// Add some data to the store
await kvStoreForYield.mset([\
  ["message:id:key1", new HumanMessage("value1")],\
  ["message:id:key2", new AIMessage("value2")],\
]);

const yieldedKeys = [];
for await (const key of kvStoreForYield.yieldKeys("message:id:")) {
  yieldedKeys.push(key);
}

console.log(yieldedKeys);

```

```codeBlockLines_AdAo
[ 'message:id:key1', 'message:id:key2' ]

```

## API reference [​](https://js.langchain.com/docs/integrations/stores/in_memory/\#api-reference "Direct link to API reference")

For detailed documentation of all InMemoryStore features and
configurations, head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_core.stores.InMemoryStore.html)

## Related [​](https://js.langchain.com/docs/integrations/stores/in_memory/\#related "Direct link to Related")

- [Key-value store conceptual guide](https://js.langchain.com/docs/concepts/#key-value-stores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/stores/in_memory/%3E).

- [Overview](https://js.langchain.com/docs/integrations/stores/in_memory/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/stores/in_memory/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/stores/in_memory/#setup)
  - [Installation](https://js.langchain.com/docs/integrations/stores/in_memory/#installation)
- [Instantiation](https://js.langchain.com/docs/integrations/stores/in_memory/#instantiation)
- [Usage](https://js.langchain.com/docs/integrations/stores/in_memory/#usage)
- [Yielding values](https://js.langchain.com/docs/integrations/stores/in_memory/#yielding-values)
- [API reference](https://js.langchain.com/docs/integrations/stores/in_memory/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/stores/in_memory/#related)