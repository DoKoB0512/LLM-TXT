[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/azure_cosmosdb_mongodb/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Azure Cosmos DB for MongoDB vCore

> [Azure Cosmos DB for MongoDB vCore](https://learn.microsoft.com/azure/cosmos-db/mongodb/vcore/) makes it easy to create a database with full native MongoDB support. You can apply your MongoDB experience and continue to use your favorite MongoDB drivers, SDKs, and tools by pointing your application to the API for MongoDB vCore account’s connection string. Use vector search in Azure Cosmos DB for MongoDB vCore to seamlessly integrate your AI-based applications with your data that’s stored in Azure Cosmos DB.

Azure Cosmos DB for MongoDB vCore provides developers with a fully managed MongoDB-compatible database service for building modern applications with a familiar architecture.

Learn how to leverage the vector search capabilities of Azure Cosmos DB for MongoDB vCore from [this page](https://learn.microsoft.com/azure/cosmos-db/mongodb/vcore/vector-search). If you don't have an Azure account, you can [create a free account](https://azure.microsoft.com/free/) to get started.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/azure_cosmosdb_mongodb/\#setup "Direct link to Setup")

You'll first need to install the [`@langchain/azure-cosmosdb`](https://www.npmjs.com/package/@langchain/azure-cosmosdb) package:

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @langchain/azure-cosmosdb @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/azure-cosmosdb @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/azure-cosmosdb @langchain/core

```

You'll also need to have an Azure Cosmos DB for MongoDB vCore instance running. You can deploy a free version on Azure Portal without any cost, following [this guide](https://learn.microsoft.com/azure/cosmos-db/mongodb/vcore/quickstart-portal).

Once you have your instance running, make sure you have the connection string and the admin key. You can find them in the Azure Portal, under the "Connection strings" section of your instance. Then you need to set the following environment variables:

```codeBlockLines_AdAo
AZURE_COSMOSDB_MONGODB_CONNECTION_STRING=

```

#### API Reference:

## Example [​](https://js.langchain.com/docs/integrations/vectorstores/azure_cosmosdb_mongodb/\#example "Direct link to Example")

Below is an example that indexes documents from a file in Azure Cosmos DB for MongoDB vCore, runs a vector search query, and finally uses a chain to answer a question in natural language
based on the retrieved documents.

```codeBlockLines_AdAo
import {
  AzureCosmosDBMongoDBVectorStore,
  AzureCosmosDBMongoDBSimilarityType,
} from "@langchain/azure-cosmosdb";
import { ChatPromptTemplate } from "@langchain/core/prompts";
import { ChatOpenAI, OpenAIEmbeddings } from "@langchain/openai";
import { createStuffDocumentsChain } from "langchain/chains/combine_documents";
import { createRetrievalChain } from "langchain/chains/retrieval";
import { TextLoader } from "langchain/document_loaders/fs/text";
import { RecursiveCharacterTextSplitter } from "@langchain/textsplitters";

// Load documents from file
const loader = new TextLoader("./state_of_the_union.txt");
const rawDocuments = await loader.load();
const splitter = new RecursiveCharacterTextSplitter({
  chunkSize: 1000,
  chunkOverlap: 0,
});
const documents = await splitter.splitDocuments(rawDocuments);

// Create Azure Cosmos DB for MongoDB vCore vector store
const store = await AzureCosmosDBMongoDBVectorStore.fromDocuments(
  documents,
  new OpenAIEmbeddings(),
  {
    databaseName: "langchain",
    collectionName: "documents",
    indexOptions: {
      numLists: 100,
      dimensions: 1536,
      similarity: AzureCosmosDBMongoDBSimilarityType.COS,
    },
  }
);

// Performs a similarity search
const resultDocuments = await store.similaritySearch(
  "What did the president say about Ketanji Brown Jackson?"
);

console.log("Similarity search results:");
console.log(resultDocuments[0].pageContent);
/*
  Tonight. I call on the Senate to: Pass the Freedom to Vote Act. Pass the John Lewis Voting Rights Act. And while you’re at it, pass the Disclose Act so Americans can know who is funding our elections.

  Tonight, I’d like to honor someone who has dedicated his life to serve this country: Justice Stephen Breyer—an Army veteran, Constitutional scholar, and retiring Justice of the United States Supreme Court. Justice Breyer, thank you for your service.

  One of the most serious constitutional responsibilities a President has is nominating someone to serve on the United States Supreme Court.

  And I did that 4 days ago, when I nominated Circuit Court of Appeals Judge Ketanji Brown Jackson. One of our nation’s top legal minds, who will continue Justice Breyer’s legacy of excellence.
*/

// Use the store as part of a chain
const model = new ChatOpenAI({ model: "gpt-3.5-turbo-1106" });
const questionAnsweringPrompt = ChatPromptTemplate.fromMessages([\
  [\
    "system",\
    "Answer the user's questions based on the below context:\n\n{context}",\
  ],\
  ["human", "{input}"],\
]);

const combineDocsChain = await createStuffDocumentsChain({
  llm: model,
  prompt: questionAnsweringPrompt,
});

const chain = await createRetrievalChain({
  retriever: store.asRetriever(),
  combineDocsChain,
});

const res = await chain.invoke({
  input: "What is the president's top priority regarding prices?",
});

console.log("Chain response:");
console.log(res.answer);
/*
  The president's top priority is getting prices under control.
*/

// Clean up
await store.delete();

await store.close();

```

#### API Reference:

- AzureCosmosDBMongoDBVectorStorefrom `@langchain/azure-cosmosdb`
- AzureCosmosDBMongoDBSimilarityTypefrom `@langchain/azure-cosmosdb`
- ChatPromptTemplatefrom `@langchain/core/prompts`
- ChatOpenAIfrom `@langchain/openai`
- OpenAIEmbeddingsfrom `@langchain/openai`
- createStuffDocumentsChainfrom `langchain/chains/combine_documents`
- createRetrievalChainfrom `langchain/chains/retrieval`
- TextLoaderfrom `langchain/document_loaders/fs/text`
- RecursiveCharacterTextSplitterfrom `@langchain/textsplitters`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/azure_cosmosdb_mongodb/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/azure_cosmosdb_mongodb/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/azure_cosmosdb_mongodb/#setup)
- [Example](https://js.langchain.com/docs/integrations/vectorstores/azure_cosmosdb_mongodb/#example)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/azure_cosmosdb_mongodb/#related)