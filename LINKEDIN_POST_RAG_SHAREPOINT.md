# LinkedIn Post: RAG Implementation with SharePoint

---

🚀 **Everyone's implementing RAG with their own data. Here's one approach for SharePoint.**

Most RAG implementations search everything. The key is filtering first.

**The Flow:**

**Upload:**
SharePoint Folder → Graph API (with cached access token) → LangChain Documents → Recursive Text Splitting → PGVector Storage

**Retrieval:**
Agent Query → Get User's Authorized Paths → Filter by Path (from metadata) → Vector Similarity Search → Return Relevant Chunks

**The Critical Insight:** Filter by SharePoint path BEFORE vector search. This ensures security (users only see authorized docs) and performance (search 1K instead of 100K). The metadata you store during ingestion determines what you can filter during retrieval.

What data sources are you connecting to RAG? What challenges are you facing?

*Views are my own*

#RAG #LLM #SharePoint #VectorDatabase #AI #LangChain #EnterpriseAI #DataEngineering

---

