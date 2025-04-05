[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# Google Vertex AI Matching Engine

Compatibility

Only available on Node.js.

The Google Vertex AI Matching Engine "provides the industry's leading high-scale
low latency vector database. These vector databases are commonly referred
to as vector similarity-matching or an approximate nearest neighbor (ANN) service."

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/\#setup "Direct link to Setup")

caution

This module expects an endpoint and deployed index already created as the
creation time takes close to one hour. To learn more, see the LangChain python
documentation [Create Index and deploy it to an Endpoint](https://python.langchain.com/docs/integrations/vectorstores/matchingengine#create-index-and-deploy-it-to-an-endpoint).

Before running this code, you should make sure the Vertex AI API is
enabled for the relevant project in your Google Cloud dashboard and that you've authenticated to
Google Cloud using one of these methods:

- You are logged into an account (using `gcloud auth application-default login`)
permitted to that project.
- You are running on a machine using a service account that is permitted
to the project.
- You have downloaded the credentials for a service account that is permitted
to the project and set the `GOOGLE_APPLICATION_CREDENTIALS` environment
variable to the path of this file.

Install the authentication library with:

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @langchain/community @langchain/core google-auth-library

```

```codeBlockLines_AdAo
yarn add @langchain/community @langchain/core google-auth-library

```

```codeBlockLines_AdAo
pnpm add @langchain/community @langchain/core google-auth-library

```

The Matching Engine does not store the actual document contents, only embeddings. Therefore, you'll
need a docstore. The below example uses Google Cloud Storage, which requires the following:

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install @google-cloud/storage

```

```codeBlockLines_AdAo
yarn add @google-cloud/storage

```

```codeBlockLines_AdAo
pnpm add @google-cloud/storage

```

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/\#usage "Direct link to Usage")

### Initializing the engine [​](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/\#initializing-the-engine "Direct link to Initializing the engine")

When creating the `MatchingEngine` object, you'll need some information about
the matching engine configuration. You can get this information from the Cloud Console
for Matching Engine:

- The id for the Index
- The id for the Index Endpoint

You will also need a document store. While an `InMemoryDocstore` is ok for
initial testing, you will want to use something like a
[GoogleCloudStorageDocstore](https://api.js.langchain.com/classes/_langchain_community.stores_doc_gcs.GoogleCloudStorageDocstore.html) to store it more permanently.

```codeBlockLines_AdAo
import { MatchingEngine } from "@langchain/community/vectorstores/googlevertexai";
import { Document } from "langchain/document";
import { SyntheticEmbeddings } from "langchain/embeddings/fake";
import { GoogleCloudStorageDocstore } from "@langchain/community/stores/doc/gcs";

const embeddings = new SyntheticEmbeddings({
  vectorSize: Number.parseInt(
    process.env.SYNTHETIC_EMBEDDINGS_VECTOR_SIZE ?? "768",
    10
  ),
});

const store = new GoogleCloudStorageDocstore({
  bucket: process.env.GOOGLE_CLOUD_STORAGE_BUCKET!,
});

const config = {
  index: process.env.GOOGLE_VERTEXAI_MATCHINGENGINE_INDEX!,
  indexEndpoint: process.env.GOOGLE_VERTEXAI_MATCHINGENGINE_INDEXENDPOINT!,
  apiVersion: "v1beta1",
  docstore: store,
};

const engine = new MatchingEngine(embeddings, config);

```

### Adding documents [​](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/\#adding-documents "Direct link to Adding documents")

```codeBlockLines_AdAo
const doc = new Document({ pageContent: "this" });
await engine.addDocuments([doc]);

```

Any metadata in a document is converted into Matching Engine "allow list" values
that can be used to filter during a query.

```codeBlockLines_AdAo
const documents = [\
  new Document({\
    pageContent: "this apple",\
    metadata: {\
      color: "red",\
      category: "edible",\
    },\
  }),\
  new Document({\
    pageContent: "this blueberry",\
    metadata: {\
      color: "blue",\
      category: "edible",\
    },\
  }),\
  new Document({\
    pageContent: "this firetruck",\
    metadata: {\
      color: "red",\
      category: "machine",\
    },\
  }),\
];

// Add all our documents
await engine.addDocuments(documents);

```

The documents are assumed to have an "id" parameter available as well. If this
is not set, then an ID will be assigned and returned as part of the Document.

### Querying documents [​](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/\#querying-documents "Direct link to Querying documents")

Doing a straightforward k-nearest-neighbor search which returns all results
is done using any of the standard methods:

```codeBlockLines_AdAo
const results = await engine.similaritySearch("this");

```

### Querying documents with a filter / restriction [​](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/\#querying-documents-with-a-filter--restriction "Direct link to Querying documents with a filter / restriction")

We can limit what documents are returned based on the metadata that was
set for the document. So if we just wanted to limit the results to those
with a red color, we can do:

```codeBlockLines_AdAo
import { Restriction } from `@langchain/community/vectorstores/googlevertexai`;

const redFilter: Restriction[] = [\
  {\
    namespace: "color",\
    allowList: ["red"],\
  },\
];
const redResults = await engine.similaritySearch("this", 4, redFilter);

```

If we wanted to do something more complicated, like things that are red,
but not edible:

```codeBlockLines_AdAo
const filter: Restriction[] = [\
  {\
    namespace: "color",\
    allowList: ["red"],\
  },\
  {\
    namespace: "category",\
    denyList: ["edible"],\
  },\
];
const results = await engine.similaritySearch("this", 4, filter);

```

### Deleting documents [​](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/\#deleting-documents "Direct link to Deleting documents")

Deleting documents are done using ID.

```codeBlockLines_AdAo
import { IdDocument } from `@langchain/community/vectorstores/googlevertexai`;

const oldResults: IdDocument[] = await engine.similaritySearch("this", 10);
const oldIds = oldResults.map( doc => doc.id! );
await engine.delete({ids: oldIds});

```

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/googlevertexai/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/#setup)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/#usage)
  - [Initializing the engine](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/#initializing-the-engine)
  - [Adding documents](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/#adding-documents)
  - [Querying documents](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/#querying-documents)
  - [Querying documents with a filter / restriction](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/#querying-documents-with-a-filter--restriction)
  - [Deleting documents](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/#deleting-documents)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/googlevertexai/#related)