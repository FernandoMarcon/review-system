# Local LLM Mastery on a 6-GB GTX 1660: Zero-Cost, CLI-Driven Summaries & Anki Cards

## Executive Summary

For your specific hardware (AMD Ryzen 7 5700X, 62GB RAM, NVIDIA GeForce GTX 1660 6GB) and usage goal of processing markdown notes for summaries and Anki cards via the Ubuntu CLI, the optimal strategy is to use the **Ollama** inference runtime due to its exceptional ease of installation and use. [executive_summary[0]][1] The key to success on your hardware is leveraging model quantization. The recommended approach is to use a high-quality 7-billion-parameter instruct-tuned model, such as **Qwen 2.5 7B Instruct**, quantized to the **Q4_K_M** level. [executive_summary[0]][1] This specific quantization ensures the model's VRAM footprint (approximately 4.7GB) fits comfortably within your GPU's 6GB of VRAM, allowing for fast, GPU-accelerated inference. [executive_summary[19]][2] [hardware_suitability_analysis[1]][1] This setup provides a powerful, private, and entirely free solution that can be easily automated with Python and Bash scripts to create an end-to-end workflow for transforming your notes from Vim, Vimwiki, or Obsidian into structured study materials. [executive_summary[0]][1]

The primary constraint is your GPU's 6GB of VRAM, which makes 7B models the ideal performance sweet spot and 8B models the upper limit before performance degrades significantly. [primary_recommendation.reasoning[0]][3] Your powerful CPU and abundant 62GB of RAM serve as a crucial safety net, allowing the system to offload model layers that don't fit on the GPU, preventing crashes but at a significant speed cost. [hardware_suitability_analysis[0]][4] The recommended workflow involves a Python script using carefully engineered prompts—combining Chain-of-Thought and Few-Shot techniques with a JSON output constraint—to ensure reliable, structured data generation for Anki cards. [prompt_engineering_techniques.description[1]][5] [prompt_engineering_techniques.example_prompt[0]][5] This entire process can be integrated directly into Vim or Obsidian for a seamless, one-command experience. [tool_integration_guide[1]][6]

## 1. Hardware Fit & Constraints — 6 GB VRAM defines the model ceiling

Your PC's specifications are well-suited for running local LLMs, with a specific strategic approach required due to the hardware balance. [hardware_suitability_analysis[0]][4]

### GPU VRAM Ceiling: 7B models fit at Q4_K_M; >8B models throttle speed

Your NVIDIA GeForce GTX 1660 is the most critical component and the primary performance bottleneck. [hardware_suitability_analysis[0]][4] The 6GB of VRAM is sufficient for running small-to-mid-sized LLMs (up to 7-8 billion parameters), but only with the use of quantization. [hardware_suitability_analysis[1]][1] Running unquantized models, which can require 28GB+ for a 7B model, is not feasible. [executive_summary[31]][7] Your `nvidia-smi` output shows that the desktop environment already consumes ~428MiB of VRAM, leaving slightly less than 6GB for the model itself. Research shows that 7B models are the sweet spot for this card, while 8B models push the VRAM limit and often lead to performance degradation as parts of the model are offloaded to the much slower system RAM. [hardware_suitability_analysis[1]][1] [primary_recommendation.reasoning[0]][3]

### CPU & 62GB RAM as a Safety Net for Hybrid Offload

Your CPU and system memory are significant assets. The AMD Ryzen 7 5700X, with its 8 cores and 16 threads, provides powerful processing capability for prompt evaluation and for running model layers that don't fit onto the GPU. [hardware_suitability_analysis[0]][4] Your massive 62GB of RAM is a huge advantage, providing an ample buffer for the operating system and applications, and more importantly, serving as a fallback for model layers if you experiment with models that slightly exceed your VRAM. [executive_summary[32]][8] This hybrid CPU+GPU inference, while slower than pure GPU processing, is made viable by your strong CPU and large RAM, giving you flexibility and preventing out-of-memory errors. [hardware_suitability_analysis[0]][4]

### The Quantization Imperative: 4-bit K-quants are essential

Model quantization is a critical process for running LLMs on your hardware. [quantization_strategy[0]][4] It reduces the model's size by lowering the precision of its numerical weights, for example, from 16 bits down to 4 bits. [executive_summary[23]][9] This drastically decreases the VRAM and storage footprint, making it possible to run these powerful models locally. [quantization_strategy[0]][4]

