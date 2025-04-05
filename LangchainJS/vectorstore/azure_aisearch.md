[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/azure_aisearch/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Azure AI Search

[Azure AI Search](https://azure.microsoft.com/products/ai-services/ai-search) (formerly known as Azure Search and Azure Cognitive Search) is a distributed, RESTful search engine optimized for speed and relevance on production-scale workloads on Azure. It supports also vector search using the [k-nearest neighbor](https://en.wikipedia.org/wiki/Nearest_neighbor_search) (kNN) algorithm and also [semantic search](https://learn.microsoft.com/azure/search/semantic-search-overview).

This vector store integration supports full text search, vector search and [hybrid search for best ranking performance](https://techcommunity.microsoft.com/t5/ai-azure-ai-services-blog/azure-cognitive-search-outperforming-vector-search-with-hybrid/ba-p/3929167).

Learn how to leverage the vector search capabilities of Azure AI Search from [this page](https://learn.microsoft.com/azure/search/vector-search-overview). If you don't have an Azure account, you can [create a free account](https://azure.microsoft.com/free/) to get started.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/azure_aisearch/\#setup "Direct link to Setup")

You'll first need to install the `@azure/search-documents` SDK and the [`@langchain/community`](https://www.npmjs.com/package/@langchain/community) package:

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S @langchain/community @langchain/core @azure/search-documents

```

```codeBlockLines_AdAo
yarn add @langchain/community @langchain/core @azure/search-documents

```

```codeBlockLines_AdAo
pnpm add @langchain/community @langchain/core @azure/search-documents

```

You'll also need to have an Azure AI Search instance running. You can deploy a free version on Azure Portal without any cost, following [this guide](https://learn.microsoft.com/azure/search/search-create-service-portal).

Once you have your instance running, make sure you have the endpoint and the admin key (query keys can be used only to search document, not to index, update or delete). The endpoint is the URL of your instance which you can find in the Azure Portal, under the "Overview" section of your instance. The admin key can be found under the "Keys" section of your instance. Then you need to set the following environment variables:

```codeBlockLines_AdAo
# Azure AI Search connection settings
AZURE_AISEARCH_ENDPOINT=
AZURE_AISEARCH_KEY=

# If you're using Azure OpenAI API, you'll need to set these variables
AZURE_OPENAI_API_KEY=
AZURE_OPENAI_API_INSTANCE_NAME=
AZURE_OPENAI_API_DEPLOYMENT_NAME=
AZURE_OPENAI_API_EMBEDDINGS_DEPLOYMENT_NAME=
AZURE_OPENAI_API_VERSION=

# Or you can use the OpenAI API directly
OPENAI_API_KEY=

```

#### API Reference:

## About hybrid search [​](https://js.langchain.com/docs/integrations/vectorstores/azure_aisearch/\#about-hybrid-search "Direct link to About hybrid search")

Hybrid search is a feature that combines the strengths of full text search and vector search to provide the best ranking performance. It's enabled by default in Azure AI Search vector stores, but you can select a different search query type by setting the `search.type` property when creating the vector store.

You can read more about hybrid search and how it may improve your search results in the [official documentation](https://learn.microsoft.com/azure/search/hybrid-search-overview).

In some scenarios like retrieval-augmented generation (RAG), you may want to enable **semantic ranking** in addition to hybrid search to improve the relevance of the search results. You can enable semantic ranking by setting the `search.type` property to `AzureAISearchQueryType.SemanticHybrid` when creating the vector store.
Note that semantic ranking capabilities are only available in the Basic and higher pricing tiers, and subject to [regional availability](https://azure.microsoft.com/en-us/explore/global-infrastructure/products-by-region/?products=search).

You can read more about the performance of using semantic ranking with hybrid search in [this blog post](https://techcommunity.microsoft.com/t5/ai-azure-ai-services-blog/azure-cognitive-search-outperforming-vector-search-with-hybrid/ba-p/3929167).

## Example: index docs, vector search and LLM integration [​](https://js.langchain.com/docs/integrations/vectorstores/azure_aisearch/\#example-index-docs-vector-search-and-llm-integration "Direct link to Example: index docs, vector search and LLM integration")

Below is an example that indexes documents from a file in Azure AI Search, runs a hybrid search query, and finally uses a chain to answer a question in natural language based on the retrieved documents.

```codeBlockLines_AdAo
import {
  AzureAISearchVectorStore,
  AzureAISearchQueryType,
} from "@langchain/community/vectorstores/azure_aisearch";
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

// Create Azure AI Search vector store
const store = await AzureAISearchVectorStore.fromDocuments(
  documents,
  new OpenAIEmbeddings(),
  {
    search: {
      type: AzureAISearchQueryType.SimilarityHybrid,
    },
  }
);

// The first time you run this, the index will be created.
// You may need to wait a bit for the index to be created before you can perform
// a search, or you can create the index manually beforehand.

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

const response = await chain.invoke({
  input: "What is the president's top priority regarding prices?",
});

console.log("Chain response:");
console.log(response.answer);
/*
  The president's top priority is getting prices under control.
*/

```

#### API Reference:

- AzureAISearchVectorStorefrom `@langchain/community/vectorstores/azure_aisearch`
- AzureAISearchQueryTypefrom `@langchain/community/vectorstores/azure_aisearch`
- ChatPromptTemplatefrom `@langchain/core/prompts`
- ChatOpenAIfrom `@langchain/openai`
- OpenAIEmbeddingsfrom `@langchain/openai`
- createStuffDocumentsChainfrom `langchain/chains/combine_documents`
- createRetrievalChainfrom `langchain/chains/retrieval`
- TextLoaderfrom `langchain/document_loaders/fs/text`
- RecursiveCharacterTextSplitterfrom `@langchain/textsplitters`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/azure_aisearch/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/azure_aisearch/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/azure_aisearch/#setup)
- [About hybrid search](https://js.langchain.com/docs/integrations/vectorstores/azure_aisearch/#about-hybrid-search)
- [Example: index docs, vector search and LLM integration](https://js.langchain.com/docs/integrations/vectorstores/azure_aisearch/#example-index-docs-vector-search-and-llm-integration)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/azure_aisearch/#related)