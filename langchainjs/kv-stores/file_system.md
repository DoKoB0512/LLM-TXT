[Skip to main content](https://js.langchain.com/docs/integrations/stores/file_system/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

Compatibility

Only available on Node.js.

This will help you get started with
[LocalFileStore](https://js.langchain.com/docs/concepts/key_value_stores). For detailed
documentation of all LocalFileStore features and configurations head to
the [API\\
reference](https://api.js.langchain.com/classes/langchain.storage_file_system.LocalFileStore.html).

## Overview [​](https://js.langchain.com/docs/integrations/stores/file_system/\#overview "Direct link to Overview")

The `LocalFileStore` is a wrapper around the `fs` module for storing
data as key-value pairs. Each key value pair has its own file nested
inside the directory passed to the `.fromPath` method. The file name is
the key and inside contains the value of the key.

info

The path passed to the `.fromPath` must be a directory, not a file.

danger

This file store can alter any text file in the provided directory and any subfolders.
Make sure that the path you specify when initializing the store is free of other files.

### Integration details [​](https://js.langchain.com/docs/integrations/stores/file_system/\#integration-details "Direct link to Integration details")

| Class | Package | Local | [PY support](https://python.langchain.com/docs/integrations/stores/file_system/) | Package downloads | Package latest |
| :-- | :-- | :-: | :-: | :-: | :-: |
| [LocalFileStore](https://api.js.langchain.com/classes/langchain.storage_file_system.LocalFileStore.html) | [langchain](https://api.js.langchain.com/modules/langchain.storage_file_system.html) | ✅ | ✅ | ![NPM - Downloads](https://img.shields.io/npm/dm/langchain?style=flat-square&label=%20&.png) | ![NPM - Version](https://img.shields.io/npm/v/langchain?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/stores/file_system/\#setup "Direct link to Setup")

### Installation [​](https://js.langchain.com/docs/integrations/stores/file_system/\#installation "Direct link to Installation")

The LangChain `LocalFileStore` integration lives in the `langchain`
package:

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i langchain @langchain/core

```

```codeBlockLines_AdAo
yarn add langchain @langchain/core

```

```codeBlockLines_AdAo
pnpm add langchain @langchain/core

```

## Instantiation [​](https://js.langchain.com/docs/integrations/stores/file_system/\#instantiation "Direct link to Instantiation")

Now we can instantiate our byte store:

```codeBlockLines_AdAo
import { LocalFileStore } from "langchain/storage/file_system";

const kvStore = await LocalFileStore.fromPath("./messages");

```

Define an encoder and decoder for converting the data to `Uint8Array`
and back:

```codeBlockLines_AdAo
const encoder = new TextEncoder();
const decoder = new TextDecoder();

```

## Usage [​](https://js.langchain.com/docs/integrations/stores/file_system/\#usage "Direct link to Usage")

You can set data under keys like this using the `mset` method:

```codeBlockLines_AdAo
await kvStore.mset([\
  ["key1", encoder.encode("value1")],\
  ["key2", encoder.encode("value2")],\
]);

const results = await kvStore.mget(["key1", "key2"]);
console.log(results.map((v) => decoder.decode(v)));

```

```codeBlockLines_AdAo
[ 'value1', 'value2' ]

```

And you can delete data using the `mdelete` method:

```codeBlockLines_AdAo
await kvStore.mdelete(["key1", "key2"]);

await kvStore.mget(["key1", "key2"]);

```

```codeBlockLines_AdAo
[ undefined, undefined ]

```

## Yielding values [​](https://js.langchain.com/docs/integrations/stores/file_system/\#yielding-values "Direct link to Yielding values")

If you want to get back all the keys you can call the `yieldKeys`
method. Optionally, you can pass a key prefix to only get back keys
which match that prefix.

```codeBlockLines_AdAo
import { LocalFileStore } from "langchain/storage/file_system";

const kvStoreForYield = await LocalFileStore.fromPath("./messages");

const encoderForYield = new TextEncoder();

// Add some data to the store
await kvStoreForYield.mset([\
  ["message:id:key1", encoderForYield.encode("value1")],\
  ["message:id:key2", encoderForYield.encode("value2")],\
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

```codeBlockLines_AdAo
import fs from "fs";

// Cleanup
await fs.promises.rm("./messages", { recursive: true, force: true });

```

## API reference [​](https://js.langchain.com/docs/integrations/stores/file_system/\#api-reference "Direct link to API reference")

For detailed documentation of all LocalFileStore features and
configurations, head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_storage_file_system.LocalFileStore.html)

## Related [​](https://js.langchain.com/docs/integrations/stores/file_system/\#related "Direct link to Related")

- [Key-value store conceptual guide](https://js.langchain.com/docs/concepts/#key-value-stores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/stores/file_system/%3E).

- [Overview](https://js.langchain.com/docs/integrations/stores/file_system/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/stores/file_system/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/stores/file_system/#setup)
  - [Installation](https://js.langchain.com/docs/integrations/stores/file_system/#installation)
- [Instantiation](https://js.langchain.com/docs/integrations/stores/file_system/#instantiation)
- [Usage](https://js.langchain.com/docs/integrations/stores/file_system/#usage)
- [Yielding values](https://js.langchain.com/docs/integrations/stores/file_system/#yielding-values)
- [API reference](https://js.langchain.com/docs/integrations/stores/file_system/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/stores/file_system/#related)