The primary trade-off is a potential, often minor, reduction in the model's output quality. [quantization_strategy[1]][10] However, modern quantization techniques, particularly the 'K-quants' available in the GGUF format, are designed to minimize this quality loss. [quantization_strategy[0]][4] For your specific setup, the optimal quantization level is **Q4_K_M**. [quantization_strategy[1]][10] This 4-bit quantization offers an excellent balance: it reduces a 7-8 billion parameter model to a manageable size of approximately 4.7-4.9GB, allowing it to fit comfortably on your GPU. [quantization_strategy[2]][2] [hardware_suitability_analysis[1]][1] While higher quality quantizations like Q5_K_M exist (~5.7GB), they leave very little headroom and risk performance drops. [executive_summary[19]][2] Q8_0 (>6.7GB) is too large to be considered. [quantization_strategy[0]][4]

## 2. Runtime Options Benchmark — Ollama wins on frictionless GPU usage

For your goal of a free, CLI-based setup on Ubuntu, two primary runtimes stand out: Ollama and llama.cpp.

### Primary Recommendation: Ollama for Simplicity and Performance

Ollama is recommended for its ease of installation via CLI, seamless integration with Ubuntu, and automatic utilization of GPUs including the NVIDIA GTX 1660. [recommended_llm_runtime[0]][11] [recommended_llm_runtime[3]][12] It provides a seamless, CLI-friendly experience with a one-line installation and automatic NVIDIA GPU utilization, abstracting away much of the complexity of model management. [primary_recommendation.reasoning[0]][3]

### Power-User Alternative: llama.cpp for Maximum Control

llama.cpp is the high-performance C++ inference engine that underpins Ollama. [executive_summary[29]][13] Building it from source provides maximum control over compilation flags and runtime parameters, which is useful for fine-tuning performance. [optimal_runtime_settings.description[0]][14] It supports various backends, including NVIDIA's cuBLAS and the more universal Vulkan. [executive_summary[5]][14]

The single most important setting for llama.cpp is `--n-gpu-layers` (or `-ngl`). [optimal_runtime_settings.description[0]][14] This flag specifies how many model layers to offload to the GPU. Because GPU processing is significantly faster, you should aim to maximize this value. For a 7-8B model with Q4_K_M quantization on your 6GB card, a starting value between **30 and 33** is recommended. [optimal_runtime_settings.recommended_value[0]][15] The optimal value must be found through experimentation: start high (e.g., 35) and decrease if you get out-of-memory errors. [optimal_runtime_settings.recommended_value[0]][15]

## 3. Model Shortlist — 7B instruct models maximize quality per VRAM dollar

The key is to select instruct-tuned models in the 3B to 8B parameter range, quantized to Q4_K_M. This provides the best balance of reasoning ability and performance on your hardware.

### Primary Pick: Qwen 2.5 7B Instruct (Q4_K_M)

This model is the top recommendation as it balances strong performance, high quality for summarization and structured data generation, and a manageable VRAM footprint. [primary_recommendation.reasoning[0]][3] The Qwen model family is known for its comprehensive capabilities. [executive_summary[14]][16] The Q4_K_M quantization brings its size to approximately 4.7GB, fitting comfortably on your GPU for fast, accelerated inference. [recommended_llm_models[1]][1]

### Comparison of Recommended Models

| Model Name | Parameters | Rec. Quantization | VRAM (GB) | Strengths & Suitability | License |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Qwen 2.5 7B Instruct** | 7B | Q4\_K\_M | ~4.7 | Balanced performance and quality for summarization and Anki-style card generation. [recommended_llm_models.1.strengths_and_suitability[0]][10] | Apache 2.0 |
| **Llama 3 8B Instruct** | 8B | Q4\_K\_M | ~4.7 | Excellent summarization and question generation performance for the VRAM available. | Meta Llama 3 Community |
| **Mistral 7B Instruct** | 7B | Q4\_K\_M | ~4.1 | Optimized for speed and smaller runtime requirements; a very fast alternative. | Apache 2.0 [alternative_models_and_fallbacks.0.model_name[1]][17] |
| **Phi-3.5 Instruct** | 3.5B | Q4\_K\_M | ~2.1 | Optimized for efficient performance with limited resources; very lightweight. [recommended_llm_models.2.strengths_and_suitability[0]][10] | MIT License [alternative_models_and_fallbacks[5]][18] |
| **Llama 3.2 3B** | 3B | Q4\_K\_M | ~1.9 | Minimal VRAM requirement, streamlined for simple prompt tasks. [alternative_models_and_fallbacks.1.reason_as_alternative[0]][19] | Meta Llama 3 Community |

