for file in *js_langchain_com_docs_integrations_*; do
    mv "$file" "${file/js_langchain_com_docs_integrations_/}"
done
