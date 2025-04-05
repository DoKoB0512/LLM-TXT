[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/rockset/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Rockset

[Rockset](https://rockset.com/) is a real-time analyitics SQL database that runs in the cloud.
Rockset provides vector search capabilities, in the form of [SQL functions](https://rockset.com/docs/vector-functions/#vector-distance-functions), to support AI applications that rely on text similarity.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/rockset/\#setup "Direct link to Setup")

Install the rockset client.

```codeBlockLines_AdAo
yarn add @rockset/client

```

### Usage [​](https://js.langchain.com/docs/integrations/vectorstores/rockset/\#usage "Direct link to Usage")

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @langchain/openai @langchain/core @langchain/community

```

```codeBlockLines_AdAo
yarn add @langchain/openai @langchain/core @langchain/community

```

```codeBlockLines_AdAo
pnpm add @langchain/openai @langchain/core @langchain/community

```

Below is an example showcasing how to use OpenAI and Rockset to answer questions about a text file:

```codeBlockLines_AdAo
import * as rockset from "@rockset/client";
import { ChatOpenAI, OpenAIEmbeddings } from "@langchain/openai";
import { RocksetStore } from "@langchain/community/vectorstores/rockset";
import { RecursiveCharacterTextSplitter } from "@langchain/textsplitters";
import { readFileSync } from "fs";
import { ChatPromptTemplate } from "@langchain/core/prompts";
import { createStuffDocumentsChain } from "langchain/chains/combine_documents";
import { createRetrievalChain } from "langchain/chains/retrieval";

const store = await RocksetStore.withNewCollection(new OpenAIEmbeddings(), {
  client: rockset.default.default(
    process.env.ROCKSET_API_KEY ?? "",
    `https://api.${process.env.ROCKSET_API_REGION ?? "usw2a1"}.rockset.com`
  ),
  collectionName: "langchain_demo",
});

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

const text = readFileSync("state_of_the_union.txt", "utf8");
const docs = await new RecursiveCharacterTextSplitter().createDocuments([text]);

await store.addDocuments(docs);
const response = await chain.invoke({
  input: "When was America founded?",
});
console.log(response.answer);
await store.destroy();

```

#### API Reference:

- ChatOpenAIfrom `@langchain/openai`
- OpenAIEmbeddingsfrom `@langchain/openai`
- RocksetStorefrom `@langchain/community/vectorstores/rockset`
- RecursiveCharacterTextSplitterfrom `@langchain/textsplitters`
- ChatPromptTemplatefrom `@langchain/core/prompts`
- createStuffDocumentsChainfrom `langchain/chains/combine_documents`
- createRetrievalChainfrom `langchain/chains/retrieval`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/rockset/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/rockset/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/rockset/#setup)
  - [Usage](https://js.langchain.com/docs/integrations/vectorstores/rockset/#usage)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/rockset/#related)