The key takeaway is that 7B models offer a great balance, while the 8B Llama 3 model is more capable but will be slower. The 3B/3.5B models are extremely fast but may produce less detailed or nuanced output. [alternative_models_and_fallbacks.1.expected_tradeoff[0]][20]

## 4. Installation & Optimization Playbook — From driver to inference in 30 minutes

This section provides a complete, step-by-step guide to get your system ready for local inference.

### Reliable NVIDIA Driver & CUDA 12.x Setup Checklist

Your `nvidia-smi` output shows a working driver (535.247.01) and CUDA 12.2, which is sufficient. However, for a clean setup on Ubuntu 24.04, the following steps are recommended. [installation_and_setup_guide.nvidia_driver_and_cuda_setup[0]][11]

1. **Clean Previous Installations (Optional but Recommended):**
 ```bash
 sudo apt-get remove --purge '^nvidia-*' '^cuda-*'
 sudo apt autoremove
 ```
2. **Install Drivers from PPA for Stability:**
 ```bash
 sudo add-apt-repository ppa:graphics-drivers/ppa --yes
 sudo apt-get update
 sudo apt-get install nvidia-driver-570 -y

# Or the latest stable version from the PPA
 ```
3. **Install CUDA Toolkit:** Ollama and llama.cpp need the toolkit to communicate with the driver. [installation_and_setup_guide.nvidia_driver_and_cuda_setup[0]][11]
 ```bash
 wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
 sudo dpkg -i cuda-keyring_1.1-1_all.deb
 sudo apt-get update
 sudo apt-get install cuda-toolkit -y
 ```
4. **Reboot and Verify:**
 ```bash
 sudo reboot
 ```
 After rebooting, run `nvidia-smi` to confirm the driver and CUDA version are displayed correctly.

### Ollama Setup and Configuration

Ollama is the simplest way to get started. [installation_and_setup_guide.ollama_setup[0]][11]

1. **Install Ollama:**
 ```bash
 curl -fsSL https://ollama.com/install.sh | sh
 ```
2. **Pull and Run a Model:**
 ```bash

# Pull the recommended Qwen model with a specific quantization
 ollama pull qwen:7b-chat-v1.5-q4_K_M

# Run it interactively
 ollama run qwen:7b-chat-v1.5-q4_K_M
 ```
3. **Enable Network Access (Optional):** To use a web UI, you must configure Ollama to accept connections from other devices on your network. [installation_and_setup_guide.ollama_setup[0]][11]
 ```bash

# Edit the service file
 sudo systemctl edit ollama.service
 ```
 Add the following content, then save and exit:
 ```ini
 [Service]
 Environment="OLLAMA_HOST=0.0.0.0:11434"
 ```
 Apply the changes:
 ```bash
 sudo systemctl daemon-reload
 sudo systemctl restart ollama
 ```

### llama.cpp Power-User Build (Optional)

Building from source gives you access to the latest features and maximum control. 

1. **Clone and Build with cuBLAS:**
 ```bash
 git clone https://github.com/ggerganov/llama.cpp.git
 cd llama.cpp
 LLAMA_CUBLAS=1 make
 ```
2. **Acquire Models from Hugging Face:** Search for GGUF models (e.g., from "TheBloke") and download the file ending in `-Q4_K_M.gguf`. [installation_and_setup_guide.model_acquisition[0]][11]
3. **Run Inference with GPU Offloading:**
 ```bash
./main -m /path/to/your/model-Q4_K_M.gguf -p "Your prompt" -n 256 -ngl 33
 ```
 The `-ngl 33` flag tells it to offload 33 layers to the GPU. Experiment with this number to find the maximum that fits in your VRAM. 

## 5. End-to-End Markdown Automation — Turn notes into summaries & Anki decks

This workflow uses a Python script to interact with the Ollama API and a Bash script to process your notes in batches. [markdown_processing_workflow[0]][21]

