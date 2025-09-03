#!/bin/bash
# --- System Specification Report for Local LLM ---

echo "--- 🖥️  System & OS ---"
echo "OS Version:"
lsb_release -a 2>/dev/null || cat /etc/os-release
echo \"
echo "Architecture: $(uname -m)"
echo \"

echo "--- 🧠 CPU ---"
lscpu | grep -E 'Model name|CPU\(s\)|Core\(s\) per socket|Socket\(s\)|Thread\(s\) per core|Vendor ID|Architecture|Flags.*(avx|avx2)'
echo \"

echo '--- 💾 RAM (Memory) ---'
free -h
echo \"

echo '--- 🎮 GPU (Graphics) ---'
# This will try nvidia-smi first, if it fails, it will try lspci for other GPUs.
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi
else
    echo "NVIDIA drivers not found. Checking for other GPUs..."
    lspci | grep -E 'VGA|3D'
fi

echo \"

echo "--- 💽 Storage ---"
df -h | grep -E '^/dev/|Filesystem'
