[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/convex/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Convex

LangChain.js supports [Convex](https://convex.dev/) as a [vector store](https://docs.convex.dev/vector-search), and supports the standard similarity search.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/convex/\#setup "Direct link to Setup")

### Create project [​](https://js.langchain.com/docs/integrations/vectorstores/convex/\#create-project "Direct link to Create project")

Get a working [Convex](https://docs.convex.dev/) project set up, for example by using:

```codeBlockLines_AdAo
npm create convex@latest

```

### Add database accessors [​](https://js.langchain.com/docs/integrations/vectorstores/convex/\#add-database-accessors "Direct link to Add database accessors")

Add query and mutation helpers to `convex/langchain/db.ts`:

convex/langchain/db.ts

```codeBlockLines_AdAo
export * from "@langchain/community/utils/convex";

```

### Configure your schema [​](https://js.langchain.com/docs/integrations/vectorstores/convex/\#configure-your-schema "Direct link to Configure your schema")

Set up your schema (for vector indexing):

convex/schema.ts

```codeBlockLines_AdAo
import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  documents: defineTable({
    embedding: v.array(v.number()),
    text: v.string(),
    metadata: v.any(),
  }).vectorIndex("byEmbedding", {
    vectorField: "embedding",
    dimensions: 1536,
  }),
});

```

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/convex/\#usage "Direct link to Usage")

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @langchain/openai @langchain/community @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/openai @langchain/community @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/openai @langchain/community @langchain/core

```

### Ingestion [​](https://js.langchain.com/docs/integrations/vectorstores/convex/\#ingestion "Direct link to Ingestion")

convex/myActions.ts

```codeBlockLines_AdAo
"use node";

import { ConvexVectorStore } from "@langchain/community/vectorstores/convex";
import { OpenAIEmbeddings } from "@langchain/openai";
import { action } from "./_generated/server.js";

export const ingest = action({
  args: {},
  handler: async (ctx) => {
    await ConvexVectorStore.fromTexts(
      ["Hello world", "Bye bye", "What's this?"],
      [{ prop: 2 }, { prop: 1 }, { prop: 3 }],
      new OpenAIEmbeddings(),
      { ctx }
    );
  },
});

```

#### API Reference:

- ConvexVectorStorefrom `@langchain/community/vectorstores/convex`
- OpenAIEmbeddingsfrom `@langchain/openai`

### Search [​](https://js.langchain.com/docs/integrations/vectorstores/convex/\#search "Direct link to Search")

convex/myActions.ts

```codeBlockLines_AdAo
"use node";

import { ConvexVectorStore } from "@langchain/community/vectorstores/convex";
import { OpenAIEmbeddings } from "@langchain/openai";
import { v } from "convex/values";
import { action } from "./_generated/server.js";

export const search = action({
  args: {
    query: v.string(),
  },
  handler: async (ctx, args) => {
    const vectorStore = new ConvexVectorStore(new OpenAIEmbeddings(), { ctx });

    const resultOne = await vectorStore.similaritySearch(args.query, 1);
    console.log(resultOne);
  },
});

```

#### API Reference:

- ConvexVectorStorefrom `@langchain/community/vectorstores/convex`
- OpenAIEmbeddingsfrom `@langchain/openai`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/convex/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/convex/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/convex/#setup)
  - [Create project](https://js.langchain.com/docs/integrations/vectorstores/convex/#create-project)
  - [Add database accessors](https://js.langchain.com/docs/integrations/vectorstores/convex/#add-database-accessors)
  - [Configure your schema](https://js.langchain.com/docs/integrations/vectorstores/convex/#configure-your-schema)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/convex/#usage)
  - [Ingestion](https://js.langchain.com/docs/integrations/vectorstores/convex/#ingestion)
  - [Search](https://js.langchain.com/docs/integrations/vectorstores/convex/#search)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/convex/#related)