### Prompt Engineering Recipe: Few-Shot + CoT + JSON Schema

To get reliable, structured output from smaller models, a sophisticated prompt is necessary. This approach combines three techniques:
1. **Chain-of-Thought (CoT):** Instructs the model to "think step-by-step," breaking down the task into a logical sequence. [prompt_engineering_techniques.description[0]][22]
2. **Few-Shot Prompting:** Provides concrete examples of the desired output format, showing the model exactly what you want. [prompt_engineering_techniques.description[0]][22]
3. **JSON Output Constraint:** Explicitly tells the model to return its answer in a valid JSON format, making it easy for your script to parse. [prompt_engineering_techniques.technique[0]][22]

Here is an example prompt incorporating these techniques:
```
I want you to act as an expert flashcard creator. Generate a deck of Anki-style flashcards from the provided technical text. Let's do this step-by-step:
1. First, carefully read and understand the provided text.
2. Second, identify the key facts, concepts, and definitions.
3. Third, for each key point, create a single, atomic flashcard with a clear question and a concise answer. The answer should be a single key fact.

Generate the final output as a single JSON array of objects. Each object must have a 'question' key and an 'answer' key. Do not include any other text or explanation outside of the JSON array.

Here are some examples of the desired output format:
[
 {
 "question": "What is the primary function of a GPU?",
 "answer": "To accelerate graphics rendering and parallel computations."
 },
 {
 "question": "What does VRAM stand for?",
 "answer": "Video Random Access Memory."
 }
]

Now, use the following text to generate the flashcards in the specified JSON format:

[Your Technical Markdown Text Here]
```
[prompt_engineering_techniques.example_prompt[0]][5]

### Python + Bash Pipeline Architecture

#### Part 1: Python Script for Anki Card Generation (`generate_cards.py`)
This script takes a markdown file as input, sends its content to the LLM with the engineered prompt, and saves the resulting Q&A pairs to a CSV file.

**Prerequisites:** `pip install ollama python-frontmatter`

```python
import ollama
import frontmatter
import json
import csv
import sys
import os

def generate_anki_cards(file_path):
 print(f"Processing file: {file_path}")

# 1. Pre-processing: Read the markdown file
 try:
 with open(file_path, 'r', encoding='utf-8') as f:
 post = frontmatter.load(f)
 content = post.content
 if not content.strip():
 print("File is empty or has no content. Skipping.")
 return
 except Exception as e:
 print(f"Error reading file {file_path}: {e}")
 return

# 2. Prompt Construction
 prompt = f"""
 You are an expert study assistant. Your task is to create high-quality, atomic flashcards for Anki from the following text. Follow these steps:
 1. Read the text carefully to understand the key concepts, definitions, and facts.
 2. Identify distinct pieces of information that are suitable for a question-and-answer format.
 3. For each piece of information, create a single, clear, and unambiguous question.
 4. Provide a concise, accurate answer. The answer should be a single key fact, term, or concept.
 5. Format the output as a valid JSON array of objects, where each object has a "question" and "answer" key. Do not include any other text or explanations outside of the JSON array.

 Here is an example of the desired output format:
 [
 {{
 "question": "What is the primary function of a CPU?",
 "answer": "To execute instructions."
 }}
 ]

 Now, generate flashcards from the following text:

 --- TEXT ---
 {content}
 --- END TEXT ---
 """

# 3. LLM Inference
 try:
 response = ollama.chat(
 model='qwen:7b-chat-v1.5-q4_K_M',

# Or llama3:8b-instruct-q4_K_M
 messages=[{'role': 'user', 'content': prompt}],
 options={'temperature': 0.2}
 )
 response_content = response['message']['content']
 
 json_start = response_content.find('[')
 json_end = response_content.rfind(']') + 1
 if json_start == -1 or json_end == 0:
 print("Error: No JSON array found in the LLM response.")
 return

 cards = json.loads(response_content[json_start:json_end])

 except Exception as e:
 print(f"Error during LLM inference or JSON parsing: {e}")
 return

# 4. Post-processing: Save to CSV
 if not cards:
 print("No cards were generated.")
 return

 output_filename = os.path.splitext(os.path.basename(file_path))[0] + '_cards.csv'
 with open(output_filename, 'w', newline='', encoding='utf-8') as f:
 writer = csv.writer(f)
 for card in cards:
 if 'question' in card and 'answer' in card:
 writer.writerow([card['question'], card['answer']])
 
 print(f"Successfully generated {len(cards)} cards. Saved to {output_filename}")

if __name__ == "__main__":
 if len(sys.argv) != 2:
 print("Usage: python generate_cards.py <path_to_markdown_file>")
 sys.exit(1)
 generate_anki_cards(sys.argv[1])
```
[markdown_processing_workflow[0]][21]

