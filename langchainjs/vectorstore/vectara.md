[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/vectara/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Vectara

Vectara is a platform for building GenAI applications. It provides an easy-to-use API for document indexing and querying that is managed by Vectara and is optimized for performance and accuracy.

You can use Vectara as a vector store with LangChain.js.

## 👉 Embeddings Included [​](https://js.langchain.com/docs/integrations/vectorstores/vectara/\#-embeddings-included "Direct link to 👉 Embeddings Included")

Vectara uses its own embeddings under the hood, so you don't have to provide any yourself or call another service to obtain embeddings.

This also means that if you provide your own embeddings, they'll be a no-op.

```codeBlockLines_AdAo
const store = await VectaraStore.fromTexts(
  ["hello world", "hi there"],
  [{ foo: "bar" }, { foo: "baz" }],
  // This won't have an effect. Provide a FakeEmbeddings instance instead for clarity.
  new OpenAIEmbeddings(),
  args
);

```

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/vectara/\#setup "Direct link to Setup")

You'll need to:

- Create a [free Vectara account](https://vectara.com/integrations/langchain).
- Create a [corpus](https://docs.vectara.com/docs/console-ui/creating-a-corpus) to store your data
- Create an [API key](https://docs.vectara.com/docs/common-use-cases/app-authn-authz/api-keys) with QueryService and IndexService access so you can access this corpus

Configure your `.env` file or provide args to connect LangChain to your Vectara corpus:

```codeBlockLines_AdAo
VECTARA_CUSTOMER_ID=your_customer_id
VECTARA_CORPUS_ID=your_corpus_id
VECTARA_API_KEY=your-vectara-api-key

```

Note that you can provide multiple corpus IDs separated by commas for querying multiple corpora at once. For example: `VECTARA_CORPUS_ID=3,8,9,43`.
For indexing multiple corpora, you'll need to create a separate VectaraStore instance for each corpus.

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/vectara/\#usage "Direct link to Usage")

```codeBlockLines_AdAo
import { VectaraStore } from "@langchain/community/vectorstores/vectara";
import { VectaraSummaryRetriever } from "@langchain/community/retrievers/vectara_summary";
import { Document } from "@langchain/core/documents";

// Create the Vectara store.
const store = new VectaraStore({
  customerId: Number(process.env.VECTARA_CUSTOMER_ID),
  corpusId: Number(process.env.VECTARA_CORPUS_ID),
  apiKey: String(process.env.VECTARA_API_KEY),
  verbose: true,
});

// Add two documents with some metadata.
const doc_ids = await store.addDocuments([\
  new Document({\
    pageContent: "Do I dare to eat a peach?",\
    metadata: {\
      foo: "baz",\
    },\
  }),\
  new Document({\
    pageContent: "In the room the women come and go talking of Michelangelo",\
    metadata: {\
      foo: "bar",\
    },\
  }),\
]);

// Perform a similarity search.
const resultsWithScore = await store.similaritySearchWithScore(
  "What were the women talking about?",
  1,
  {
    lambda: 0.025,
  }
);

// Print the results.
console.log(JSON.stringify(resultsWithScore, null, 2));
/*
[\
  [\
    {\
      "pageContent": "In the room the women come and go talking of Michelangelo",\
      "metadata": {\
        "lang": "eng",\
        "offset": "0",\
        "len": "57",\
        "foo": "bar"\
      }\
    },\
    0.4678752\
  ]\
]
*/

const retriever = new VectaraSummaryRetriever({ vectara: store, topK: 3 });
const documents = await retriever.invoke("What were the women talking about?");

console.log(JSON.stringify(documents, null, 2));
/*
[\
  {\
    "pageContent": "<b>In the room the women come and go talking of Michelangelo</b>",\
    "metadata": {\
      "lang": "eng",\
      "offset": "0",\
      "len": "57",\
      "foo": "bar"\
    }\
  },\
  {\
    "pageContent": "<b>In the room the women come and go talking of Michelangelo</b>",\
    "metadata": {\
      "lang": "eng",\
      "offset": "0",\
      "len": "57",\
      "foo": "bar"\
    }\
  },\
  {\
    "pageContent": "<b>In the room the women come and go talking of Michelangelo</b>",\
    "metadata": {\
      "lang": "eng",\
      "offset": "0",\
      "len": "57",\
      "foo": "bar"\
    }\
  }\
]
*/

// Delete the documents.
await store.deleteDocuments(doc_ids);

```

#### API Reference:

- VectaraStorefrom `@langchain/community/vectorstores/vectara`
- VectaraSummaryRetrieverfrom `@langchain/community/retrievers/vectara_summary`
- Documentfrom `@langchain/core/documents`

Note that `lambda` is a parameter related to Vectara's hybrid search capbility, providing a tradeoff between neural search and boolean/exact match as described [here](https://docs.vectara.com/docs/api-reference/search-apis/lexical-matching). We recommend the value of 0.025 as a default, while providing a way for advanced users to customize this value if needed.

## APIs [​](https://js.langchain.com/docs/integrations/vectorstores/vectara/\#apis "Direct link to APIs")

Vectara's LangChain vector store consumes Vectara's core APIs:

- [Indexing API](https://docs.vectara.com/docs/indexing-apis/indexing) for storing documents in a Vectara corpus.
- [Search API](https://docs.vectara.com/docs/search-apis/search) for querying this data. This API supports hybrid search.

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/vectara/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/vectara/%3E).

- [👉 Embeddings Included](https://js.langchain.com/docs/integrations/vectorstores/vectara/#-embeddings-included)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/vectara/#setup)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/vectara/#usage)
- [APIs](https://js.langchain.com/docs/integrations/vectorstores/vectara/#apis)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/vectara/#related)