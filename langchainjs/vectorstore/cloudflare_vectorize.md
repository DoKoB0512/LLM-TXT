[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/cloudflare_vectorize/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

# Cloudflare Vectorize

If you're deploying your project in a Cloudflare worker, you can use [Cloudflare Vectorize](https://developers.cloudflare.com/vectorize/) with LangChain.js.
It's a powerful and convenient option that's built directly into Cloudflare.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/cloudflare_vectorize/\#setup "Direct link to Setup")

Compatibility

Cloudflare Vectorize is currently in open beta, and requires a Cloudflare account on a paid plan to use.

After [setting up your project](https://developers.cloudflare.com/vectorize/get-started/intro/#prerequisites),
create an index by running the following Wrangler command:

```codeBlockLines_AdAo
$ npx wrangler vectorize create <index_name> --preset @cf/baai/bge-small-en-v1.5

```

You can see a full list of options for the `vectorize` command [in the official documentation](https://developers.cloudflare.com/workers/wrangler/commands/#vectorize).

You'll then need to update your `wrangler.toml` file to include an entry for `[[vectorize]]`:

```codeBlockLines_AdAo
[[vectorize]]
binding = "VECTORIZE_INDEX"
index_name = "<index_name>"

```

Finally, you'll need to install the LangChain Cloudflare integration package:

tip

See [this section for general instructions on installing integration packages](https://js.langchain.com/docs/how_to/installation#installing-integration-packages).

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @langchain/cloudflare @langchain/core

```

```codeBlockLines_AdAo
yarn add @langchain/cloudflare @langchain/core

```

```codeBlockLines_AdAo
pnpm add @langchain/cloudflare @langchain/core

```

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/cloudflare_vectorize/\#usage "Direct link to Usage")

Below is an example worker that adds documents to a vectorstore, queries it, or clears it depending on the path used. It also uses [Cloudflare Workers AI Embeddings](https://js.langchain.com/docs/integrations/text_embedding/cloudflare_ai).

note

If running locally, be sure to run wrangler as `npx wrangler dev --remote`!

```codeBlockLines_AdAo
name = "langchain-test"
main = "worker.ts"
compatibility_date = "2024-01-10"

[[vectorize]]
binding = "VECTORIZE_INDEX"
index_name = "langchain-test"

[ai]
binding = "AI"

```

```codeBlockLines_AdAo
// @ts-nocheck

import type {
  VectorizeIndex,
  Fetcher,
  Request,
} from "@cloudflare/workers-types";

import {
  CloudflareVectorizeStore,
  CloudflareWorkersAIEmbeddings,
} from "@langchain/cloudflare";

export interface Env {
  VECTORIZE_INDEX: VectorizeIndex;
  AI: Fetcher;
}

export default {
  async fetch(request: Request, env: Env) {
    const { pathname } = new URL(request.url);
    const embeddings = new CloudflareWorkersAIEmbeddings({
      binding: env.AI,
      model: "@cf/baai/bge-small-en-v1.5",
    });
    const store = new CloudflareVectorizeStore(embeddings, {
      index: env.VECTORIZE_INDEX,
    });
    if (pathname === "/") {
      const results = await store.similaritySearch("hello", 5);
      return Response.json(results);
    } else if (pathname === "/load") {
      // Upsertion by id is supported
      await store.addDocuments(
        [\
          {\
            pageContent: "hello",\
            metadata: {},\
          },\
          {\
            pageContent: "world",\
            metadata: {},\
          },\
          {\
            pageContent: "hi",\
            metadata: {},\
          },\
        ],
        { ids: ["id1", "id2", "id3"] }
      );

      return Response.json({ success: true });
    } else if (pathname === "/clear") {
      await store.delete({ ids: ["id1", "id2", "id3"] });
      return Response.json({ success: true });
    }

    return Response.json({ error: "Not Found" }, { status: 404 });
  },
};

```

#### API Reference:

- CloudflareVectorizeStorefrom `@langchain/cloudflare`
- CloudflareWorkersAIEmbeddingsfrom `@langchain/cloudflare`

You can also pass a `filter` parameter to filter by previously loaded metadata.
See [the official documentation](https://developers.cloudflare.com/vectorize/learning/metadata-filtering/)
for information on the required format.

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/cloudflare_vectorize/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/cloudflare_vectorize/%3E).