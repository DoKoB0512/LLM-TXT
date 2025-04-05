[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/turbopuffer/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Turbopuffer

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/turbopuffer/\#setup "Direct link to Setup")

First you must sign up for a Turbopuffer account [here](https://turbopuffer.com/join).
Then, once you have an account you can create an API key.

Set your API key as an environment variable:

```codeBlockLines_AdAo
export TURBOPUFFER_API_KEY=<YOUR_API_KEY>

```

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/turbopuffer/\#usage "Direct link to Usage")

Here are some examples of how to use the class. You can filter your queries by previous specified metadata, but
keep in mind that currently only string values are supported.

See [here for more information](https://turbopuffer.com/docs/reference/query#filter-parameters) on acceptable filter formats.

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";
import { TurbopufferVectorStore } from "@langchain/community/vectorstores/turbopuffer";

const embeddings = new OpenAIEmbeddings();

const store = new TurbopufferVectorStore(embeddings, {
  apiKey: process.env.TURBOPUFFER_API_KEY,
  namespace: "my-namespace",
});

const createdAt = new Date().getTime();

// Add some documents to your store.
// Currently, only string metadata values are supported.
const ids = await store.addDocuments([\
  {\
    pageContent: "some content",\
    metadata: { created_at: createdAt.toString() },\
  },\
  { pageContent: "hi", metadata: { created_at: (createdAt + 1).toString() } },\
  { pageContent: "bye", metadata: { created_at: (createdAt + 2).toString() } },\
  {\
    pageContent: "what's this",\
    metadata: { created_at: (createdAt + 3).toString() },\
  },\
]);

// Retrieve documents from the store
const results = await store.similaritySearch("hello", 1);

console.log(results);
/*
  [\
    Document {\
      pageContent: 'hi',\
      metadata: { created_at: '1705519164987' }\
    }\
  ]
*/

// Filter by metadata
// See https://turbopuffer.com/docs/reference/query#filter-parameters for more on
// allowed filters
const results2 = await store.similaritySearch("hello", 1, {
  created_at: [["Eq", (createdAt + 3).toString()]],
});

console.log(results2);

/*
  [\
    Document {\
      pageContent: "what's this",\
      metadata: { created_at: '1705519164989' }\
    }\
  ]
*/

// Upsert by passing ids
await store.addDocuments(
  [\
    { pageContent: "changed", metadata: { created_at: createdAt.toString() } },\
    {\
      pageContent: "hi changed",\
      metadata: { created_at: (createdAt + 1).toString() },\
    },\
    {\
      pageContent: "bye changed",\
      metadata: { created_at: (createdAt + 2).toString() },\
    },\
    {\
      pageContent: "what's this changed",\
      metadata: { created_at: (createdAt + 3).toString() },\
    },\
  ],
  { ids }
);

// Filter by metadata
const results3 = await store.similaritySearch("hello", 10, {
  created_at: [["Eq", (createdAt + 3).toString()]],
});

console.log(results3);

/*
  [\
    Document {\
      pageContent: "what's this changed",\
      metadata: { created_at: '1705519164989' }\
    }\
  ]
*/

// Remove all vectors from the namespace.
await store.delete({
  deleteIndex: true,
});

```

#### API Reference:

- OpenAIEmbeddingsfrom `@langchain/openai`
- TurbopufferVectorStorefrom `@langchain/community/vectorstores/turbopuffer`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/turbopuffer/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/turbopuffer/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/turbopuffer/#setup)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/turbopuffer/#usage)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/turbopuffer/#related)