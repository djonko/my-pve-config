# Keeps (yours, but upgrade quants if needed)
ollama pull hf.co/unsloth/Qwen2.5-Coder-1.5B-Instruct-128K-GGUF:Q4_K_M  # Upgrade from Q3
ollama pull hf.co/mradermacher/Qwen2.5-Microsoft-NextCoder-Brainstorm20x-128k-ctx-20B-GGUF:Q4_K_M  # Ensure Q4
ollama pull deepseek-r1:8b  # Or HF alt above
ollama pull hf.co/microsoft/Phi-3.5-mini-instruct-GGUF:Q4_K_M  # Upgrade
ollama pull nomic-embed-text:v1.5  # Keep

# Adds
ollama pull hf.co/infosys/NT-Java-1.1B-GGUF:Q4_K_M
ollama pull hf.co/Qwen/Qwen3-Embedding-0.6B-GGUF:Q4_K_M
ollama pull hf.co/BAAI/bge-reranker-v2-m3-GGUF:Q4_K_M
ollama pull hf.co/richardyoung/olmOCR-2-7B-1025-GGUF:Q4_K_M

# Cleanup
ollama rm qwen3:4b mistral:latest codellama:13b gemma3:12b stable-code:latest mannix/llamax3-8b-alpaca:latest llama3.2:3b hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q2_K_XL hf.co/Lamapi/next-4b:F16