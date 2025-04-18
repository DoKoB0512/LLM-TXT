[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/milvus/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Milvus

[Milvus](https://milvus.io/) is a vector database built for embeddings similarity search and AI applications.

Compatibility

Only available on Node.js.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/milvus/\#setup "Direct link to Setup")

1. Run Milvus instance with Docker on your computer [docs](https://milvus.io/docs/v2.1.x/install_standalone-docker.md)

2. Install the Milvus Node.js SDK.



- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S @zilliz/milvus2-sdk-node

```

```codeBlockLines_AdAo
yarn add @zilliz/milvus2-sdk-node

```

```codeBlockLines_AdAo
pnpm add @zilliz/milvus2-sdk-node

```

3. Setup Env variables for Milvus before running the code

3.1 OpenAI





```codeBlockLines_AdAo
export OPENAI_API_KEY=YOUR_OPENAI_API_KEY_HERE
export MILVUS_URL=YOUR_MILVUS_URL_HERE # for example http://localhost:19530

```









3.2 Azure OpenAI





```codeBlockLines_AdAo
export AZURE_OPENAI_API_KEY=YOUR_AZURE_OPENAI_API_KEY_HERE
export AZURE_OPENAI_API_INSTANCE_NAME=YOUR_AZURE_OPENAI_INSTANCE_NAME_HERE
export AZURE_OPENAI_API_DEPLOYMENT_NAME=YOUR_AZURE_OPENAI_DEPLOYMENT_NAME_HERE
export AZURE_OPENAI_API_COMPLETIONS_DEPLOYMENT_NAME=YOUR_AZURE_OPENAI_COMPLETIONS_DEPLOYMENT_NAME_HERE
export AZURE_OPENAI_API_EMBEDDINGS_DEPLOYMENT_NAME=YOUR_AZURE_OPENAI_EMBEDDINGS_DEPLOYMENT_NAME_HERE
export AZURE_OPENAI_API_VERSION=YOUR_AZURE_OPENAI_API_VERSION_HERE
export AZURE_OPENAI_BASE_PATH=YOUR_AZURE_OPENAI_BASE_PATH_HERE
export MILVUS_URL=YOUR_MILVUS_URL_HERE # for example http://localhost:19530

```


## Index and query docs [​](https://js.langchain.com/docs/integrations/vectorstores/milvus/\#index-and-query-docs "Direct link to Index and query docs")

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/openai @langchain/core

```

```codeBlockLines_AdAo
import { Milvus } from "langchain/vectorstores/milvus";
import { OpenAIEmbeddings } from "@langchain/openai";

// text sample from Godel, Escher, Bach
const vectorStore = await Milvus.fromTexts(
  [\
    "Tortoise: Labyrinth? Labyrinth? Could it Are we in the notorious Little\\
            Harmonic Labyrinth of the dreaded Majotaur?",\
    "Achilles: Yiikes! What is that?",\
    "Tortoise: They say-although I person never believed it myself-that an I\\
            Majotaur has created a tiny labyrinth sits in a pit in the middle of\\
            it, waiting innocent victims to get lost in its fears complexity.\\
            Then, when they wander and dazed into the center, he laughs and\\
            laughs at them-so hard, that he laughs them to death!",\
    "Achilles: Oh, no!",\
    "Tortoise: But it's only a myth. Courage, Achilles.",\
  ],
  [{ id: 2 }, { id: 1 }, { id: 3 }, { id: 4 }, { id: 5 }],
  new OpenAIEmbeddings(),
  {
    collectionName: "goldel_escher_bach",
  }
);

// or alternatively from docs
const vectorStore = await Milvus.fromDocuments(docs, new OpenAIEmbeddings(), {
  collectionName: "goldel_escher_bach",
});

const response = await vectorStore.similaritySearch("scared", 2);

```

## Query docs from existing collection [​](https://js.langchain.com/docs/integrations/vectorstores/milvus/\#query-docs-from-existing-collection "Direct link to Query docs from existing collection")

```codeBlockLines_AdAo
import { Milvus } from "langchain/vectorstores/milvus";
import { OpenAIEmbeddings } from "@langchain/openai";

const vectorStore = await Milvus.fromExistingCollection(
  new OpenAIEmbeddings(),
  {
    collectionName: "goldel_escher_bach",
  }
);

const response = await vectorStore.similaritySearch("scared", 2);

```

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/milvus/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/milvus/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/milvus/#setup)
- [Index and query docs](https://js.langchain.com/docs/integrations/vectorstores/milvus/#index-and-query-docs)
- [Query docs from existing collection](https://js.langchain.com/docs/integrations/vectorstores/milvus/#query-docs-from-existing-collection)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/milvus/#related)