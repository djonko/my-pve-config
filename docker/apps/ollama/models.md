# === 1. Modèle Agent — Qwen3-Coder 30B (IQ3_XXS ~13 Go VRAM) ===
docker exec ollama ollama pull danielsheep/Qwen3-Coder-30B-A3B-Instruct-1M-Unsloth:UD-IQ3_XXS

# === 2. Modèle Autocomplétion — Qwen2.5-Coder 1.5B (~1.5 Go VRAM) ===
docker exec ollama ollama pull qwen2.5-coder:1.5b-base

# === 3. Embeddings RAG — Nomic Embed Text (~0.3 Go VRAM) ===
docker exec ollama ollama pull nomic-embed-text:latest

# === Vérification finale ===
docker exec ollama ollama list