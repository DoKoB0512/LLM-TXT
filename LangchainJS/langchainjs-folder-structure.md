Directory structure:
└── docs/
    ├── api_refs/
    │   ├── README.md
    │   ├── blacklisted-entrypoints.json
    │   ├── next.config.js
    │   ├── package.json
    │   ├── postcss.config.js
    │   ├── tailwind.config.ts
    │   ├── tsconfig.json
    │   ├── typedoc.base.json
    │   ├── vercel.json
    │   ├── .eslintrc.json
    │   ├── .gitignore
    │   ├── scripts/
    │   │   ├── create-entrypoints.js
    │   │   ├── typedoc-plugin.js
    │   │   └── update-typedoc-css.js
    │   └── src/
    │       └── app/
    └── core_docs/
        ├── README.md
        ├── babel.config.js
        ├── docusaurus.config.js
        ├── package.json
        ├── sidebars.js
        ├── vercel.json
        ├── .eslintrc.js
        ├── .gitignore
        ├── .prettierignore
        ├── data/
        │   ├── ls_few_shot_example_dataset.json
        │   └── people.yml
        ├── docs/
        │   ├── community.mdx
        │   ├── introduction.mdx
        │   ├── packages.mdx
        │   ├── people.mdx
        │   ├── security.md
        │   ├── _static/
        │   │   └── css/
        │   │       └── custom.css
        │   ├── additional_resources/
        │   │   └── tutorials.mdx
        │   ├── concepts/
        │   │   ├── agents.mdx
        │   │   ├── architecture.mdx
        │   │   ├── callbacks.mdx
        │   │   ├── chat_history.mdx
        │   │   ├── chat_models.mdx
        │   │   ├── document_loaders.mdx
        │   │   ├── embedding_models.mdx
        │   │   ├── evaluation.mdx
        │   │   ├── example_selectors.mdx
        │   │   ├── few_shot_prompting.mdx
        │   │   ├── index.mdx
        │   │   ├── key_value_stores.mdx
        │   │   ├── lcel.mdx
        │   │   ├── messages.mdx
        │   │   ├── multimodality.mdx
        │   │   ├── output_parsers.mdx
        │   │   ├── prompt_templates.mdx
        │   │   ├── rag.mdx
        │   │   ├── retrieval.mdx
        │   │   ├── retrievers.mdx
        │   │   ├── runnables.mdx
        │   │   ├── streaming.mdx
        │   │   ├── structured_outputs.mdx
        │   │   ├── t.ipynb
        │   │   ├── text_llms.mdx
        │   │   ├── text_splitters.mdx
        │   │   ├── tokens.mdx
        │   │   ├── tool_calling.mdx
        │   │   ├── tools.mdx
        │   │   ├── tracing.mdx
        │   │   ├── vectorstores.mdx
        │   │   └── why_langchain.mdx
        │   ├── contributing/
        │   │   ├── code.mdx
        │   │   ├── faq.mdx
        │   │   ├── index.mdx
        │   │   ├── integrations.mdx
        │   │   ├── repo_structure.mdx
        │   │   ├── testing.mdx
        │   │   └── documentation/
        │   │       ├── _category_.yml
        │   │       └── style_guide.mdx
        │   ├── how_to/
        │   │   ├── agent_executor.ipynb
        │   │   ├── assign.ipynb
        │   │   ├── binding.ipynb
        │   │   ├── caching_embeddings.mdx
        │   │   ├── callbacks_attach.ipynb
        │   │   ├── callbacks_constructor.ipynb
        │   │   ├── callbacks_custom_events.ipynb
        │   │   ├── callbacks_runtime.ipynb
        │   │   ├── callbacks_serverless.ipynb
        │   │   ├── cancel_execution.ipynb
        │   │   ├── character_text_splitter.ipynb
        │   │   ├── chat_model_caching.mdx
        │   │   ├── chat_models_universal_init.mdx
        │   │   ├── chat_streaming.ipynb
        │   │   ├── chat_token_usage_tracking.mdx
        │   │   ├── chatbots_memory.ipynb
        │   │   ├── chatbots_retrieval.ipynb
        │   │   ├── chatbots_tools.ipynb
        │   │   ├── code_splitter.ipynb
        │   │   ├── contextual_compression.mdx
        │   │   ├── convert_runnable_to_tool.ipynb
        │   │   ├── custom_callbacks.ipynb
        │   │   ├── custom_chat.ipynb
        │   │   ├── custom_llm.ipynb
        │   │   ├── custom_retriever.mdx
        │   │   ├── custom_tools.ipynb
        │   │   ├── debugging.mdx
        │   │   ├── document_loader_csv.mdx
        │   │   ├── document_loader_custom.mdx
        │   │   ├── document_loader_directory.mdx
        │   │   ├── document_loader_html.ipynb
        │   │   ├── document_loader_markdown.ipynb
        │   │   ├── document_loader_pdf.mdx
        │   │   ├── document_loaders_json.mdx
        │   │   ├── embed_text.mdx
        │   │   ├── ensemble_retriever.mdx
        │   │   ├── example_selectors.ipynb
        │   │   ├── example_selectors_langsmith.ipynb
        │   │   ├── example_selectors_length_based.mdx
        │   │   ├── example_selectors_similarity.mdx
        │   │   ├── extraction_examples.ipynb
        │   │   ├── extraction_long_text.ipynb
        │   │   ├── extraction_parse.ipynb
        │   │   ├── fallbacks.mdx
        │   │   ├── few_shot.mdx
        │   │   ├── few_shot_examples.ipynb
        │   │   ├── few_shot_examples_chat.ipynb
        │   │   ├── filter_messages.ipynb
        │   │   ├── functions.ipynb
        │   │   ├── generative_ui.mdx
        │   │   ├── graph_constructing.ipynb
        │   │   ├── graph_mapping.ipynb
        │   │   ├── graph_prompting.ipynb
        │   │   ├── graph_semantic.ipynb
        │   │   ├── index.mdx
        │   │   ├── indexing.mdx
        │   │   ├── installation.mdx
        │   │   ├── lcel_cheatsheet.ipynb
        │   │   ├── llm_caching.mdx
        │   │   ├── llm_token_usage_tracking.mdx
        │   │   ├── logprobs.ipynb
        │   │   ├── merge_message_runs.ipynb
        │   │   ├── message_history.ipynb
        │   │   ├── migrate_agent.ipynb
        │   │   ├── multi_vector.mdx
        │   │   ├── multimodal_inputs.ipynb
        │   │   ├── multimodal_prompts.ipynb
        │   │   ├── multiple_queries.ipynb
        │   │   ├── output_parser_fixing.ipynb
        │   │   ├── output_parser_json.ipynb
        │   │   ├── output_parser_structured.ipynb
        │   │   ├── output_parser_xml.ipynb
        │   │   ├── parallel.mdx
        │   │   ├── parent_document_retriever.mdx
        │   │   ├── passthrough.ipynb
        │   │   ├── prompts_composition.ipynb
        │   │   ├── prompts_partial.mdx
        │   │   ├── qa_chat_history_how_to.ipynb
        │   │   ├── qa_citations.ipynb
        │   │   ├── qa_per_user.ipynb
        │   │   ├── qa_sources.ipynb
        │   │   ├── qa_streaming.ipynb
        │   │   ├── query_constructing_filters.ipynb
        │   │   ├── query_few_shot.ipynb
        │   │   ├── query_high_cardinality.ipynb
        │   │   ├── query_multiple_queries.ipynb
        │   │   ├── query_multiple_retrievers.ipynb
        │   │   ├── query_no_queries.ipynb
        │   │   ├── recursive_text_splitter.ipynb
        │   │   ├── reduce_retrieval_latency.mdx
        │   │   ├── routing.mdx
        │   │   ├── self_query.ipynb
        │   │   ├── sequence.ipynb
        │   │   ├── split_by_token.ipynb
        │   │   ├── sql_large_db.mdx
        │   │   ├── sql_prompting.mdx
        │   │   ├── sql_query_checking.mdx
        │   │   ├── stream_agent_client.mdx
        │   │   ├── stream_tool_client.mdx
        │   │   ├── streaming.ipynb
        │   │   ├── streaming_llm.mdx
        │   │   ├── structured_output.ipynb
        │   │   ├── time_weighted_vectorstore.mdx
        │   │   ├── tool_artifacts.ipynb
        │   │   ├── tool_calling.ipynb
        │   │   ├── tool_calling_parallel.ipynb
        │   │   ├── tool_calls_multimodal.ipynb
        │   │   ├── tool_choice.ipynb
        │   │   ├── tool_configure.ipynb
        │   │   ├── tool_results_pass_to_model.ipynb
        │   │   ├── tool_runtime.ipynb
        │   │   ├── tool_stream_events.ipynb
        │   │   ├── tool_streaming.ipynb
        │   │   ├── tools_builtin.ipynb
        │   │   ├── tools_error.ipynb
        │   │   ├── tools_few_shot.ipynb
        │   │   ├── tools_prompting.ipynb
        │   │   ├── trim_messages.ipynb
        │   │   ├── vectorstore_retriever.mdx
        │   │   └── vectorstores.mdx
        │   ├── integrations/
        │   │   ├── callbacks/
        │   │   │   ├── datadog_tracer.mdx
        │   │   │   └── upstash_ratelimit_callback.mdx
        │   │   ├── chat/
        │   │   │   ├── alibaba_tongyi.mdx
        │   │   │   ├── anthropic.ipynb
        │   │   │   ├── arcjet.ipynb
        │   │   │   ├── azure.ipynb
        │   │   │   ├── baidu_qianfan.mdx
        │   │   │   ├── baidu_wenxin.mdx
        │   │   │   ├── bedrock.ipynb
        │   │   │   ├── bedrock_converse.ipynb
        │   │   │   ├── cerebras.ipynb
        │   │   │   ├── cloudflare_workersai.ipynb
        │   │   │   ├── cohere.ipynb
        │   │   │   ├── deep_infra.mdx
        │   │   │   ├── deepseek.ipynb
        │   │   │   ├── fake.mdx
        │   │   │   ├── fireworks.ipynb
        │   │   │   ├── friendli.mdx
        │   │   │   ├── google_generativeai.ipynb
        │   │   │   ├── google_vertex_ai.ipynb
        │   │   │   ├── groq.ipynb
        │   │   │   ├── ibm.ipynb
        │   │   │   ├── index.mdx
        │   │   │   ├── llama_cpp.mdx
        │   │   │   ├── minimax.mdx
        │   │   │   ├── mistral.ipynb
        │   │   │   ├── moonshot.mdx
        │   │   │   ├── ni_bittensor.mdx
        │   │   │   ├── novita.ipynb
        │   │   │   ├── ollama.ipynb
        │   │   │   ├── ollama_functions.mdx
        │   │   │   ├── openai.ipynb
        │   │   │   ├── perplexity.ipynb
        │   │   │   ├── premai.mdx
        │   │   │   ├── prompt_layer_openai.mdx
        │   │   │   ├── tencent_hunyuan.mdx
        │   │   │   ├── togetherai.ipynb
        │   │   │   ├── web_llm.mdx
        │   │   │   ├── xai.ipynb
        │   │   │   ├── yandex.mdx
        │   │   │   └── zhipuai.mdx
        │   │   ├── document_compressors/
        │   │   │   ├── cohere_rerank.mdx
        │   │   │   ├── ibm.ipynb
        │   │   │   └── mixedbread_ai.mdx
        │   │   ├── document_loaders/
        │   │   │   ├── index.mdx
        │   │   │   ├── file_loaders/
        │   │   │   │   ├── chatgpt.mdx
        │   │   │   │   ├── csv.ipynb
        │   │   │   │   ├── directory.ipynb
        │   │   │   │   ├── docx.mdx
        │   │   │   │   ├── epub.mdx
        │   │   │   │   ├── index.mdx
        │   │   │   │   ├── json.mdx
        │   │   │   │   ├── jsonlines.mdx
        │   │   │   │   ├── multi_file.mdx
        │   │   │   │   ├── notion_markdown.mdx
        │   │   │   │   ├── openai_whisper_audio.mdx
        │   │   │   │   ├── pdf.ipynb
        │   │   │   │   ├── pptx.mdx
        │   │   │   │   ├── subtitles.mdx
        │   │   │   │   ├── text.ipynb
        │   │   │   │   └── unstructured.ipynb
        │   │   │   └── web_loaders/
        │   │   │       ├── airtable.mdx
        │   │   │       ├── apify_dataset.mdx
        │   │   │       ├── assemblyai_audio_transcription.mdx
        │   │   │       ├── azure_blob_storage_container.mdx
        │   │   │       ├── azure_blob_storage_file.mdx
        │   │   │       ├── browserbase.mdx
        │   │   │       ├── college_confidential.mdx
        │   │   │       ├── confluence.mdx
        │   │   │       ├── couchbase.mdx
        │   │   │       ├── figma.mdx
        │   │   │       ├── firecrawl.ipynb
        │   │   │       ├── gitbook.mdx
        │   │   │       ├── github.mdx
        │   │   │       ├── google_cloud_storage.mdx
        │   │   │       ├── google_cloudsql_pg.mdx
        │   │   │       ├── hn.mdx
        │   │   │       ├── imsdb.mdx
        │   │   │       ├── index.mdx
        │   │   │       ├── jira.mdx
        │   │   │       ├── langsmith.ipynb
        │   │   │       ├── notionapi.mdx
        │   │   │       ├── pdf.ipynb
        │   │   │       ├── recursive_url_loader.ipynb
        │   │   │       ├── s3.mdx
        │   │   │       ├── searchapi.mdx
        │   │   │       ├── serpapi.mdx
        │   │   │       ├── sitemap.mdx
        │   │   │       ├── sonix_audio_transcription.mdx
        │   │   │       ├── sort_xyz_blockchain.mdx
        │   │   │       ├── spider.mdx
        │   │   │       ├── taskade.mdx
        │   │   │       ├── web_cheerio.ipynb
        │   │   │       ├── web_playwright.mdx
        │   │   │       ├── web_puppeteer.ipynb
        │   │   │       └── youtube.mdx
        │   │   ├── document_transformers/
        │   │   │   ├── html-to-text.mdx
        │   │   │   ├── mozilla_readability.mdx
        │   │   │   └── openai_metadata_tagger.mdx
        │   │   ├── llm_caching/
        │   │   │   ├── azure_cosmosdb_nosql.mdx
        │   │   │   └── index.mdx
        │   │   ├── llms/
        │   │   │   ├── ai21.mdx
        │   │   │   ├── aleph_alpha.mdx
        │   │   │   ├── arcjet.ipynb
        │   │   │   ├── aws_sagemaker.mdx
        │   │   │   ├── azure.ipynb
        │   │   │   ├── bedrock.ipynb
        │   │   │   ├── chrome_ai.mdx
        │   │   │   ├── cloudflare_workersai.ipynb
        │   │   │   ├── cohere.ipynb
        │   │   │   ├── deep_infra.mdx
        │   │   │   ├── fireworks.ipynb
        │   │   │   ├── friendli.mdx
        │   │   │   ├── google_vertex_ai.ipynb
        │   │   │   ├── gradient_ai.mdx
        │   │   │   ├── huggingface_inference.mdx
        │   │   │   ├── ibm.ipynb
        │   │   │   ├── index.mdx
        │   │   │   ├── jigsawstack.mdx
        │   │   │   ├── layerup_security.mdx
        │   │   │   ├── llama_cpp.mdx
        │   │   │   ├── mistral.ipynb
        │   │   │   ├── ni_bittensor.mdx
        │   │   │   ├── ollama.ipynb
        │   │   │   ├── openai.ipynb
        │   │   │   ├── prompt_layer_openai.mdx
        │   │   │   ├── raycast.mdx
        │   │   │   ├── replicate.mdx
        │   │   │   ├── together.ipynb
        │   │   │   ├── writer.mdx
        │   │   │   └── yandex.mdx
        │   │   ├── memory/
        │   │   │   ├── astradb.mdx
        │   │   │   ├── aurora_dsql.mdx
        │   │   │   ├── azure_cosmos_mongo_vcore.mdx
        │   │   │   ├── azure_cosmosdb_nosql.mdx
        │   │   │   ├── cassandra.mdx
        │   │   │   ├── cloudflare_d1.mdx
        │   │   │   ├── convex.mdx
        │   │   │   ├── dynamodb.mdx
        │   │   │   ├── file.mdx
        │   │   │   ├── firestore.mdx
        │   │   │   ├── google_cloudsql_pg.mdx
        │   │   │   ├── ipfs_datastore.mdx
        │   │   │   ├── mem0_memory.mdx
        │   │   │   ├── momento.mdx
        │   │   │   ├── mongodb.mdx
        │   │   │   ├── motorhead_memory.mdx
        │   │   │   ├── planetscale.mdx
        │   │   │   ├── postgres.mdx
        │   │   │   ├── redis.mdx
        │   │   │   ├── upstash_redis.mdx
        │   │   │   ├── xata.mdx
        │   │   │   ├── zep_memory.mdx
        │   │   │   └── zep_memory_cloud.mdx
        │   │   ├── platforms/
        │   │   │   ├── anthropic.mdx
        │   │   │   ├── aws.mdx
        │   │   │   ├── google.mdx
        │   │   │   ├── index.mdx
        │   │   │   ├── microsoft.mdx
        │   │   │   └── openai.mdx
        │   │   ├── retrievers/
        │   │   │   ├── arxiv-retriever.mdx
        │   │   │   ├── azion-edgesql.ipynb
        │   │   │   ├── bedrock-knowledge-bases.ipynb
        │   │   │   ├── bm25.ipynb
        │   │   │   ├── chaindesk-retriever.mdx
        │   │   │   ├── chatgpt-retriever-plugin.mdx
        │   │   │   ├── dria.mdx
        │   │   │   ├── exa.ipynb
        │   │   │   ├── hyde.mdx
        │   │   │   ├── index.mdx
        │   │   │   ├── kendra-retriever.ipynb
        │   │   │   ├── metal-retriever.mdx
        │   │   │   ├── supabase-hybrid.mdx
        │   │   │   ├── tavily.ipynb
        │   │   │   ├── time-weighted-retriever.mdx
        │   │   │   ├── vespa-retriever.mdx
        │   │   │   ├── zep-cloud-retriever.mdx
        │   │   │   ├── zep-retriever.mdx
        │   │   │   └── self_query/
        │   │   │       ├── chroma.ipynb
        │   │   │       ├── hnswlib.ipynb
        │   │   │       ├── index.mdx
        │   │   │       ├── memory.ipynb
        │   │   │       ├── pinecone.ipynb
        │   │   │       ├── qdrant.ipynb
        │   │   │       ├── supabase.ipynb
        │   │   │       ├── vectara.ipynb
        │   │   │       └── weaviate.ipynb
        │   │   ├── stores/
        │   │   │   ├── cassandra_storage.mdx
        │   │   │   ├── file_system.ipynb
        │   │   │   ├── in_memory.ipynb
        │   │   │   ├── index.mdx
        │   │   │   ├── ioredis_storage.mdx
        │   │   │   ├── upstash_redis_storage.mdx
        │   │   │   └── vercel_kv_storage.mdx
        │   │   ├── text_embedding/
        │   │   │   ├── alibaba_tongyi.mdx
        │   │   │   ├── azure_openai.ipynb
        │   │   │   ├── baidu_qianfan.mdx
        │   │   │   ├── bedrock.ipynb
        │   │   │   ├── bytedance_doubao.ipynb
        │   │   │   ├── cloudflare_ai.ipynb
        │   │   │   ├── cohere.ipynb
        │   │   │   ├── deepinfra.mdx
        │   │   │   ├── fireworks.ipynb
        │   │   │   ├── google_generativeai.ipynb
        │   │   │   ├── google_vertex_ai.ipynb
        │   │   │   ├── gradient_ai.mdx
        │   │   │   ├── hugging_face_inference.mdx
        │   │   │   ├── ibm.ipynb
        │   │   │   ├── index.mdx
        │   │   │   ├── jina.mdx
        │   │   │   ├── llama_cpp.mdx
        │   │   │   ├── minimax.mdx
        │   │   │   ├── mistralai.ipynb
        │   │   │   ├── mixedbread_ai.mdx
        │   │   │   ├── nomic.mdx
        │   │   │   ├── ollama.ipynb
        │   │   │   ├── openai.ipynb
        │   │   │   ├── pinecone.ipynb
        │   │   │   ├── premai.mdx
        │   │   │   ├── tencent_hunyuan.mdx
        │   │   │   ├── tensorflow.mdx
        │   │   │   ├── togetherai.ipynb
        │   │   │   ├── transformers.mdx
        │   │   │   ├── voyageai.mdx
        │   │   │   └── zhipuai.mdx
        │   │   ├── toolkits/
        │   │   │   ├── connery.mdx
        │   │   │   ├── ibm.ipynb
        │   │   │   ├── index.mdx
        │   │   │   ├── json.mdx
        │   │   │   ├── openapi.ipynb
        │   │   │   ├── sfn_agent.mdx
        │   │   │   ├── sql.ipynb
        │   │   │   └── vectorstore.ipynb
        │   │   ├── tools/
        │   │   │   ├── aiplugin-tool.mdx
        │   │   │   ├── azure_dynamic_sessions.mdx
        │   │   │   ├── connery.mdx
        │   │   │   ├── dalle.mdx
        │   │   │   ├── discord.mdx
        │   │   │   ├── duckduckgo_search.ipynb
        │   │   │   ├── exa_search.ipynb
        │   │   │   ├── gmail.mdx
        │   │   │   ├── google_calendar.mdx
        │   │   │   ├── google_places.mdx
        │   │   │   ├── google_routes.mdx
        │   │   │   ├── google_scholar.ipynb
        │   │   │   ├── google_trends.mdx
        │   │   │   ├── index.mdx
        │   │   │   ├── jigsawstack.mdx
        │   │   │   ├── lambda_agent.mdx
        │   │   │   ├── pyinterpreter.mdx
        │   │   │   ├── searchapi.mdx
        │   │   │   ├── searxng.mdx
        │   │   │   ├── serpapi.ipynb
        │   │   │   ├── stackexchange.mdx
        │   │   │   ├── stagehand.mdx
        │   │   │   ├── tavily_search.ipynb
        │   │   │   ├── webbrowser.mdx
        │   │   │   ├── wikipedia.mdx
        │   │   │   ├── wolframalpha.mdx
        │   │   │   └── zapier_agent.mdx
        │   │   └── vectorstores/
        │   │       ├── analyticdb.mdx
        │   │       ├── astradb.mdx
        │   │       ├── azion-edgesql.ipynb
        │   │       ├── azure_aisearch.mdx
        │   │       ├── azure_cosmosdb_mongodb.mdx
        │   │       ├── azure_cosmosdb_nosql.mdx
        │   │       ├── cassandra.mdx
        │   │       ├── chroma.ipynb
        │   │       ├── clickhouse.mdx
        │   │       ├── closevector.mdx
        │   │       ├── cloudflare_vectorize.mdx
        │   │       ├── convex.mdx
        │   │       ├── couchbase.mdx
        │   │       ├── elasticsearch.ipynb
        │   │       ├── faiss.ipynb
        │   │       ├── google_cloudsql_pg.ipynb
        │   │       ├── googlevertexai.mdx
        │   │       ├── hanavector.mdx
        │   │       ├── hnswlib.ipynb
        │   │       ├── index.mdx
        │   │       ├── lancedb.mdx
        │   │       ├── libsql.mdx
        │   │       ├── mariadb.ipynb
        │   │       ├── memory.ipynb
        │   │       ├── milvus.mdx
        │   │       ├── momento_vector_index.mdx
        │   │       ├── mongodb_atlas.ipynb
        │   │       ├── myscale.mdx
        │   │       ├── neo4jvector.mdx
        │   │       ├── neon.mdx
        │   │       ├── opensearch.mdx
        │   │       ├── pgvector.ipynb
        │   │       ├── pinecone.ipynb
        │   │       ├── prisma.mdx
        │   │       ├── qdrant.ipynb
        │   │       ├── redis.ipynb
        │   │       ├── rockset.mdx
        │   │       ├── singlestore.mdx
        │   │       ├── supabase.ipynb
        │   │       ├── tigris.mdx
        │   │       ├── turbopuffer.mdx
        │   │       ├── typeorm.mdx
        │   │       ├── typesense.mdx
        │   │       ├── upstash.ipynb
        │   │       ├── usearch.mdx
        │   │       ├── vectara.mdx
        │   │       ├── vercel_postgres.mdx
        │   │       ├── voy.mdx
        │   │       ├── weaviate.ipynb
        │   │       ├── xata.mdx
        │   │       ├── zep.mdx
        │   │       └── zep_cloud.mdx
        │   ├── mdx_components/
        │   │   ├── integration_install_tooltip.mdx
        │   │   └── unified_model_params_tooltip.mdx
        │   ├── troubleshooting/
        │   │   └── errors/
        │   │       ├── index.mdx
        │   │       ├── INVALID_PROMPT_INPUT.mdx
        │   │       ├── INVALID_TOOL_RESULTS.ipynb
        │   │       ├── MESSAGE_COERCION_FAILURE.mdx
        │   │       ├── MODEL_AUTHENTICATION.mdx
        │   │       ├── MODEL_NOT_FOUND.mdx
        │   │       ├── MODEL_RATE_LIMIT.mdx
        │   │       └── OUTPUT_PARSING_FAILURE.mdx
        │   ├── tutorials/
        │   │   ├── chatbot.ipynb
        │   │   ├── classification.ipynb
        │   │   ├── extraction.ipynb
        │   │   ├── graph.ipynb
        │   │   ├── index.mdx
        │   │   ├── llm_chain.ipynb
        │   │   ├── qa_chat_history.ipynb
        │   │   ├── rag.ipynb
        │   │   ├── retrievers.ipynb
        │   │   ├── sql_qa.ipynb
        │   │   └── summarization.ipynb
        │   └── versions/
        │       ├── release_policy.mdx
        │       ├── migrating_memory/
        │       │   ├── chat_history.ipynb
        │       │   ├── conversation_buffer_window_memory.ipynb
        │       │   ├── conversation_summary_memory.ipynb
        │       │   └── index.mdx
        │       ├── v0_2/
        │       │   ├── index.mdx
        │       │   └── migrating_astream_events.mdx
        │       └── v0_3/
        │           └── index.mdx
        ├── scripts/
        │   ├── append_related_links.py
        │   ├── check-broken-links.js
        │   ├── code-block-loader.js
        │   ├── quarto-build.js
        │   └── vercel_build.sh
        ├── src/
        │   ├── css/
        │   │   └── custom.css
        │   ├── pages/
        │   │   └── index.js
        │   └── theme/
        │       ├── ChatModelTabs.js
        │       ├── EmbeddingTabs.js
        │       ├── FeatureTables.js
        │       ├── Feedback.js
        │       ├── NotFound.js
        │       ├── Npm2Yarn.js
        │       ├── People.js
        │       ├── RedirectAnchors.js
        │       ├── VectorStoreTabs.js
        │       ├── CodeBlock/
        │       │   └── index.js
        │       ├── DocItem/
        │       │   └── Paginator/
        │       │       └── index.js
        │       ├── DocPaginator/
        │       │   └── index.js
        │       └── DocVersionBanner/
        │           └── index.js
        └── static/
            ├── llms.txt
            ├── robots.txt
            ├── .nojekyll
            ├── fonts/
            │   ├── Manrope-VariableFont_wght.ttf
            │   └── PublicSans-VariableFont_wght.ttf
            ├── img/
            │   ├── graph_chain.webp
            │   ├── langchain_stack_feb_2024.webp
            │   └── brand/
            ├── js/
            │   └── google_analytics.js
            └── svg/
