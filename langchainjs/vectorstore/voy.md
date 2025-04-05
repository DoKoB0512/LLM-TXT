[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/voy/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Voy

[Voy](https://github.com/tantaraio/voy) is a WASM vector similarity search engine written in Rust.
It's supported in non-Node environments like browsers. You can use Voy as a vector store with LangChain.js.

### Install Voy [​](https://js.langchain.com/docs/integrations/vectorstores/voy/\#install-voy "Direct link to Install Voy")

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @langchain/openai voy-search @langchain/community @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/openai voy-search @langchain/community @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/openai voy-search @langchain/community @langchain/core

```

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/voy/\#usage "Direct link to Usage")

```codeBlockLines_AdAo
import { VoyVectorStore } from "@langchain/community/vectorstores/voy";
import { Voy as VoyClient } from "voy-search";
import { OpenAIEmbeddings } from "@langchain/openai";
import { Document } from "@langchain/core/documents";

// Create Voy client using the library.
const voyClient = new VoyClient();
// Create embeddings
const embeddings = new OpenAIEmbeddings();
// Create the Voy store.
const store = new VoyVectorStore(voyClient, embeddings);

// Add two documents with some metadata.
await store.addDocuments([\
  new Document({\
    pageContent: "How has life been treating you?",\
    metadata: {\
      foo: "Mike",\
    },\
  }),\
  new Document({\
    pageContent: "And I took it personally...",\
    metadata: {\
      foo: "Testing",\
    },\
  }),\
]);

const model = new OpenAIEmbeddings();
const query = await model.embedQuery("And I took it personally");

// Perform a similarity search.
const resultsWithScore = await store.similaritySearchVectorWithScore(query, 1);

// Print the results.
console.log(JSON.stringify(resultsWithScore, null, 2));
/*
  [\
    [\
      {\
        "pageContent": "And I took it personally...",\
        "metadata": {\
          "foo": "Testing"\
        }\
      },\
      0\
    ]\
  ]
*/

```

#### API Reference:

- VoyVectorStorefrom `@langchain/community/vectorstores/voy`
- OpenAIEmbeddingsfrom `@langchain/openai`
- Documentfrom `@langchain/core/documents`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/voy/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/voy/%3E).

- [Install Voy](https://js.langchain.com/docs/integrations/vectorstores/voy/#install-voy)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/voy/#usage)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/voy/#related)