#### Part 2: Bash Script for Batch Processing (`process_notes.sh`)
This script finds all `.md` files in a specified directory and runs the Python script on them.

```bash
#!/bin/bash

# Directory containing your markdown notes
NOTES_DIR="/path/to/your/vimwiki/or/obsidian/vault"

# Check if the directory exists
if [ ! -d "$NOTES_DIR" ]; then
 echo "Error: Notes directory not found at $NOTES_DIR" >&2
 exit 1
fi

# Find all markdown files and process them
find "$NOTES_DIR" -type f -name "*.md" | while read -r filepath; do
 echo "----------------------------------------------------"
 python3 /path/to/your/scripts/generate_cards.py "$filepath"
done

echo "----------------------------------------------------"
echo "Batch processing complete."
```
[markdown_processing_workflow[0]][21]

### Vim / Obsidian Command Hooks for Zero-Friction Calls

You can trigger these scripts directly from your editors.

* **For Vim/Vimwiki:** Add this to your `~/.vimrc` to create a command `:AnkiGen` that processes the current file. [tool_integration_guide[1]][6]
 ```vim
 command! AnkiGen !python3 /path/to/your/scripts/generate_cards.py %
 ```
* **For Obsidian:** Use the "Shell Commands" community plugin to create a command that runs the Python script on the active note (`{{file_path}}`). [tool_integration_guide[0]][21]

### Anki Import Paths: CSV, Anki-Connect, mdanki

The generated CSV file can be directly imported into Anki via `File > Import`. [prompt_engineering_techniques.example_prompt[0]][5] Map the first column to `Front` and the second to `Back`. For more advanced automation, you can modify the script to use the `Anki-Connect` add-on to push cards directly, or to generate markdown compatible with tools like `mdanki` or `Yanki`. [tool_integration_guide[2]][23] [tool_integration_guide[0]][21]

## 6. Performance & Cost Benchmarks — Realistic speeds and resource draw

Performance on your GTX 1660 is highly dependent on the model size and quantization. All options are free to install and use.

### Speed Table: Tokens/sec by Model & Quant on GTX 1660

| Model Name | Quantization | Prompt Eval Speed (tok/s) | Generation Speed (tok/s) | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Llama 3.1 8B Instruct** | Q4\_K - Medium | 129.0 | **9.0** | Pushes the 6GB VRAM limit, leading to slower generation. [performance_benchmarks.notes[0]][24] |
| **Llama 2 7B** | 4-bit | ~30-40 | ~30-40 | A good baseline, runs smoothly with high GPU utilization. [primary_recommendation.reasoning[0]][3] |
| **Mistral 7B** | 4-bit | ~40 | ~40 | Excellent performance, often one of the fastest in the 7B class. [primary_recommendation.reasoning[0]][3] |
| **Llama 3.2 3B** | 4-bit | >38 | >38 | Very fast due to its small size, ideal for quick, simple tasks. [recommended_llm_models[1]][1] |

The key takeaway is the trade-off between prompt evaluation (processing the input) and generation (creating new text). Larger models like Llama 3 8B are fast at understanding the prompt but slower at generating the answer because of the VRAM bottleneck. [performance_benchmarks.notes[0]][24]

## 7. Licensing & Compliance — Know the fine print before sharing decks

Since you are running everything locally, your data and notes remain completely private. However, the models themselves have licenses you must adhere to, especially if you share the generated output (e.g., an Anki deck).

### Llama 3 Community License Obligations

