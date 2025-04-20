#!/bin/bash

set -e

# Activate conda environment with a more robust approach
echo "Activating conda environment..."
source /opt/conda/etc/profile.d/conda.sh
# Use --no-plugins option to avoid potential plugin issues
CONDA_NO_PLUGINS=true conda activate bitnet-cpp || {
    echo "Failed to activate with conda activate directly. Trying alternative approach..."
    export PATH="/opt/conda/envs/bitnet-cpp/bin:$PATH"
    # Make sure we're using the right Python
    which python
    python --version
}

# Install OpenMP development libraries (needed for parallel processing)
echo "Installing OpenMP development libraries..."
apt-get update && apt-get install -y libomp-dev

# Clone the BitNet repository if it doesn't exist
if [ ! -d "/workspaces/bitnet" ]; then
    echo "Cloning BitNet repository..."
    git clone --recursive https://github.com/microsoft/BitNet.git /workspaces/bitnet
fi

# Install Python requirements
cd /workspaces/bitnet
echo "Installing Python requirements..."
pip install -r requirements.txt

# Install Hugging Face CLI using pip instead of conda
echo "Installing Hugging Face CLI..."
pip install huggingface_hub
pip install huggingface_hub[cli]

# Add Hugging Face CLI to PATH
echo "Adding Hugging Face CLI to PATH..."
export PATH="$PATH:$HOME/.local/bin"
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc

# Set up Python path
echo "Setting up PYTHONPATH..."
echo "export PYTHONPATH=\$PYTHONPATH:/workspaces/bitnet" >> ~/.bashrc

# Create or link the required kernel header file
echo "Setting up kernel header files..."
mkdir -p /workspaces/bitnet/include
# Check if any of the preset kernel files exist and create a symbolic link to one of them
if [ -f "/workspaces/bitnet/preset_kernels/bitnet_b1_58-3B/bitnet-lut-kernels-tl1.h" ]; then
    echo "Creating header file using bitnet_b1_58-3B TL1 kernel..."
    cp "/workspaces/bitnet/preset_kernels/bitnet_b1_58-3B/bitnet-lut-kernels-tl1.h" "/workspaces/bitnet/include/bitnet-lut-kernels.h"
elif [ -f "/workspaces/bitnet/preset_kernels/bitnet_b1_58-large/bitnet-lut-kernels-tl1.h" ]; then
    echo "Creating header file using bitnet_b1_58-large TL1 kernel..."
    cp "/workspaces/bitnet/preset_kernels/bitnet_b1_58-large/bitnet-lut-kernels-tl1.h" "/workspaces/bitnet/include/bitnet-lut-kernels.h"
elif [ -f "/workspaces/bitnet/preset_kernels/Llama3-8B-1.58-100B-tokens/bitnet-lut-kernels-tl1.h" ]; then
    echo "Creating header file using Llama3 TL1 kernel..."
    cp "/workspaces/bitnet/preset_kernels/Llama3-8B-1.58-100B-tokens/bitnet-lut-kernels-tl1.h" "/workspaces/bitnet/include/bitnet-lut-kernels.h"
else
    echo "Warning: Could not find a suitable bitnet-lut-kernels file. Creating an empty one."
    touch "/workspaces/bitnet/include/bitnet-lut-kernels.h"
    echo "#pragma once" > "/workspaces/bitnet/include/bitnet-lut-kernels.h"
    echo "#include \"ggml-bitnet.h\"" >> "/workspaces/bitnet/include/bitnet-lut-kernels.h"
fi

# Configure CMake for BitNet with explicit OpenMP flags
echo "Configuring CMake for BitNet..."
mkdir -p /workspaces/bitnet/build
cd /workspaces/bitnet/build
cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DGGML_OPENMP=ON ..

echo "BitNet development environment setup complete!"