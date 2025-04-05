[Skip to main content](https://js.langchain.com/docs/integrations/vectorstores/singlestore/#__docusaurus_skipToContent_fallback)

**Join us at [Interrupt: The Agent AI Conference by LangChain](https://interrupt.langchain.com/) on May 13 & 14 in San Francisco!**

On this page

# SingleStore

[SingleStoreDB](https://singlestore.com/) is a robust, high-performance distributed SQL database solution designed to excel in both [cloud](https://www.singlestore.com/cloud/) and on-premises environments. Boasting a versatile feature set, it offers seamless deployment options while delivering unparalleled performance.

A standout feature of SingleStoreDB is its advanced support for vector storage and operations, making it an ideal choice for applications requiring intricate AI capabilities such as text similarity matching. With built-in vector functions like [dot\_product](https://docs.singlestore.com/managed-service/en/reference/sql-reference/vector-functions/dot_product.html) and [euclidean\_distance](https://docs.singlestore.com/managed-service/en/reference/sql-reference/vector-functions/euclidean_distance.html), SingleStoreDB empowers developers to implement sophisticated algorithms efficiently.

For developers keen on leveraging vector data within SingleStoreDB, a comprehensive tutorial is available, guiding them through the intricacies of [working with vector data](https://docs.singlestore.com/managed-service/en/developer-resources/functional-extensions/working-with-vector-data.html). This tutorial delves into the Vector Store within SingleStoreDB, showcasing its ability to facilitate searches based on vector similarity. Leveraging vector indexes, queries can be executed with remarkable speed, enabling swift retrieval of relevant data.

Moreover, SingleStoreDB's Vector Store seamlessly integrates with [full-text indexing based on Lucene](https://docs.singlestore.com/cloud/developer-resources/functional-extensions/working-with-full-text-search/), enabling powerful text similarity searches. Users can filter search results based on selected fields of document metadata objects, enhancing query precision.

What sets SingleStoreDB apart is its ability to combine vector and full-text searches in various ways, offering flexibility and versatility. Whether prefiltering by text or vector similarity and selecting the most relevant data, or employing a weighted sum approach to compute a final similarity score, developers have multiple options at their disposal.

In essence, SingleStoreDB provides a comprehensive solution for managing and querying vector data, offering unparalleled performance and flexibility for AI-driven applications.

Compatibility

Only available on Node.js.

LangChain.js requires the `mysql2` library to create a connection to a SingleStoreDB instance.

## Setup [​](https://js.langchain.com/docs/integrations/vectorstores/singlestore/\#setup "Direct link to Setup")

1. Establish a SingleStoreDB environment. You have the flexibility to choose between [Cloud-based](https://docs.singlestore.com/managed-service/en/getting-started-with-singlestoredb-cloud.html) or [On-Premise](https://docs.singlestore.com/db/v8.1/en/developer-resources/get-started-using-singlestoredb-for-free.html) editions.
2. Install the mysql2 JS client

- npm
- Yarn
- pnpm

```codeBlockLines_AdAo
npm install -S mysql2

```

```codeBlockLines_AdAo
yarn add mysql2

```

```codeBlockLines_AdAo
pnpm add mysql2

```

## Usage [​](https://js.langchain.com/docs/integrations/vectorstores/singlestore/\#usage "Direct link to Usage")

`SingleStoreVectorStore` manages a connection pool. It is recommended to call `await store.end();` before terminating your application to assure all connections are appropriately closed and prevent any possible resource leaks.

### Standard usage [​](https://js.langchain.com/docs/integrations/vectorstores/singlestore/\#standard-usage "Direct link to Standard usage")

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

Below is a straightforward example showcasing how to import the relevant module and perform a base similarity search using the `SingleStoreVectorStore`:

```codeBlockLines_AdAo
import { SingleStoreVectorStore } from "@langchain/community/vectorstores/singlestore";
import { OpenAIEmbeddings } from "@langchain/openai";

export const run = async () => {
  const vectorStore = await SingleStoreVectorStore.fromTexts(
    ["Hello world", "Bye bye", "hello nice world"],
    [{ id: 2 }, { id: 1 }, { id: 3 }],
    new OpenAIEmbeddings(),
    {
      connectionOptions: {
        host: process.env.SINGLESTORE_HOST,
        port: Number(process.env.SINGLESTORE_PORT),
        user: process.env.SINGLESTORE_USERNAME,
        password: process.env.SINGLESTORE_PASSWORD,
        database: process.env.SINGLESTORE_DATABASE,
      },
    }
  );

  const resultOne = await vectorStore.similaritySearch("hello world", 1);
  console.log(resultOne);
  await vectorStore.end();
};

```

#### API Reference:

- SingleStoreVectorStorefrom `@langchain/community/vectorstores/singlestore`
- OpenAIEmbeddingsfrom `@langchain/openai`

### Metadata Filtering [​](https://js.langchain.com/docs/integrations/vectorstores/singlestore/\#metadata-filtering "Direct link to Metadata Filtering")

If it is needed to filter results based on specific metadata fields, you can pass a filter parameter to narrow down your search to the documents that match all specified fields in the filter object:

```codeBlockLines_AdAo
import { SingleStoreVectorStore } from "@langchain/community/vectorstores/singlestore";
import { OpenAIEmbeddings } from "@langchain/openai";

export const run = async () => {
  const vectorStore = await SingleStoreVectorStore.fromTexts(
    ["Good afternoon", "Bye bye", "Boa tarde!", "Até logo!"],
    [\
      { id: 1, language: "English" },\
      { id: 2, language: "English" },\
      { id: 3, language: "Portugese" },\
      { id: 4, language: "Portugese" },\
    ],
    new OpenAIEmbeddings(),
    {
      connectionOptions: {
        host: process.env.SINGLESTORE_HOST,
        port: Number(process.env.SINGLESTORE_PORT),
        user: process.env.SINGLESTORE_USERNAME,
        password: process.env.SINGLESTORE_PASSWORD,
        database: process.env.SINGLESTORE_DATABASE,
      },
      distanceMetric: "EUCLIDEAN_DISTANCE",
    }
  );

  const resultOne = await vectorStore.similaritySearch("greetings", 1, {
    language: "Portugese",
  });
  console.log(resultOne);
  await vectorStore.end();
};

```

#### API Reference:

- SingleStoreVectorStorefrom `@langchain/community/vectorstores/singlestore`
- OpenAIEmbeddingsfrom `@langchain/openai`

### Vector indexes [​](https://js.langchain.com/docs/integrations/vectorstores/singlestore/\#vector-indexes "Direct link to Vector indexes")

Enhance your search efficiency with SingleStore DB version 8.5 or above by leveraging [ANN vector indexes](https://docs.singlestore.com/cloud/reference/sql-reference/vector-functions/vector-indexing/).
By setting `useVectorIndex: true` during vector store object creation, you can activate this feature.
Additionally, if your vectors differ in dimensionality from the default OpenAI embedding size of 1536, ensure to specify the `vectorSize` parameter accordingly.

### Hybrid search [​](https://js.langchain.com/docs/integrations/vectorstores/singlestore/\#hybrid-search "Direct link to Hybrid search")

SingleStoreDB presents a diverse range of search strategies, each meticulously crafted to cater to specific use cases and user preferences.
The default `VECTOR_ONLY` strategy utilizes vector operations such as `DOT_PRODUCT` or `EUCLIDEAN_DISTANCE` to calculate similarity scores directly between vectors, while `TEXT_ONLY` employs Lucene-based full-text search, particularly advantageous for text-centric applications.
For users seeking a balanced approach, `FILTER_BY_TEXT` first refines results based on text similarity before conducting vector comparisons, whereas `FILTER_BY_VECTOR` prioritizes vector similarity, filtering results before assessing text similarity for optimal matches.
Notably, both `FILTER_BY_TEXT` and `FILTER_BY_VECTOR` necessitate a full-text index for operation. Additionally, `WEIGHTED_SUM` emerges as a sophisticated strategy, calculating the final similarity score by weighing vector and text similarities, albeit exclusively utilizing dot\_product distance calculations and also requiring a full-text index.
These versatile strategies empower users to fine-tune searches according to their unique needs, facilitating efficient and precise data retrieval and analysis.
Moreover, SingleStoreDB's hybrid approaches, exemplified by `FILTER_BY_TEXT`, `FILTER_BY_VECTOR`, and `WEIGHTED_SUM` strategies, seamlessly blend vector and text-based searches to maximize efficiency and accuracy, ensuring users can fully leverage the platform's capabilities for a wide range of applications.

```codeBlockLines_AdAo
import { SingleStoreVectorStore } from "@langchain/community/vectorstores/singlestore";
import { OpenAIEmbeddings } from "@langchain/openai";

export const run = async () => {
  const vectorStore = await SingleStoreVectorStore.fromTexts(
    [\
      "In the parched desert, a sudden rainstorm brought relief, as the droplets danced upon the thirsty earth, rejuvenating the landscape with the sweet scent of petrichor.",\
      "Amidst the bustling cityscape, the rain fell relentlessly, creating a symphony of pitter-patter on the pavement, while umbrellas bloomed like colorful flowers in a sea of gray.",\
      "High in the mountains, the rain transformed into a delicate mist, enveloping the peaks in a mystical veil, where each droplet seemed to whisper secrets to the ancient rocks below.",\
      "Blanketing the countryside in a soft, pristine layer, the snowfall painted a serene tableau, muffling the world in a tranquil hush as delicate flakes settled upon the branches of trees like nature's own lacework.",\
      "In the urban landscape, snow descended, transforming bustling streets into a winter wonderland, where the laughter of children echoed amidst the flurry of snowballs and the twinkle of holiday lights.",\
      "Atop the rugged peaks, snow fell with an unyielding intensity, sculpting the landscape into a pristine alpine paradise, where the frozen crystals shimmered under the moonlight, casting a spell of enchantment over the wilderness below.",\
    ],
    [\
      { category: "rain" },\
      { category: "rain" },\
      { category: "rain" },\
      { category: "snow" },\
      { category: "snow" },\
      { category: "snow" },\
    ],
    new OpenAIEmbeddings(),
    {
      connectionOptions: {
        host: process.env.SINGLESTORE_HOST,
        port: Number(process.env.SINGLESTORE_PORT),
        user: process.env.SINGLESTORE_USERNAME,
        password: process.env.SINGLESTORE_PASSWORD,
        database: process.env.SINGLESTORE_DATABASE,
      },
      distanceMetric: "DOT_PRODUCT",
      useVectorIndex: true,
      useFullTextIndex: true,
    }
  );

  const resultOne = await vectorStore.similaritySearch(
    "rainstorm in parched desert, rain",
    1,
    { category: "rain" }
  );
  console.log(resultOne[0].pageContent);

  await vectorStore.setSearchConfig({
    searchStrategy: "TEXT_ONLY",
  });
  const resultTwo = await vectorStore.similaritySearch(
    "rainstorm in parched desert, rain",
    1
  );
  console.log(resultTwo[0].pageContent);

  await vectorStore.setSearchConfig({
    searchStrategy: "FILTER_BY_TEXT",
    filterThreshold: 0.1,
  });
  const resultThree = await vectorStore.similaritySearch(
    "rainstorm in parched desert, rain",
    1
  );
  console.log(resultThree[0].pageContent);

  await vectorStore.setSearchConfig({
    searchStrategy: "FILTER_BY_VECTOR",
    filterThreshold: 0.1,
  });
  const resultFour = await vectorStore.similaritySearch(
    "rainstorm in parched desert, rain",
    1
  );
  console.log(resultFour[0].pageContent);

  await vectorStore.setSearchConfig({
    searchStrategy: "WEIGHTED_SUM",
    textWeight: 0.2,
    vectorWeight: 0.8,
    vectorselectCountMultiplier: 10,
  });
  const resultFive = await vectorStore.similaritySearch(
    "rainstorm in parched desert, rain",
    1
  );
  console.log(resultFive[0].pageContent);

  await vectorStore.end();
};

```

#### API Reference:

- SingleStoreVectorStorefrom `@langchain/community/vectorstores/singlestore`
- OpenAIEmbeddingsfrom `@langchain/openai`

## Related [​](https://js.langchain.com/docs/integrations/vectorstores/singlestore/\#related "Direct link to Related")

- Vector store [conceptual guide](https://js.langchain.com/docs/concepts/#vectorstores)
- Vector store [how-to guides](https://js.langchain.com/docs/how_to/#vectorstores)

* * *

#### Was this page helpful?

#### You can also leave detailed feedback [on GitHub](https://github.com/langchain-ai/langchainjs/issues/new?assignees=&labels=03+-+Documentation&projects=&template=documentation.yml&title=DOC%3A+%3CIssue+related+to+/docs/integrations/vectorstores/singlestore/%3E).

- [Setup](https://js.langchain.com/docs/integrations/vectorstores/singlestore/#setup)
- [Usage](https://js.langchain.com/docs/integrations/vectorstores/singlestore/#usage)
  - [Standard usage](https://js.langchain.com/docs/integrations/vectorstores/singlestore/#standard-usage)
  - [Metadata Filtering](https://js.langchain.com/docs/integrations/vectorstores/singlestore/#metadata-filtering)
  - [Vector indexes](https://js.langchain.com/docs/integrations/vectorstores/singlestore/#vector-indexes)
  - [Hybrid search](https://js.langchain.com/docs/integrations/vectorstores/singlestore/#hybrid-search)
- [Related](https://js.langchain.com/docs/integrations/vectorstores/singlestore/#related)