The Llama 3 license is permissive but has key requirements. [licensing_and_privacy_summary.license_type[0]][25]
* **Commercial Use:** Allowed. [licensing_and_privacy_summary.commercial_use_allowed[0]][25] However, if your product or service using it exceeds **700 million monthly active users**, you must request a special license from Meta. [licensing_and_privacy_summary.key_restrictions[0]][26]
* **Attribution:** This is mandatory. [licensing_and_privacy_summary.attribution_required[0]][25] If you build a service with it, you must prominently display "Built with Meta Llama 3". [compliance_checklist.details[0]][25] If you distribute the model or derivatives, you must include a copy of the license and a `Notice` file with the full copyright text. [compliance_checklist.details[0]][25]
* **Use of Outputs:** You cannot use the outputs of Llama 3 to improve any other large language model (except for another Llama 3 model). [licensing_and_privacy_summary.key_restrictions[0]][26]

### Apache 2.0 & MIT Models

Models like **Qwen 2.5**, **Mistral 7B**, and **Phi-3.5** are released under more permissive licenses like Apache 2.0 and MIT. [alternative_models_and_fallbacks.0.model_name[1]][17] [alternative_models_and_fallbacks[5]][18] These generally have fewer restrictions on use and redistribution, typically only requiring that you preserve the original copyright and license notices.

## 8. Risk & Mitigation Checklist

| Risk | Symptom | Mitigation Strategy |
| :--- | :--- | :--- |
| **VRAM Overrun** | Model fails to load with "CUDA out of memory" error; system becomes unresponsive. [alternative_models_and_fallbacks[22]][27] | Use a smaller model or a more aggressive quantization (e.g., Q4\_K\_M instead of Q5\_K\_M). If using `llama.cpp`, reduce the `-ngl` value. |
| **Driver/CUDA Mismatch** | Ollama or llama.cpp fails to detect the GPU and falls back to slow CPU-only mode. | Ensure you have installed the correct NVIDIA driver for your kernel and the matching CUDA Toolkit version. Use the PPA for stability on Ubuntu 24.04. [installation_and_setup_guide.nvidia_driver_and_cuda_setup[0]][11] |
| **Prompt Hallucination** | The LLM generates incorrect or nonsensical Anki cards, or fails to follow the JSON format. | Improve the prompt: add more examples (Few-Shot), lower the `temperature` parameter to 0.1 or 0.2 for more deterministic output, and be extremely explicit about the required JSON schema. [executive_summary[12]][5] |
| **Slow Performance** | Generation speed is too slow for interactive use. | Switch to a smaller model (e.g., from 8B to 7B, or 7B to 3B). Ensure maximum GPU offloading is configured correctly. Close other applications that use VRAM (e.g., games, video editors). |

## 9. Upgrade Roadmap — Scaling options for heavier workloads

Your current setup is powerful and well-balanced for your stated goals. However, if your needs grow, there is a clear upgrade path.

### GPU Swap to 12GB+ Unlocks Higher Quality and Speed

The most impactful upgrade would be a new GPU. A used **NVIDIA GeForce RTX 3060 with 12GB of VRAM** is an excellent, cost-effective choice. This would more than double your available VRAM, allowing you to:
* Run 7B and 8B models with higher-quality quantization (e.g., Q5\_K\_M or Q6\_K) for better nuance and accuracy. [quantization_strategy[0]][4]
* Potentially run larger 13B models, which are currently out of reach.
* Achieve significantly faster generation speeds across all models.

### Future Model Horizons

The local LLM space is evolving rapidly. In the future, more efficient architectures like Mixture-of-Experts (MoE) may allow you to run even more powerful models on the same hardware. Keep an eye on new model releases that are optimized for consumer-grade GPUs.

## References

