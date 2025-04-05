[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

The `AzionVectorStore` is used to manage and search through a collection
of documents using vector embeddings, directly on Azion’s Edge Plataform
using Edge SQL.

This guide provides a quick overview for getting started with Azion
EdgeSQL [vector stores](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `AzionVectorStore` features and configurations head
to the [API\\
reference](https://api.js.langchain.com/classes/_langchain_community.vectorstores_azion_edgesql.AzionVectorStore.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#integration-details "Direct link to Integration details")

| Class | Package | \[PY support\] | Package latest |
| :-- | :-- | :-: | :-: |
| [`AzionVectorStore`](https://api.js.langchain.com/classes/langchain_community_vectorstores_azion_edgesql.AzionVectorStore.html) | [`@langchain/community`](https://npmjs.com/@langchain/community) | ❌ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/community?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#setup "Direct link to Setup")

To use the `AzionVectorStore` vector store, you will need to install the
`@langchain/community` package. Besides that, you will need an [Azion\\
account](https://www.azion.com/en/documentation/products/accounts/creating-account/)
and a
[Token](https://www.azion.com/en/documentation/products/guides/personal-tokens/)
to use the Azion API, configuring it as environment variable
`AZION_TOKEN`. Further information about this can be found in the
[Documentation](https://www.azion.com/en/documentation/).

This guide will also use [OpenAI\\
embeddings](https://js.langchain.com/docs/integrations/text_embedding/openai), which require you
to install the `@langchain/openai` integration package. You can also use
[other supported embeddings models](https://js.langchain.com/docs/integrations/text_embedding)
if you wish.

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i azion @langchain/openai @langchain/community

```

```codeBlockLines_AdAo
yarn add azion @langchain/openai @langchain/community

```

```codeBlockLines_AdAo
pnpm add azion @langchain/openai @langchain/community

```

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#credentials "Direct link to Credentials")

Once you’ve done this set the AZION\_TOKEN environment variable:

```codeBlockLines_AdAo
process.env.AZION_TOKEN = "your-api-key";

```

If you are using OpenAI embeddings for this guide, you’ll need to set
your OpenAI key as well:

```codeBlockLines_AdAo
process.env.OPENAI_API_KEY = "YOUR_API_KEY";

```

If you want to get automated tracing of your model calls you can also
set your [LangSmith](https://docs.smith.langchain.com/) API key by
uncommenting below:

```codeBlockLines_AdAo
// process.env.LANGCHAIN_TRACING_V2="true"
// process.env.LANGCHAIN_API_KEY="your-api-key"

```

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#instantiation "Direct link to Instantiation")

```codeBlockLines_AdAo
import { AzionVectorStore } from "@langchain/community/vectorstores/azion_edgesql";
import { OpenAIEmbeddings } from "@langchain/openai";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

// Instantiate with the constructor if the database and table have already been created
const vectorStore = new AzionVectorStore(embeddings, {
  dbName: "langchain",
  tableName: "documents",
});

// If you have not created the database and table yet, you can do so with the setupDatabase method
// await vectorStore.setupDatabase({ columns:["topic","language"], mode: "hybrid" })

// OR instantiate with the static method if the database and table have not been created yet
// const vectorStore = await AzionVectorStore.initialize(embeddingModel, { dbName: "langchain", tableName: "documents" }, { columns:[], mode: "hybrid" })

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#add-items-to-vector-store "Direct link to Add items to vector store")

```codeBlockLines_AdAo
import type { Document } from "@langchain/core/documents";

const document1: Document = {
  pageContent: "The powerhouse of the cell is the mitochondria",
  metadata: { language: "en", topic: "biology" },
};

const document2: Document = {
  pageContent: "Buildings are made out of brick",
  metadata: { language: "en", topic: "history" },
};

const document3: Document = {
  pageContent: "Mitochondria are made out of lipids",
  metadata: { language: "en", topic: "biology" },
};

const document4: Document = {
  pageContent: "The 2024 Olympics are in Paris",
  metadata: { language: "en", topic: "history" },
};

const documents = [document1, document2, document3, document4];

await vectorStore.addDocuments(documents);

```

```codeBlockLines_AdAo
Inserting chunks
Inserting chunk 0
Chunks inserted!

```

### Delete items from vector store [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#delete-items-from-vector-store "Direct link to Delete items from vector store")

```codeBlockLines_AdAo
await vectorStore.delete(["4"]);

```

```codeBlockLines_AdAo
Deleted 1 items from documents

```

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
const filter = [{ operator: "=", column: "language", value: "en" }];

const hybridSearchResults = await vectorStore.azionHybridSearch("biology", {
  kfts: 2,
  kvector: 1,
  filter: [{ operator: "=", column: "language", value: "en" }],
});

console.log("Hybrid Search Results");
for (const doc of hybridSearchResults) {
  console.log(`${JSON.stringify(doc)}`);
}

```

```codeBlockLines_AdAo
Hybrid Search Results
[{"pageContent":"The Australian dingo is a unique species that plays a key role in the ecosystem","metadata":{"searchtype":"fulltextsearch"},"id":"6"},-0.25748711028997995]
[{"pageContent":"The powerhouse of the cell is the mitochondria","metadata":{"searchtype":"fulltextsearch"},"id":"16"},-0.31697985337654005]
[{"pageContent":"Australia s indigenous people have inhabited the continent for over 65,000 years","metadata":{"searchtype":"similarity"},"id":"3"},0.14822345972061157]

```

```codeBlockLines_AdAo
const similaritySearchResults = await vectorStore.azionSimilaritySearch(
  "australia",
  { kvector: 3, filter: [{ operator: "=", column: "topic", value: "history" }] }
);

console.log("Similarity Search Results");
for (const doc of similaritySearchResults) {
  console.log(`${JSON.stringify(doc)}`);
}

```

```codeBlockLines_AdAo
Similarity Search Results
[{"pageContent":"Australia s indigenous people have inhabited the continent for over 65,000 years","metadata":{"searchtype":"similarity"},"id":"3"},0.4486490488052368]

```

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

You can also transform the vector store into a
[retriever](https://js.langchain.com/docs/concepts/#retrievers) for easier usage in your chains.

```codeBlockLines_AdAo
const retriever = vectorStore.asRetriever({
  // Optional filter
  filter: filter,
  k: 2,
});
await retriever.invoke("biology");

```

```codeBlockLines_AdAo
[\
  Document {\
    pageContent: 'Australia s indigenous people have inhabited the continent for over 65,000 years',\
    metadata: { searchtype: 'similarity' },\
    id: '3'\
  },\
  Document {\
    pageContent: 'Mitochondria are made out of lipids',\
    metadata: { searchtype: 'similarity' },\
    id: '18'\
  }\
]

```

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#api-reference "Direct link to API reference")

For detailed documentation of all AzionVectorStore features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/_langchain_community.vectorstores_azion_edgesql.AzionVectorStore.html).

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/azion-edgesql/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#setup)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#add-items-to-vector-store)
  - [Delete items from vector store](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#delete-items-from-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#query-directly)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#usage-for-retrieval-augmented-generation)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/azion-edgesql/#related)