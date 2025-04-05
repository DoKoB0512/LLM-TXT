# https://js.langchain.com/docs/tutorials/rag llms-full.txt

## Q&A Application Tutorial
[Skip to main content](https://js.langchain.com/docs/tutorials/rag/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

One of the most powerful applications enabled by LLMs is sophisticated
question-answering (Q&A) chatbots. These are applications that can
answer questions about specific source information. These applications
use a technique known as Retrieval Augmented Generation, or
[RAG](https://js.langchain.com/docs/concepts/rag/).

This is a multi-part tutorial:

- [Part 1](https://js.langchain.com/docs/tutorials/rag) (this guide) introduces RAG and walks
through a minimal implementation.
- [Part 2](https://js.langchain.com/docs/tutorials/qa_chat_history) extends the implementation
to accommodate conversation-style interactions and multi-step
retrieval processes.

This tutorial will show how to build a simple Q&A application over a
text data source. Along the way we’ll go over a typical Q&A architecture
and highlight additional resources for more advanced Q&A techniques.
We’ll also see how LangSmith can help us trace and understand our
application. LangSmith will become increasingly helpful as our
application grows in complexity.

If you’re already familiar with basic retrieval, you might also be
interested in this [high-level overview of different retrieval\\
techinques](https://js.langchain.com/docs/concepts/retrieval).

**Note**: Here we focus on Q&A for unstructured data. If you are
interested for RAG over structured data, check out our tutorial on doing
[question/answering over SQL data](https://js.langchain.com/docs/tutorials/sql_qa).

## Overview [​](https://js.langchain.com/docs/tutorials/rag/\#overview "Direct link to Overview")

A typical RAG application has two main components:

**Indexing**: a pipeline for ingesting data from a source and indexing
it. _This usually happens offline._

**Retrieval and generation**: the actual RAG chain, which takes the user
query at run time and retrieves the relevant data from the index, then
passes that to the model.

Note: the indexing portion of this tutorial will largely follow the
[semantic search tutorial](https://js.langchain.com/docs/tutorials/retrievers).

The most common full sequence from raw data to answer looks like:

### Indexing [​](https://js.langchain.com/docs/tutorials/rag/\#indexing "Direct link to Indexing")

1. **Load**: First we need to load our data. This is done with
[Document Loaders](https://js.langchain.com/docs/concepts/document_loaders).
2. **Split**: [Text splitters](https://js.langchain.com/docs/concepts/text_splitters) break
large `Documents` into smaller chunks. This is useful both for
indexing data and passing it into a model, as large chunks are
harder to search over and won’t fit in a model’s finite context
window.
3. **Store**: We need somewhere to store and index our splits, so that
they can be searched over later. This is often done using a
[VectorStore](https://js.langchain.com/docs/concepts/vectorstores) and
[Embeddings](https://js.langchain.com/docs/concepts/embedding_models) model.

![index_diagram](https://js.langchain.com/assets/images/rag_indexing-8160f90a90a33253d0154659cf7d453f.png)

### Retrieval and generation [​](https://js.langchain.com/docs/tutorials/rag/\#retrieval-and-generation "Direct link to Retrieval and generation")

1. **Retrieve**: Given a user input, relevant splits are retrieved from
storage using a [Retriever](https://js.langchain.com/docs/concepts/retrievers).
2. **Generate**: A [ChatModel](https://js.langchain.com/docs/concepts/chat_models) /
[LLM](https://js.langchain.com/docs/concepts/text_llms) produces an answer using a prompt
that includes both the question with the retrieved data

![retrieval_diagram](https://js.langchain.com/assets/images/rag_retrieval_generation-1046a4668d6bb08786ef73c56d4f228a.png)

Once we’ve indexed our data, we will use
[LangGraph](https://langchain-ai.github.io/langgraphjs/) as our
orchestration framework to implement the retrieval and generation steps.

## Setup [​](https://js.langchain.com/docs/tutorials/rag/\#setup "Direct link to Setup")

### Jupyter Notebook [​](https://js.langchain.com/docs/tutorials/rag/\#jupyter-notebook "Direct link to Jupyter Notebook")

This and other tutorials are perhaps most conveniently run in a [Jupyter\\
notebooks](https://jupyter.org/). Going through guides in an interactive
environment is a great way to better understand them. See
[here](https://jupyter.org/install) for instructions on how to install.

### Installation [​](https://js.langchain.com/docs/tutorials/rag/\#installation "Direct link to Installation")

This guide requires the following dependencies:

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i langchain @langchain/core @langchain/langgraph

```

```codeBlockLines_AdAo
yarn add langchain @langchain/core @langchain/langgraph

```

```codeBlockLines_AdAo
pnpm add langchain @langchain/core @langchain/langgraph

```

For more details, see our [Installation\\
guide](https://js.langchain.com/docs/how_to/installation).

### LangSmith [​](https://js.langchain.com/docs/tutorials/rag/\#langsmith "Direct link to LangSmith")

Many of the applications you build with LangChain will contain multiple
steps with multiple invocations of LLM calls. As these applications get
more and more complex, it becomes crucial to be able to inspect what
exactly is going on inside your chain or agent. The best way to do this
is with [LangSmith](https://smith.langchain.com/).

After you sign up at the link above, make sure to set your environment
variables to start logging traces:

```codeBlockLines_AdAo
export LANGSMITH_TRACING="true"
export LANGSMITH_API_KEY="..."

# Reduce tracing latency if you are not in a serverless environment
# export LANGCHAIN_CALLBACKS_BACKGROUND=true

```

## Components [​](https://js.langchain.com/docs/tutorials/rag/\#components "Direct link to Components")

We will need to select three components from LangChain’s suite of
integrations.

A [chat model](https://js.langchain.com/docs/integrations/chat/):

### Pick your chat model:

- Groq
- OpenAI
- Anthropic
- FireworksAI
- MistralAI
- VertexAI

#### Install dependencies

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation/#installing-integration-packages).

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/groq

```

```codeBlockLines_AdAo
yarn add @langchain/groq

```

```codeBlockLines_AdAo
pnpm add @langchain/groq

```

#### Add environment variables

```codeBlockLines_AdAo
GROQ_API_KEY=your-api-key

```

#### Instantiate the model

```codeBlockLines_AdAo
import { ChatGroq } from "@langchain/groq";

const llm = new ChatGroq({
  model: "llama-3.3-70b-versatile",
  temperature: 0
});

```

#### Install dependencies

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation/#installing-integration-packages).

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/openai

```

```codeBlockLines_AdAo
yarn add @langchain/openai

```

```codeBlockLines_AdAo
pnpm add @langchain/openai

```

#### Add environment variables

```codeBlockLines_AdAo
OPENAI_API_KEY=your-api-key

```

#### Instantiate the model

```codeBlockLines_AdAo
import { ChatOpenAI } from "@langchain/openai";

const llm = new ChatOpenAI({
  model: "gpt-4o-mini",
  temperature: 0
});

```

#### Install dependencies

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation/#installing-integration-packages).

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/anthropic

```

```codeBlockLines_AdAo
yarn add @langchain/anthropic

```

```codeBlockLines_AdAo
pnpm add @langchain/anthropic

```

#### Add environment variables

```codeBlockLines_AdAo
ANTHROPIC_API_KEY=your-api-key

```

#### Instantiate the model

```codeBlockLines_AdAo
import { ChatAnthropic } from "@langchain/anthropic";

const llm = new ChatAnthropic({
  model: "claude-3-5-sonnet-20240620",
  temperature: 0
});

```

#### Install dependencies

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation/#installing-integration-packages).

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/community

```

```codeBlockLines_AdAo
yarn add @langchain/community

```

```codeBlockLines_AdAo
pnpm add @langchain/community

```

#### Add environment variables

```codeBlockLines_AdAo
FIREWORKS_API_KEY=your-api-key

```

#### Instantiate the model

```codeBlockLines_AdAo
import { ChatFireworks } from "@langchain/community/chat_models/fireworks";

const llm = new ChatFireworks({
  model: "accounts/fireworks/models/llama-v3p1-70b-instruct",
  temperature: 0
});

```

#### Install dependencies

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation/#installing-integration-packages).

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/mistralai

```

```codeBlockLines_AdAo
yarn add @langchain/mistralai

```

```codeBlockLines_AdAo
pnpm add @langchain/mistralai

```

#### Add environment variables

```codeBlockLines_AdAo
MISTRAL_API_KEY=your-api-key

```

#### Instantiate the model

```codeBlockLines_AdAo
import { ChatMistralAI } from "@langchain/mistralai";

const llm = new ChatMistralAI({
  model: "mistral-large-latest",
  temperature: 0
});

```

#### Install dependencies

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation/#installing-integration-packages).

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/google-vertexai

```

```codeBlockLines_AdAo
yarn add @langchain/google-vertexai

```

```codeBlockLines_AdAo
pnpm add @langchain/google-vertexai

```

#### Add environment variables

```codeBlockLines_AdAo
GOOGLE_APPLICATION_CREDENTIALS=credentials.json

```

#### Instantiate the model

```codeBlockLines_AdAo
import { ChatVertexAI } from "@langchain/google-vertexai";

const llm = new ChatVertexAI({
  model: "gemini-1.5-flash",
  temperature: 0
});

```

An [embedding model](https://js.langchain.com/docs/integrations/text_embedding/):

### Pick your embedding model:

- OpenAI
- Azure
- AWS
- VertexAI
- MistralAI
- Cohere

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/openai

```

```codeBlockLines_AdAo
yarn add @langchain/openai

```

```codeBlockLines_AdAo
pnpm add @langchain/openai

```

```codeBlockLines_AdAo
OPENAI_API_KEY=your-api-key

```

```codeBlockLines_AdAo
import { OpenAIEmbeddings } from "@langchain/openai";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-large"
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/openai

```

```codeBlockLines_AdAo
yarn add @langchain/openai

```

```codeBlockLines_AdAo
pnpm add @langchain/openai

```

```codeBlockLines_AdAo
AZURE_OPENAI_API_INSTANCE_NAME=<YOUR_INSTANCE_NAME>
AZURE_OPENAI_API_KEY=<YOUR_KEY>
AZURE_OPENAI_API_VERSION="2024-02-01"

```

```codeBlockLines_AdAo
import { AzureOpenAIEmbeddings } from "@langchain/openai";

const embeddings = new AzureOpenAIEmbeddings({
  azureOpenAIApiEmbeddingsDeploymentName: "text-embedding-ada-002"
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/aws

```

```codeBlockLines_AdAo
yarn add @langchain/aws

```

```codeBlockLines_AdAo
pnpm add @langchain/aws

```

```codeBlockLines_AdAo
BEDROCK_AWS_REGION=your-region

```

```codeBlockLines_AdAo
import { BedrockEmbeddings } from "@langchain/aws";

const embeddings = new BedrockEmbeddings({
  model: "amazon.titan-embed-text-v1"
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/google-vertexai

```

```codeBlockLines_AdAo
yarn add @langchain/google-vertexai

```

```codeBlockLines_AdAo
pnpm add @langchain/google-vertexai

```

```codeBlockLines_AdAo
GOOGLE_APPLICATION_CREDENTIALS=credentials.json

```

```codeBlockLines_AdAo
import { VertexAIEmbeddings } from "@langchain/google-vertexai";

const embeddings = new VertexAIEmbeddings({
  model: "text-embedding-004"
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/mistralai

```

```codeBlockLines_AdAo
yarn add @langchain/mistralai

```

```codeBlockLines_AdAo
pnpm add @langchain/mistralai

```

```codeBlockLines_AdAo
MISTRAL_API_KEY=your-api-key

```

```codeBlockLines_AdAo
import { MistralAIEmbeddings } from "@langchain/mistralai";

const embeddings = new MistralAIEmbeddings({
  model: "mistral-embed"
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/cohere

```

```codeBlockLines_AdAo
yarn add @langchain/cohere

```

```codeBlockLines_AdAo
pnpm add @langchain/cohere

```

```codeBlockLines_AdAo
COHERE_API_KEY=your-api-key

```

```codeBlockLines_AdAo
import { CohereEmbeddings } from "@langchain/cohere";

const embeddings = new CohereEmbeddings({
  model: "embed-english-v3.0"
});

```

And a [vector store](https://js.langchain.com/docs/integrations/vectorstores/):

### Pick your vector store:

- Memory
- Chroma
- FAISS
- MongoDB
- PGVector
- Pinecone
- Qdrant

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i langchain

```

```codeBlockLines_AdAo
yarn add langchain

```

```codeBlockLines_AdAo
pnpm add langchain

```

```codeBlockLines_AdAo
import { MemoryVectorStore } from "langchain/vectorstores/memory";

const vectorStore = new MemoryVectorStore(embeddings);

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/community

```

```codeBlockLines_AdAo
yarn add @langchain/community

```

```codeBlockLines_AdAo
pnpm add @langchain/community

```

```codeBlockLines_AdAo
import { Chroma } from "@langchain/community/vectorstores/chroma";

const vectorStore = new Chroma(embeddings, {
  collectionName: "a-test-collection",
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/community

```

```codeBlockLines_AdAo
yarn add @langchain/community

```

```codeBlockLines_AdAo
pnpm add @langchain/community

```

```codeBlockLines_AdAo
import { FaissStore } from "@langchain/community/vectorstores/faiss";

const vectorStore = new FaissStore(embeddings, {});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/mongodb

```

```codeBlockLines_AdAo
yarn add @langchain/mongodb

```

```codeBlockLines_AdAo
pnpm add @langchain/mongodb

```

```codeBlockLines_AdAo
import { MongoDBAtlasVectorSearch } from "@langchain/mongodb"
import { MongoClient } from "mongodb";

const client = new MongoClient(process.env.MONGODB_ATLAS_URI || "");
const collection = client
  .db(process.env.MONGODB_ATLAS_DB_NAME)
  .collection(process.env.MONGODB_ATLAS_COLLECTION_NAME);

const vectorStore = new MongoDBAtlasVectorSearch(embeddings, {
  collection: collection,
  indexName: "vector_index",
  textKey: "text",
  embeddingKey: "embedding",
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/community

```

```codeBlockLines_AdAo
yarn add @langchain/community

```

```codeBlockLines_AdAo
pnpm add @langchain/community

```

```codeBlockLines_AdAo
import { PGVectorStore } from "@langchain/community/vectorstores/pgvector";

const vectorStore = await PGVectorStore.initialize(embeddings, {})

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/pinecone

```

```codeBlockLines_AdAo
yarn add @langchain/pinecone

```

```codeBlockLines_AdAo
pnpm add @langchain/pinecone

```

```codeBlockLines_AdAo
import { PineconeStore } from "@langchain/pinecone";
import { Pinecone as PineconeClient } from "@pinecone-database/pinecone";

const pinecone = new PineconeClient();
const vectorStore = new PineconeStore(embeddings, {
  pineconeIndex,
  maxConcurrency: 5,
});

```

#### Install dependencies

- npm
- yarn
- pnpm

```codeBlockLines_AdAo
npm i @langchain/qdrant

```

```codeBlockLines_AdAo
yarn add @langchain/qdrant

```

```codeBlockLines_AdAo
pnpm add @langchain/qdrant

```

```codeBlockLines_AdAo
import { QdrantVectorStore } from "@langchain/qdrant";

const vectorStore = await QdrantVectorStore.fromExistingCollection(embeddings, {
  url: process.env.QDRANT_URL,
  collectionName: "langchainjs-testing",
});

```

## Preview [​](https://js.langchain.com/docs/tutorials/rag/\#preview "Direct link to Preview")

In this guide we’ll build an app that answers questions about the
website’s content. The specific website we will use is the [LLM Powered\\
Autonomous Agents](https://lilianweng.github.io/posts/2023-06-23-agent/)
blog post by Lilian Weng, which allows us to ask questions about the
contents of the post.

We can create a simple indexing pipeline and RAG chain to do this in ~50
lines of code.

```codeBlockLines_AdAo
import "cheerio";
import { CheerioWebBaseLoader } from "@langchain/community/document_loaders/web/cheerio";
import { Document } from "@langchain/core/documents";
import { ChatPromptTemplate } from "@langchain/core/prompts";
import { pull } from "langchain/hub";
import { Annotation, StateGraph } from "@langchain/langgraph";
import { RecursiveCharacterTextSplitter } from "@langchain/textsplitters";

// Load and chunk contents of blog
const pTagSelector = "p";
const cheerioLoader = new CheerioWebBaseLoader(
  "https://lilianweng.github.io/posts/2023-06-23-agent/",
  {
    selector: pTagSelector
  }
);

const docs = await cheerioLoader.load();

const splitter = new RecursiveCharacterTextSplitter({
  chunkSize: 1000, chunkOverlap: 200
});
const allSplits = await splitter.splitDocuments(docs);

// Index chunks
await vectorStore.addDocuments(allSplits)

// Define prompt for question-answering
const promptTemplate = await pull<ChatPromptTemplate>("rlm/rag-prompt");

// Define state for application
const InputStateAnnotation = Annotation.Root({
  question: Annotation<string>,
});

const StateAnnotation = Annotation.Root({
  question: Annotation<string>,
  context: Annotation<Document[]>,
  answer: Annotation<string>,
});

// Define application steps
const retrieve = async (state: typeof InputStateAnnotation.State) => {
  const retrievedDocs = await vectorStore.similaritySearch(state.question)
  return { context: retrievedDocs };
};

const generate = async (state: typeof StateAnnotation.State) => {
  const docsContent = state.context.map(doc => doc.pageContent).join("\n");
  const messages = await promptTemplate.invoke({ question: state.question, context: docsContent });
  const response = await llm.invoke(messages);
  return { answer: response.content };
};

// Compile application and test
const graph = new StateGraph(StateAnnotation)
  .addNode("retrieve", retrieve)
  .addNode("generate", generate)
  .addEdge("__start__", "retrieve")
  .addEdge("retrieve", "generate")
  .addEdge("generate", "__end__")
  .compile();

```

```codeBlockLines_AdAo
let inputs = { question: "What is Task Decomposition?" };

const result = await graph.invoke(inputs);
console.log(result.answer);

```

```codeBlockLines_AdAo
Task decomposition is the process of breaking down complex tasks into smaller, more manageable steps. This can be achieved through various methods, including prompting large language models (LLMs) or using task-specific instructions. Techniques like Chain of Thought (CoT) and Tree of Thoughts further enhance this process by structuring reasoning and exploring multiple possibilities at each step.

```

Check out the [LangSmith\\
trace](https://smith.langchain.com/public/84a36239-b466-41bd-ac84-befc33ab50df/r).

## Detailed walkthrough [​](https://js.langchain.com/docs/tutorials/rag/\#detailed-walkthrough "Direct link to Detailed walkthrough")

Let’s go through the above code step-by-step to really understand what’s
going on.

## 1\. Indexing [​](https://js.langchain.com/docs/tutorials/rag/\#indexing "Direct link to 1. Indexing")

note

This section is an abbreviated version of the content in the [semantic search tutorial](https://js.langchain.com/docs/tutorials/retrievers).
If you're comfortable with [document loaders](https://js.langchain.com/docs/concepts/document_loaders), [embeddings](https://js.langchain.com/docs/concepts/embedding_models), and [vector stores](https://js.langchain.com/docs/concepts/vectorstores),
feel free to skip to the next section on [retrieval and generation](https://js.langchain.com/docs/tutorials/rag/#orchestration).

### Loading documents [​](https://js.langchain.com/docs/tutorials/rag/\#loading-documents "Direct link to Loading documents")

We need to first load the blog post contents. We can use
[DocumentLoaders](https://js.langchain.com/docs/concepts/document_loaders) for this, which are
objects that load in data from a source and return a list of
[Documents](https://api.js.langchain.com/classes/langchain_core.documents.Document.html).
A Document is an object with some pageContent ( `string`) and metadata
( `Record<string, any>`).

In this case we’ll use the
[CheerioWebBaseLoader](https://api.js.langchain.com/classes/langchain.document_loaders_web_cheerio.CheerioWebBaseLoader.html),
which uses cheerio to load HTML form web URLs and parse it to text. We
can pass custom selectors to the constructor to only parse specific
elements:

```codeBlockLines_AdAo
import "cheerio";
import { CheerioWebBaseLoader } from "@langchain/community/document_loaders/web/cheerio";

const pTagSelector = "p";
const cheerioLoader = new CheerioWebBaseLoader(
  "https://lilianweng.github.io/posts/2023-06-23-agent/",
  {
    selector: pTagSelector,
  }
);

const docs = await cheerioLoader.load();

console.assert(docs.length === 1);
console.log(`Total characters: ${docs[0].pageContent.length}`);

```

```codeBlockLines_AdAo
Total characters: 22360

```

```codeBlockLines_AdAo
console.log(docs[0].pageContent.slice(0, 500));

```

```codeBlockLines_AdAo
Building agents with LLM (large language model) as its core controller is a cool concept. Several proof-of-concepts demos, such as AutoGPT, GPT-Engineer and BabyAGI, serve as inspiring examples. The potentiality of LLM extends beyond generating well-written copies, stories, essays and programs; it can be framed as a powerful general problem solver.In a LLM-powered autonomous agent system, LLM functions as the agent’s brain, complemented by several key components:A complicated task usually involv

```

#### Go deeper [​](https://js.langchain.com/docs/tutorials/rag/\#go-deeper "Direct link to Go deeper")

`DocumentLoader`: Class that loads data from a source as list of
Documents.

- [Docs](https://js.langchain.com/docs/concepts/document_loaders): Detailed documentation on
how to use
- [Integrations](https://js.langchain.com/docs/integrations/document_loaders/)
- [Interface](https://api.js.langchain.com/classes/langchain.document_loaders_base.BaseDocumentLoader.html):
API reference for the base interface.

### Splitting documents [​](https://js.langchain.com/docs/tutorials/rag/\#splitting-documents "Direct link to Splitting documents")

Our loaded document is over 42k characters which is too long to fit into
the context window of many models. Even for those models that could fit
the full post in their context window, models can struggle to find
information in very long inputs.

To handle this we’ll split the `Document` into chunks for embedding and
vector storage. This should help us retrieve only the most relevant
parts of the blog post at run time.

As in the [semantic search tutorial](https://js.langchain.com/docs/tutorials/retrievers), we use
a
[RecursiveCharacterTextSplitter](https://js.langchain.com/docs/how_to/recursive_text_splitter),
which will recursively split the document using common separators like
new lines until each chunk is the appropriate size. This is the
recommended text splitter for generic text use cases.

```codeBlockLines_AdAo
import { RecursiveCharacterTextSplitter } from "@langchain/textsplitters";

const splitter = new RecursiveCharacterTextSplitter({
  chunkSize: 1000,
  chunkOverlap: 200,
});
const allSplits = await splitter.splitDocuments(docs);
console.log(`Split blog post into ${allSplits.length} sub-documents.`);

```

```codeBlockLines_AdAo
Split blog post into 29 sub-documents.

```

#### Go deeper [​](https://js.langchain.com/docs/tutorials/rag/\#go-deeper-1 "Direct link to Go deeper")

`TextSplitter`: Object that splits a list of `Document` s into smaller
chunks. Subclass of `DocumentTransformers`. \- Explore
`Context-aware splitters`, which keep the location (“context”) of each
split in the original `Document`: \- [Markdown\\
files](https://js.langchain.com/docs/how_to/code_splitter/#markdown) -
[Code](https://js.langchain.com/docs/how_to/code_splitter/) (15+ langs) -
[Interface](https://api.js.langchain.com/classes/langchain_textsplitters.TextSplitter.html):
API reference for the base interface.

`DocumentTransformer`: Object that performs a transformation on a list
of `Document` s. - Docs: Detailed documentation on how to use
`DocumentTransformer` s -
[Integrations](https://js.langchain.com/docs/integrations/document_transformers) -
[Interface](https://api.js.langchain.com/classes/langchain_core.documents.BaseDocumentTransformer.html):
API reference for the base interface.

### Storing documents [​](https://js.langchain.com/docs/tutorials/rag/\#storing-documents "Direct link to Storing documents")

Now we need to index our 66 text chunks so that we can search over them
at runtime. Following the [semantic search\\
tutorial](https://js.langchain.com/docs/tutorials/retrievers), our approach is to
[embed](https://js.langchain.com/docs/concepts/embedding_models/) the contents of each document
split and insert these embeddings into a [vector\\
store](https://js.langchain.com/docs/concepts/vectorstores/). Given an input query, we can then
use vector search to retrieve relevant documents.

We can embed and store all of our document splits in a single command
using the vector store and embeddings model selected at the [start of\\
the tutorial](https://js.langchain.com/docs/tutorials/rag/#components).

```codeBlockLines_AdAo
await vectorStore.addDocuments(allSplits);

```

#### Go deeper [​](https://js.langchain.com/docs/tutorials/rag/\#go-deeper-2 "Direct link to Go deeper")

`Embeddings`: Wrapper around a text embedding model, used for converting
text to embeddings. - [Docs](https://js.langchain.com/docs/concepts/embedding_models): Detailed
documentation on how to use embeddings. -
[Integrations](https://js.langchain.com/docs/integrations/text_embedding): 30+ integrations to
choose from. -
[Interface](https://api.js.langchain.com/classes/langchain_core.embeddings.Embeddings.html):
API reference for the base interface.

`VectorStore`: Wrapper around a vector database, used for storing and
querying embeddings. - [Docs](https://js.langchain.com/docs/concepts/vectorstores): Detailed
documentation on how to use vector stores. -
[Integrations](https://js.langchain.com/docs/integrations/vectorstores): 40+ integrations to
choose from. -
[Interface](https://api.js.langchain.com/classes/langchain_core.vectorstores.VectorStore.html):
API reference for the base interface.

This completes the **Indexing** portion of the pipeline. At this point
we have a query-able vector store containing the chunked contents of our
blog post. Given a user question, we should ideally be able to return
the snippets of the blog post that answer the question.

## 2\. Retrieval and Generation [​](https://js.langchain.com/docs/tutorials/rag/\#orchestration "Direct link to 2. Retrieval and Generation")

Now let’s write the actual application logic. We want to create a simple
application that takes a user question, searches for documents relevant
to that question, passes the retrieved documents and initial question to
a model, and returns an answer.

For generation, we will use the chat model selected at the [start of the\\
tutorial](https://js.langchain.com/docs/tutorials/rag/#components).

We’ll use a prompt for RAG that is checked into the LangChain prompt hub
( [here](https://smith.langchain.com/hub/rlm/rag-prompt)).

```codeBlockLines_AdAo
import { pull } from "langchain/hub";
import { ChatPromptTemplate } from "@langchain/core/prompts";

const promptTemplate = await pull<ChatPromptTemplate>("rlm/rag-prompt");

// Example:
const example_prompt = await promptTemplate.invoke({
  context: "(context goes here)",
  question: "(question goes here)",
});
const example_messages = example_prompt.messages;

console.assert(example_messages.length === 1);
example_messages[0].content;

```

```codeBlockLines_AdAo
You are an assistant for question-answering tasks. Use the following pieces of retrieved context to answer the question. If you don't know the answer, just say that you don't know. Use three sentences maximum and keep the answer concise.
Question: (question goes here)
Context: (context goes here)
Answer:

```

We’ll use [LangGraph](https://langchain-ai.github.io/langgraphjs/) to
tie together the retrieval and generation steps into a single
application. This will bring a number of benefits:

- We can define our application logic once and automatically support
multiple invocation modes, including streaming, async, and batched
calls.
- We get streamlined deployments via [LangGraph\\
Platform](https://langchain-ai.github.io/langgraphjs/concepts/langgraph_platform/).
- LangSmith will automatically trace the steps of our application
together.
- We can easily add key features to our application, including
[persistence](https://langchain-ai.github.io/langgraphjs/concepts/persistence/)
and [human-in-the-loop\\
approval](https://langchain-ai.github.io/langgraphjs/concepts/human_in_the_loop/),
with minimal code changes.

To use LangGraph, we need to define three things:

1. The state of our application;
2. The nodes of our application (i.e., application steps);
3. The “control flow” of our application (e.g., the ordering of the
steps).

#### State: [​](https://js.langchain.com/docs/tutorials/rag/\#state "Direct link to State:")

The
[state](https://langchain-ai.github.io/langgraphjs/concepts/low_level/#state)
of our application controls what data is input to the application,
transferred between steps, and output by the application.

For a simple RAG application, we can just keep track of the input
question, retrieved context, and generated answer.

Read more about defining graph states
[here](https://langchain-ai.github.io/langgraphjs/how-tos/define-state/).

```codeBlockLines_AdAo
import { Document } from "@langchain/core/documents";
import { Annotation } from "@langchain/langgraph";

const InputStateAnnotation = Annotation.Root({
  question: Annotation<string>,
});

const StateAnnotation = Annotation.Root({
  question: Annotation<string>,
  context: Annotation<Document[]>,
  answer: Annotation<string>,
});

```

#### Nodes (application steps) [​](https://js.langchain.com/docs/tutorials/rag/\#nodes-application-steps "Direct link to Nodes (application steps)")

Let’s start with a simple sequence of two steps: retrieval and
generation.

```codeBlockLines_AdAo
import { concat } from "@langchain/core/utils/stream";

const retrieve = async (state: typeof InputStateAnnotation.State) => {
  const retrievedDocs = await vectorStore.similaritySearch(state.question);
  return { context: retrievedDocs };
};

const generate = async (state: typeof StateAnnotation.State) => {
  const docsContent = state.context.map((doc) => doc.pageContent).join("\n");
  const messages = await promptTemplate.invoke({
    question: state.question,
    context: docsContent,
  });
  const response = await llm.invoke(messages);
  return { answer: response.content };
};

```

Our retrieval step simply runs a similarity search using the input
question, and the generation step formats the retrieved context and
original question into a prompt for the chat model.

#### Control flow [​](https://js.langchain.com/docs/tutorials/rag/\#control-flow "Direct link to Control flow")

Finally, we compile our application into a single `graph` object. In
this case, we are just connecting the retrieval and generation steps
into a single sequence.

```codeBlockLines_AdAo
import { StateGraph } from "@langchain/langgraph";

const graph = new StateGraph(StateAnnotation)
  .addNode("retrieve", retrieve)
  .addNode("generate", generate)
  .addEdge("__start__", "retrieve")
  .addEdge("retrieve", "generate")
  .addEdge("generate", "__end__")
  .compile();

```

LangGraph also comes with built-in utilities for visualizing the control
flow of your application:

```codeBlockLines_AdAo
// Note: tslab only works inside a jupyter notebook. Don't worry about running this code yourself!
import * as tslab from "tslab";

const image = await graph.getGraph().drawMermaidPng();
const arrayBuffer = await image.arrayBuffer();

await tslab.display.png(new Uint8Array(arrayBuffer));

```

![graph_img_rag](<Base64-Image-Removed>)

Do I need to use LangGraph?

LangGraph is not required to build a RAG application. Indeed, we can
implement the same application logic through invocations of the
individual components:

```codeBlockLines_AdAo
let question = "...";

const retrievedDocs = await vectorStore.similaritySearch(question);
const docsContent = retrievedDocs.map((doc) => doc.pageContent).join("\n");
const messages = await promptTemplate.invoke({
  question: question,
  context: docsContent,
});
const answer = await llm.invoke(messages);

```

The benefits of LangGraph include:

- Support for multiple invocation modes: this logic would need to be
rewritten if we wanted to stream output tokens, or stream the
results of individual steps;
- Automatic support for tracing via
[LangSmith](https://docs.smith.langchain.com/) and deployments via
[LangGraph\\
Platform](https://langchain-ai.github.io/langgraphjs/concepts/langgraph_platform/);
- Support for persistence, human-in-the-loop, and other features.

Many use-cases demand RAG in a conversational experience, such that a
user can receive context-informed answers via a stateful conversation.
As we will see in [Part 2](https://js.langchain.com/docs/tutorials/qa_chat_history) of the
tutorial, LangGraph’s management and persistence of state simplifies
these applications enormously.

#### Usage [​](https://js.langchain.com/docs/tutorials/rag/\#usage "Direct link to Usage")

Let’s test our application! LangGraph supports multiple invocation
modes, including sync, async, and streaming.

Invoke:

```codeBlockLines_AdAo
let inputs = { question: "What is Task Decomposition?" };

const result = await graph.invoke(inputs);
console.log(result.context.slice(0, 2));
console.log(`\nAnswer: ${result["answer"]}`);

```

```codeBlockLines_AdAo
[\
  Document {\
    pageContent: 'hard tasks into smaller and simpler steps. CoT transforms big tasks into multiple manageable tasks and shed lights into an interpretation of the model’s thinking process.Tree of Thoughts (Yao et al. 2023) extends CoT by exploring multiple reasoning possibilities at each step. It first decomposes the problem into multiple thought steps and generates multiple thoughts per step, creating a tree structure. The search process can be BFS (breadth-first search) or DFS (depth-first search) with each state evaluated by a classifier (via a prompt) or majority vote.Task decomposition can be done (1) by LLM with simple prompting like "Steps for XYZ.\\n1.", "What are the subgoals for achieving XYZ?", (2) by using task-specific instructions; e.g. "Write a story outline." for writing a novel, or (3) with human inputs.Another quite distinct approach, LLM+P (Liu et al. 2023), involves relying on an external classical planner to do long-horizon planning. This approach utilizes the Planning Domain',\
    metadata: {\
      source: 'https://lilianweng.github.io/posts/2023-06-23-agent/',\
      loc: [Object]\
    },\
    id: undefined\
  },\
  Document {\
    pageContent: 'Building agents with LLM (large language model) as its core controller is a cool concept. Several proof-of-concepts demos, such as AutoGPT, GPT-Engineer and BabyAGI, serve as inspiring examples. The potentiality of LLM extends beyond generating well-written copies, stories, essays and programs; it can be framed as a powerful general problem solver.In a LLM-powered autonomous agent system, LLM functions as the agent’s brain, complemented by several key components:A complicated task usually involves many steps. An agent needs to know what they are and plan ahead.Chain of thought (CoT; Wei et al. 2022) has become a standard prompting technique for enhancing model performance on complex tasks. The model is instructed to “think step by step” to utilize more test-time computation to decompose hard tasks into smaller and simpler steps. CoT transforms big tasks into multiple manageable tasks and shed lights into an interpretation of the model’s thinking process.Tree of Thoughts (Yao et al.',\
    metadata: {\
      source: 'https://lilianweng.github.io/posts/2023-06-23-agent/',\
      loc: [Object]\
    },\
    id: undefined\
  }\
]

Answer: Task decomposition is the process of breaking down complex tasks into smaller, more manageable steps. This can be achieved through various methods, including prompting large language models (LLMs) to outline steps or using task-specific instructions. Techniques like Chain of Thought (CoT) and Tree of Thoughts further enhance this process by structuring reasoning and exploring multiple possibilities at each step.

```

Stream steps:

```codeBlockLines_AdAo
console.log(inputs);
console.log("\n====\n");
for await (const chunk of await graph.stream(inputs, {
  streamMode: "updates",
})) {
  console.log(chunk);
  console.log("\n====\n");
}

```

```codeBlockLines_AdAo
{ question: 'What is Task Decomposition?' }

====

{
  retrieve: { context: [ [Document], [Document], [Document], [Document] ] }
}

====

{
  generate: {
    answer: 'Task decomposition is the process of breaking down complex tasks into smaller, more manageable steps. This can be achieved through various methods, including prompting large language models (LLMs) or using task-specific instructions. Techniques like Chain of Thought (CoT) and Tree of Thoughts further enhance this process by structuring reasoning and exploring multiple possibilities at each step.'
  }
}

====

```

Stream [tokens](https://js.langchain.com/docs/concepts/tokens/) (requires `@langchain/core` >=
0.3.24 and `@langchain/langgraph` >= 0.2.34 with above implementation):

```codeBlockLines_AdAo
const stream = await graph.stream(inputs, { streamMode: "messages" });

for await (const [message, _metadata] of stream) {
  process.stdout.write(message.content + "|");
}

```

```codeBlockLines_AdAo
|Task| decomposition| is| the| process| of| breaking| down| complex| tasks| into| smaller|,| more| manageable| steps|.| This| can| be| achieved| through| various| methods|,| including| prompting| large| language| models| (|LL|Ms|)| to| outline| steps| or| using| task|-specific| instructions|.| Techniques| like| Chain| of| Thought| (|Co|T|)| and| Tree| of| Thoughts| further| enhance| this| process| by| struct|uring| reasoning| and| exploring| multiple| possibilities| at| each| step|.||

```

note

Streaming tokens with the current implementation, using `.invoke` in the `generate` step, requires `@langchain/core` >= 0.3.24 and `@langchain/langgraph` >= 0.2.34. See details [here](https://langchain-ai.github.io/langgraphjs/how-tos/stream-tokens/).

#### Returning sources [​](https://js.langchain.com/docs/tutorials/rag/\#returning-sources "Direct link to Returning sources")

Note that by storing the retrieved context in the state of the graph, we
recover sources for the model’s generated answer in the `"context"`
field of the state. See [this guide](https://js.langchain.com/docs/how_to/qa_sources/) on
returning sources for more detail.

#### Go deeper [​](https://js.langchain.com/docs/tutorials/rag/\#go-deeper-3 "Direct link to Go deeper")

[Chat models](https://js.langchain.com/docs/concepts/chat_models) take in a sequence of messages
and return a message.

- [Docs](https://js.langchain.com/docs/how_to#chat-models)
- [Integrations](https://js.langchain.com/docs/integrations/chat/): 25+ integrations to choose
from.

**Customizing the prompt**

As shown above, we can load prompts (e.g., [this RAG\\
prompt](https://smith.langchain.com/hub/rlm/rag-prompt)) from the prompt
hub. The prompt can also be easily customized. For example:

```codeBlockLines_AdAo
const template = `Use the following pieces of context to answer the question at the end.
If you don't know the answer, just say that you don't know, don't try to make up an answer.
Use three sentences maximum and keep the answer as concise as possible.
Always say "thanks for asking!" at the end of the answer.

{context}

Question: {question}

Helpful Answer:`;

const promptTemplateCustom = ChatPromptTemplate.fromMessages([\
  ["user", template],\
]);

```

## Query analysis [​](https://js.langchain.com/docs/tutorials/rag/\#query-analysis "Direct link to Query analysis")

So far, we are executing the retrieval using the raw input query.
However, there are some advantages to allowing a model to generate the
query for retrieval purposes. For example:

- In addition to semantic search, we can build in structured filters
(e.g., “Find documents since the year 2020.”);
- The model can rewrite user queries, which may be multifaceted or
include irrelevant language, into more effective search queries.

[Query analysis](https://js.langchain.com/docs/concepts/retrieval/#query-analysis) employs
models to transform or construct optimized search queries from raw user
input. We can easily incorporate a query analysis step into our
application. For illustrative purposes, let’s add some metadata to the
documents in our vector store. We will add some (contrived) sections to
the document which we can filter on later.

```codeBlockLines_AdAo
const totalDocuments = allSplits.length;
const third = Math.floor(totalDocuments / 3);

allSplits.forEach((document, i) => {
  if (i < third) {
    document.metadata["section"] = "beginning";
  } else if (i < 2 * third) {
    document.metadata["section"] = "middle";
  } else {
    document.metadata["section"] = "end";
  }
});

allSplits[0].metadata;

```

```codeBlockLines_AdAo
{
  source: 'https://lilianweng.github.io/posts/2023-06-23-agent/',
  loc: { lines: { from: 1, to: 1 } },
  section: 'beginning'
}

```

We will need to update the documents in our vector store. We will use a
simple
[MemoryVectorStore](https://api.js.langchain.com/classes/langchain.vectorstores_memory.MemoryVectorStore.html)
for this, as we will use some of its specific features (i.e., metadata
filtering). Refer to the vector store [integration\\
documentation](https://js.langchain.com/docs/integrations/vectorstores/) for relevant features
of your chosen vector store.

```codeBlockLines_AdAo
import { MemoryVectorStore } from "langchain/vectorstores/memory";

const vectorStoreQA = new MemoryVectorStore(embeddings);
await vectorStoreQA.addDocuments(allSplits);

```

Let’s next define a schema for our search query. We will use [structured\\
output](https://js.langchain.com/docs/concepts/structured_outputs/) for this purpose. Here we
define a query as containing a string query and a document section
(either “beginning”, “middle”, or “end”), but this can be defined
however you like.

```codeBlockLines_AdAo
import { z } from "zod";

const searchSchema = z.object({
  query: z.string().describe("Search query to run."),
  section: z.enum(["beginning", "middle", "end"]).describe("Section to query."),
});

const structuredLlm = llm.withStructuredOutput(searchSchema);

```

Finally, we add a step to our LangGraph application to generate a query
from the user’s raw input:

```codeBlockLines_AdAo
const StateAnnotationQA = Annotation.Root({
  question: Annotation<string>,
  search: Annotation<z.infer<typeof searchSchema>>,
  context: Annotation<Document[]>,
  answer: Annotation<string>,
});

const analyzeQuery = async (state: typeof InputStateAnnotation.State) => {
  const result = await structuredLlm.invoke(state.question);
  return { search: result };
};

const retrieveQA = async (state: typeof StateAnnotationQA.State) => {
  const filter = (doc) => doc.metadata.section === state.search.section;
  const retrievedDocs = await vectorStore.similaritySearch(
    state.search.query,
    2,
    filter
  );
  return { context: retrievedDocs };
};

const generateQA = async (state: typeof StateAnnotationQA.State) => {
  const docsContent = state.context.map((doc) => doc.pageContent).join("\n");
  const messages = await promptTemplate.invoke({
    question: state.question,
    context: docsContent,
  });
  const response = await llm.invoke(messages);
  return { answer: response.content };
};

const graphQA = new StateGraph(StateAnnotationQA)
  .addNode("analyzeQuery", analyzeQuery)
  .addNode("retrieveQA", retrieveQA)
  .addNode("generateQA", generateQA)
  .addEdge("__start__", "analyzeQuery")
  .addEdge("analyzeQuery", "retrieveQA")
  .addEdge("retrieveQA", "generateQA")
  .addEdge("generateQA", "__end__")
  .compile();

```

```codeBlockLines_AdAo
// Note: tslab only works inside a jupyter notebook. Don't worry about running this code yourself!
import * as tslab from "tslab";

const image = await graphQA.getGraph().drawMermaidPng();
const arrayBuffer = await image.arrayBuffer();

await tslab.display.png(new Uint8Array(arrayBuffer));

```

![graph_img_rag_qa](https://js.langchain.com/assets/images/graph_img_rag_qa-974636bca4635fc8cd3d168abf5c6966.png)

We can test our implementation by specifically asking for context from
the end of the post. Note that the model includes different information
in its answer.

```codeBlockLines_AdAo
let inputsQA = {
  question: "What does the end of the post say about Task Decomposition?",
};

console.log(inputsQA);
console.log("\n====\n");
for await (const chunk of await graphQA.stream(inputsQA, {
  streamMode: "updates",
})) {
  console.log(chunk);
  console.log("\n====\n");
}

```

```codeBlockLines_AdAo
{
  question: 'What does the end of the post say about Task Decomposition?'
}

====

{
  analyzeQuery: { search: { query: 'Task Decomposition', section: 'end' } }
}

====

{ retrieveQA: { context: [ [Document], [Document] ] } }

====

{
  generateQA: {
    answer: 'The end of the post emphasizes the importance of task decomposition by outlining a structured approach to organizing code into separate files and functions. It highlights the need for clarity and compatibility among different components, ensuring that each part of the architecture is well-defined and functional. This methodical breakdown aids in maintaining best practices and enhances code readability and manageability.'
  }
}

====

```

In both the streamed steps and the [LangSmith\\
trace](https://smith.langchain.com/public/8ff4742c-a5d4-41b2-adf9-22915a876a30/r),
we can now observe the structured query that was fed into the retrieval
step.

Query Analysis is a rich problem with a wide range of approaches. Refer
to the [how-to guides](https://js.langchain.com/docs/how_to/#query-analysis) for more examples.

## Next steps [​](https://js.langchain.com/docs/tutorials/rag/\#next-steps "Direct link to Next steps")

We’ve covered the steps to build a basic Q&A app over data:

- Loading data with a [Document\\
Loader](https://js.langchain.com/docs/concepts/document_loaders)
- Chunking the indexed data with a [Text\\
Splitter](https://js.langchain.com/docs/concepts/text_splitters) to make it more easily
usable by a model
- [Embedding the data](https://js.langchain.com/docs/concepts/embedding_models) and storing
the data in a [vectorstore](https://js.langchain.com/docs/how_to/vectorstores)
- [Retrieving](https://js.langchain.com/docs/concepts/retrievers) the previously stored chunks
in response to incoming questions
- Generating an answer using the retrieved chunks as context.

In [Part 2](https://js.langchain.com/docs/tutorials/qa_chat_history) of the tutorial, we will
extend the implementation here to accommodate conversation-style
interactions and multi-step retrieval processes.

Further reading:

- [Return sources](https://js.langchain.com/docs/how_to/qa_sources): Learn how to return
source documents
- [Streaming](https://js.langchain.com/docs/how_to/streaming): Learn how to stream outputs and
intermediate steps
- [Add chat history](https://js.langchain.com/docs/how_to/message_history): Learn how to add
chat history to your app
- [Retrieval conceptual guide](https://js.langchain.com/docs/concepts/retrieval): A high-level
overview of specific retrieval techniques

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/tutorials/rag/%3E).

- [Overview](https://js.langchain.com/docs/tutorials/rag/#overview)
  - [Indexing](https://js.langchain.com/docs/tutorials/rag/#indexing)
  - [Retrieval and generation](https://js.langchain.com/docs/tutorials/rag/#retrieval-and-generation)
- [Setup](https://js.langchain.com/docs/tutorials/rag/#setup)
  - [Jupyter Notebook](https://js.langchain.com/docs/tutorials/rag/#jupyter-notebook)
  - [Installation](https://js.langchain.com/docs/tutorials/rag/#installation)
  - [LangSmith](https://js.langchain.com/docs/tutorials/rag/#langsmith)
- [Components](https://js.langchain.com/docs/tutorials/rag/#components)
- [Preview](https://js.langchain.com/docs/tutorials/rag/#preview)
- [Detailed walkthrough](https://js.langchain.com/docs/tutorials/rag/#detailed-walkthrough)
- [1\. Indexing](https://js.langchain.com/docs/tutorials/rag/#indexing)
  - [Loading documents](https://js.langchain.com/docs/tutorials/rag/#loading-documents)
  - [Splitting documents](https://js.langchain.com/docs/tutorials/rag/#splitting-documents)
  - [Storing documents](https://js.langchain.com/docs/tutorials/rag/#storing-documents)
- [2\. Retrieval and Generation](https://js.langchain.com/docs/tutorials/rag/#orchestration)
- [Query analysis](https://js.langchain.com/docs/tutorials/rag/#query-analysis)
- [Next steps](https://js.langchain.com/docs/tutorials/rag/#next-steps)