1. *Benchmarking LLMs on Ollama with Nvidia GTX 1660 GPU Server*. https://www.databasemart.com/blog/ollama-gpu-benchmark-gtx1660?srsltid=AfmBOoppz6LUOHpLsnH7oV21AhWJo3pXdAqOGukLHqApIngEwhsTqpqG
2. *HuggingFace - Meta-Llama-3-8B-Instruct GGUF Quantization Guide*. https://huggingface.co/bartowski/Meta-Llama-3-8B-Instruct-GGUF
3. *Benchmarking LLMs on Ollama with Nvidia GTX 1660 GPU Server*. https://www.databasemart.com/blog/ollama-gpu-benchmark-gtx1660?srsltid=AfmBOoo_DwtapVgZaDeNvgLvnQuIjfIENkYsEQ9fCtdb8_OJ5Bczj2j5
4. *Demystifying LLM Quantization Suffixes: What Q4_K_M, Q8_0, and Q6_K Really Mean*. https://medium.com/@paul.ilvez/demystifying-llm-quantization-suffixes-what-q4-k-m-q8-0-and-q6-k-really-mean-0ec2770f17d3
5. *Prompt engineering case study on Anki cards (Anki Forums)*. https://forums.ankiweb.net/t/casting-a-spell-on-chatgpt-let-it-write-anki-cards-for-you-a-prompt-engineering-case/27907
6. *Using vim and a custom markdown syntax to make anki ...*. https://www.reddit.com/r/Anki/comments/ickl78/using_vim_and_a_custom_markdown_syntax_to_make/
7. *LLaMA 7B GPU Memory Requirement - 🤗Transformers*. https://discuss.huggingface.co/t/llama-7b-gpu-memory-requirement/34323
8. *A couple of questions on using GGML/GGUF to maximise ...*. https://www.reddit.com/r/LocalLLaMA/comments/16awtiy/a_couple_of_questions_on_using_ggmlgguf_to/
9. *Run your private LLM: Falcon-7B-Instruct with less than 6GB ...*. https://vilsonrodrigues.medium.com/run-your-private-llm-falcon-7b-instruct-with-less-than-6gb-of-gpu-using-4-bit-quantization-ff1d4ffbabcc
10. *llama.cpp quantization discussion*. https://github.com/ggml-org/llama.cpp/discussions/2094
11. *Daniel Chote's Project Blog: Ubuntu 24-04 Nvidia Drivers Ollama*. https://projectable.me/ubuntu-24-04-nvidia-drivers-ollama/
12. *Benchmarking LLMs on Nvidia GTX 1660 GPU*. https://www.databasemart.com/blog/ollama-gpu-benchmark-gtx1660?srsltid=AfmBOoqeKyruvmKqQQSVrc3h24j_kfe2x2wTxPnxdRVZXfWdeK6hjg8W
13. *Local LLM Guide: GGML - by Matt Hoffner*. https://matthoffner.substack.com/p/local-llm-guide-ggml
14. *llama.cpp*. http://github.com/ggerganov/llama.cpp
15. *llama.cpp guide - Running LLMs locally, on any hardware ...*. https://steelph0enix.github.io/posts/llama-cpp-guide/
16. *The Ultimate Guide to Qwen Model*. https://www.inferless.com/learn/the-ultimate-guide-to-qwen-model
17. *Mistral 7B*. https://mistral.ai/news/announcing-mistral-7b
18. *phi-3.5-moe-instruct Model by Microsoft*. https://build.nvidia.com/microsoft/phi-3_5-moe
19. *How to Run a Local LLM with Ubuntu - Jeremy Morgan's*. https://www.jeremymorgan.com/blog/generative-ai/local-llm-ubuntu/
20. *llama.cpp with CUDA on Ubuntu Server : r/LocalLLaMA - Reddit*. https://www.reddit.com/r/LocalLLaMA/comments/1fdut9l/llamacpp_with_cuda_on_ubuntu_server/
21. *Yanki: A Markdown to Anki synchronization tool*. https://www.reddit.com/r/Anki/comments/1dzam3l/yanki_a_new_markdown_to_anki_synchronization_tool/
22. *Practical Techniques to constraint LLM output in JSON format*. https://mychen76.medium.com/practical-techniques-to-constraint-llm-output-in-json-format-e3e72396c670
23. *ashlinchak/mdanki: Markdown to Anki converter - GitHub*. https://github.com/ashlinchak/mdanki
24. *Database Mart GTX1660 Benchmark for LLMs with Ollama*. https://www.databasemart.com/blog/ollama-gpu-benchmark-gtx1660?srsltid=AfmBOoobmGgnbK-UZg759JQriMTOMBWGY7VVBMTPPd93uyxUod5vvaFg
25. *META LLAMA 3 COMMUNITY LICENSE AGREEMENT (Meta Llama 3 8B-Instruct)*. https://huggingface.co/meta-llama/Meta-Llama-3-8B-Instruct
26. *META Llama 3 Community License Agreement*. https://www.llama.com/llama3/license/
27. *Solving "CUDA out of memory" when fine-tuning GPT-2 ...*. https://stackoverflow.com/questions/70606666/solving-cuda-out-of-memory-when-fine-tuning-gpt-2-huggingface
