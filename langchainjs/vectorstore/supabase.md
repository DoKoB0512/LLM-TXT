[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/supabase/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

[Supabase](https://supabase.com/docs) is an open-source Firebase
alternative. Supabase is built on top of PostgreSQL, which offers strong
SQL querying capabilities and enables a simple interface with
already-existing tools and frameworks.

LangChain.js supports using a Supabase Postgres database as a vector
store, using the [`pgvector`](https://github.com/pgvector/pgvector)
extension. Refer to the [Supabase blog\\
post](https://supabase.com/blog/openai-embeddings-postgres-vector) for
more information.

This guide provides a quick overview for getting started with Supabase
[vector stores](https://js.langchain.com/docs/concepts/#vectorstores). For detailed
documentation of all `SupabaseVectorStore` features and configurations
head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_supabase.SupabaseVectorStore.html).

## Overview [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#overview "Direct link to Overview")

### Integration details [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#integration-details "Direct link to Integration details")

| Class | Package | [PY support](https://python.langchain.com/docs/integrations/vectorstores/supabase/) | Package latest |
| :-- | :-- | :-: | :-: |
| [`SupabaseVectorStore`](https://api.js.langchain.com/classes/langchain_community_vectorstores_supabase.SupabaseVectorStore.html) | [`@langchain/community`](https://npmjs.com/@langchain/community) | ✅ | ![NPM - Version](https://img.shields.io/npm/v/@langchain/community?style=flat-square&label=%20&.png) |

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#setup "Direct link to Setup")

To use Supabase vector stores, you’ll need to set up a Supabase database
and install the `@langchain/community` integration package. You’ll also
need to install the official
[`@supabase/supabase-js`](https://www.npmjs.com/package/@supabase/supabase-js)
SDK as a peer dependency.

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
npm i @langchain/community @langchain/core @supabase/supabase-js @langchain/openai

```

```codeBlockLines_AdAo
yarn add @langchain/community @langchain/core @supabase/supabase-js @langchain/openai

```

```codeBlockLines_AdAo
pnpm add @langchain/community @langchain/core @supabase/supabase-js @langchain/openai

```

Once you’ve created a database, run the following SQL to set up
[`pgvector`](https://github.com/pgvector/pgvector) and create the
necessary table and functions:

```codeBlockLines_AdAo
-- Enable the pgvector extension to work with embedding vectors
create extension vector;

-- Create a table to store your documents
create table documents (
  id bigserial primary key,
  content text, -- corresponds to Document.pageContent
  metadata jsonb, -- corresponds to Document.metadata
  embedding vector(1536) -- 1536 works for OpenAI embeddings, change if needed
);

-- Create a function to search for documents
create function match_documents (
  query_embedding vector(1536),
  match_count int DEFAULT null,
  filter jsonb DEFAULT '{}'
) returns table (
  id bigint,
  content text,
  metadata jsonb,
  embedding jsonb,
  similarity float
)
language plpgsql
as $$
#variable_conflict use_column
begin
  return query
  select
    id,
    content,
    metadata,
    (embedding::text)::jsonb as embedding,
    1 - (documents.embedding <=> query_embedding) as similarity
  from documents
  where metadata @> filter
  order by documents.embedding <=> query_embedding
  limit match_count;
end;
$$;

```

### Credentials [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#credentials "Direct link to Credentials")

Once you’ve done this set the `SUPABASE_PRIVATE_KEY` and `SUPABASE_URL`
environment variables:

```codeBlockLines_AdAo
process.env.SUPABASE_PRIVATE_KEY = "your-api-key";
process.env.SUPABASE_URL = "your-supabase-db-url";

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
// process.env.LANGSMITH_TRACING="true"
// process.env.LANGSMITH_API_KEY="your-api-key"

```

## Instantiation [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#instantiation "Direct link to Instantiation")

```codeBlockLines_AdAo
import { SupabaseVectorStore } from "@langchain/community/vectorstores/supabase";
import { OpenAIEmbeddings } from "@langchain/openai";

import { createClient } from "@supabase/supabase-js";

const embeddings = new OpenAIEmbeddings({
  model: "text-embedding-3-small",
});

const supabaseClient = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_PRIVATE_KEY
);

const vectorStore = new SupabaseVectorStore(embeddings, {
  client: supabaseClient,
  tableName: "documents",
  queryName: "match_documents",
});

```

## Manage vector store [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#manage-vector-store "Direct link to Manage vector store")

### Add items to vector store [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#add-items-to-vector-store "Direct link to Add items to vector store")

```codeBlockLines_AdAo
import type { Document } from "@langchain/core/documents";

const document1: Document = {
  pageContent: "The powerhouse of the cell is the mitochondria",
  metadata: { source: "https://example.com" },
};

const document2: Document = {
  pageContent: "Buildings are made out of brick",
  metadata: { source: "https://example.com" },
};

const document3: Document = {
  pageContent: "Mitochondria are made out of lipids",
  metadata: { source: "https://example.com" },
};

const document4: Document = {
  pageContent: "The 2024 Olympics are in Paris",
  metadata: { source: "https://example.com" },
};

const documents = [document1, document2, document3, document4];

await vectorStore.addDocuments(documents, { ids: ["1", "2", "3", "4"] });

```

```codeBlockLines_AdAo
[ 1, 2, 3, 4 ]

```

### Delete items from vector store [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#delete-items-from-vector-store "Direct link to Delete items from vector store")

```codeBlockLines_AdAo
await vectorStore.delete({ ids: ["4"] });

```

## Query vector store [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#query-vector-store "Direct link to Query vector store")

Once your vector store has been created and the relevant documents have
been added you will most likely wish to query it during the running of
your chain or agent.

### Query directly [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#query-directly "Direct link to Query directly")

Performing a simple similarity search can be done as follows:

```codeBlockLines_AdAo
const filter = { source: "https://example.com" };

const similaritySearchResults = await vectorStore.similaritySearch(
  "biology",
  2,
  filter
);

for (const doc of similaritySearchResults) {
  console.log(`* ${doc.pageContent} [${JSON.stringify(doc.metadata, null)}]`);
}

```

```codeBlockLines_AdAo
* The powerhouse of the cell is the mitochondria [{"source":"https://example.com"}]
* Mitochondria are made out of lipids [{"source":"https://example.com"}]

```

If you want to execute a similarity search and receive the corresponding
scores you can run:

```codeBlockLines_AdAo
const similaritySearchWithScoreResults =
  await vectorStore.similaritySearchWithScore("biology", 2, filter);

for (const [doc, score] of similaritySearchWithScoreResults) {
  console.log(
    `* [SIM=${score.toFixed(3)}] ${doc.pageContent} [${JSON.stringify(\
      doc.metadata\
    )}]`
  );
}

```

```codeBlockLines_AdAo
* [SIM=0.165] The powerhouse of the cell is the mitochondria [{"source":"https://example.com"}]
* [SIM=0.148] Mitochondria are made out of lipids [{"source":"https://example.com"}]

```

### Metadata Query Builder Filtering [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#metadata-query-builder-filtering "Direct link to Metadata Query Builder Filtering")

You can also use query builder-style filtering similar to how the
[Supabase JavaScript\\
library](https://supabase.com/docs/reference/javascript/using-filters)
works instead of passing an object. Note that since most of the filter
properties are in the metadata column, you need to use arrow operators
(-> for integer or ->> for text) as defined in [Postgrest API\\
documentation](https://postgrest.org/en/stable/references/api/tables_views.html#json-columns)
and specify the data type of the property (e.g. the column should look
something like `metadata->some_int_prop_name::int`).

```codeBlockLines_AdAo
import { SupabaseFilterRPCCall } from "@langchain/community/vectorstores/supabase";

const funcFilter: SupabaseFilterRPCCall = (rpc) =>
  rpc.filter("metadata->>source", "eq", "https://example.com");

const funcFilterSearchResults = await vectorStore.similaritySearch(
  "biology",
  2,
  funcFilter
);

for (const doc of funcFilterSearchResults) {
  console.log(`* ${doc.pageContent} [${JSON.stringify(doc.metadata, null)}]`);
}

```

```codeBlockLines_AdAo
* The powerhouse of the cell is the mitochondria [{"source":"https://example.com"}]
* Mitochondria are made out of lipids [{"source":"https://example.com"}]

```

### Query by turning into retriever [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#query-by-turning-into-retriever "Direct link to Query by turning into retriever")

You can also transform the vector store into a
[retriever](https://js.langchain.com/docs/concepts/retrievers) for easier usage in your chains.

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
    pageContent: 'The powerhouse of the cell is the mitochondria',\
    metadata: { source: 'https://example.com' },\
    id: undefined\
  },\
  Document {\
    pageContent: 'Mitochondria are made out of lipids',\
    metadata: { source: 'https://example.com' },\
    id: undefined\
  }\
]

```

### Usage for retrieval-augmented generation [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#usage-for-retrieval-augmented-generation "Direct link to Usage for retrieval-augmented generation")

For guides on how to use this vector store for retrieval-augmented
generation (RAG), see the following sections:

- [Tutorials: working with external\\
knowledge](https://js.langchain.com/docs/tutorials/#working-with-external-knowledge).
- [How-to: Question and answer with RAG](https://js.langchain.com/docs/how_to/#qa-with-rag)
- [Retrieval conceptual docs](https://js.langchain.com/docs/concepts/retrieval)

## API reference [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#api-reference "Direct link to API reference")

For detailed documentation of all `SupabaseVectorStore` features and
configurations head to the [API\\
reference](https://api.js.langchain.com/classes/langchain_community_vectorstores_supabase.SupabaseVectorStore.html).

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/supabase/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/supabase/%3E).

- [Overview](https://js.langchain.com/docs/integrations/vectorstores/supabase/#overview)
  - [Integration details](https://js.langchain.com/docs/integrations/vectorstores/supabase/#integration-details)
- [Setup](https://js.langchain.com/docs/integrations/vectorstores/supabase/#setup)
  - [Credentials](https://js.langchain.com/docs/integrations/vectorstores/supabase/#credentials)
- [Instantiation](https://js.langchain.com/docs/integrations/vectorstores/supabase/#instantiation)
- [Manage vector store](https://js.langchain.com/docs/integrations/vectorstores/supabase/#manage-vector-store)
  - [Add items to vector store](https://js.langchain.com/docs/integrations/vectorstores/supabase/#add-items-to-vector-store)
  - [Delete items from vector store](https://js.langchain.com/docs/integrations/vectorstores/supabase/#delete-items-from-vector-store)
- [Query vector store](https://js.langchain.com/docs/integrations/vectorstores/supabase/#query-vector-store)
  - [Query directly](https://js.langchain.com/docs/integrations/vectorstores/supabase/#query-directly)
  - [Metadata Query Builder Filtering](https://js.langchain.com/docs/integrations/vectorstores/supabase/#metadata-query-builder-filtering)
  - [Query by turning into retriever](https://js.langchain.com/docs/integrations/vectorstores/supabase/#query-by-turning-into-retriever)
  - [Usage for retrieval-augmented generation](https://js.langchain.com/docs/integrations/vectorstores/supabase/#usage-for-retrieval-augmented-generation)
- [API reference](https://js.langchain.com/docs/integrations/vectorstores/supabase/#api-reference)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/supabase/#related)