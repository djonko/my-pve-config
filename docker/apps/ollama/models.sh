# Keeps (yours, but upgrade quants if needed)
ollama pull hf.co/unsloth/Qwen2.5-Coder-1.5B-Instruct-128K-GGUF:Q4_K_M  # Upgrade from Q3
ollama pull hf.co/mradermacher/Qwen2.5-Microsoft-NextCoder-Brainstorm20x-128k-ctx-20B-GGUF:Q4_K_M  # Ensure Q4
ollama pull deepseek-r1:8b  # Or HF alt above
ollama pull hf.co/microsoft/Phi-3.5-mini-instruct-GGUF:Q4_K_M  # Upgrade
ollama pull nomic-embed-text:v1.5  # Keep

# Adds
ollama pull hf.co/infosys/NT-Java-1.1B-GGUF:Q4_K_M
ollama pull hf.co/Qwen/Qwen3-Embedding-0.6B-GGUF:Q8_0
ollama pull hf.co/gpustack/bge-reranker-v2-m3-GGUF:Q4_K_M
ollama pull hf.co/bartowski/allenai_olmOCR-2-7B-1025-GGUF:Q8_0

# Cleanup
ollama rm qwen3:4b mistral:latest codellama:13b gemma3:12b stable-code:latest mannix/llamax3-8b-alpaca:latest llama3.2:3b hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q2_K_XL hf.co/Lamapi/next-4b:F16


gemma4:latest                                             c6eb396dbd59    9.6 GB    17 seconds ago
hf.co/l-nmch/bge-reranker-v2-m3-Q8_0-GGUF:Q8_0            c6fa98e901b5    635 MB    2 months ago
hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q2_K_L    57e4fbeb80e7    11 GB     2 months ago
deepseek-r1:8b                                            6995872bfe4c    5.2 GB    2 months ago
gemma3:4b                                                 a2af6cc3eb7f    3.3 GB    2 months ago
nomic-embed-text:v1.5                                     0a109f422b47    274 MB    2 months ago
qwen2.5-coder:7b-instruct-q4_K_M                          dae161e27b0e    4.7 GB    2 months ago
codellama:13b-instruct-q5_K_M                             d4a5d7a6ca94    9.2 GB    2 months ago
yi-coder:9b-chat-q5_K_M                                   d4b375d4e224    6.3 GB    2 months ago
llama3.2:3b                                               a80c4f17acd5    2.0 GB    2 months ago