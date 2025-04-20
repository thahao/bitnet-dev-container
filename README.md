# BitNet Dev Container

## Description
This project provides a Development Container configuration for working with Microsoft's [BitNet](https://github.com/microsoft/BitNet) - the official inference framework for 1-bit LLMs (Large Language Models). The Dev Container simplifies setup by providing a consistent development environment with all necessary dependencies pre-configured.

## What is BitNet?

BitNet is Microsoft's framework for 1-bit LLMs such as BitNet b1.58. It offers optimized kernels for:
- Fast and lossless inference of 1.58-bit models on CPU
- Significant performance improvements (1.37x to 5.07x speedups on ARM CPUs, 2.37x to 6.17x on x86 CPUs)
- Reduced energy consumption (55.4% to 70.0% on ARM, 71.9% to 82.2% on x86)
- Ability to run 100B BitNet b1.58 models on a single CPU at human-readable speeds (5-7 tokens per second)

## Features
- Automated setup of BitNet development environment
- Pre-configured dependencies and build tools
- Simplified path to running BitNet inference on your local machine
- Support for both x86 and ARM architectures

## Prerequisites
- [Docker](https://www.docker.com/products/docker-desktop/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [VS Code Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Usage

### Setting up the Dev Container

1. Clone this repository:
```bash
git clone https://github.com/yourusername/bitnet-devcontainer.git
cd bitnet-devcontainer
```

2. Open the project in Visual Studio Code:
```bash
code .
```

3. When prompted, click "Reopen in Container" or use the command palette (F1) and select "Remote-Containers: Reopen in Container"

4. The BitNet source code will be automatically downloaded to `/workspaces/bitnet` within the container

### Running BitNet

Once inside the Dev Container, you can work with BitNet:

```bash
# Navigate to BitNet directory
cd /workspaces/bitnet

# Option 1: Run inference with one of the supported models
python run_inference.py --hf-repo 1bitLLM/bitnet_b1_58-3B

# Option 2: Manually download the model and run with local path
huggingface-cli download microsoft/BitNet-b1.58-2B-4T-gguf --local-dir models/BitNet-b1.58-2B-4T
python setup_env.py -md models/BitNet-b1.58-2B-4T -q i2_s

# Now you can run the inference
python run_inference.py --hf-repo models/BitNet-b1.58-2B-4T
```

## Supported Models

The Dev Container supports these BitNet models:
- 1bitLLM/bitnet_b1_58-large (0.7B parameters)
- 1bitLLM/bitnet_b1_58-3B (3B parameters)
- HF1BitLLM/Llama3-8B-1.58-100B-tokens
- tiiuae/Falcon3-1B-Instruct-1.58bit
- tiiuae/Falcon3-3B-Instruct-1.58bit
- tiiuae/Falcon3-7B-Instruct-1.58bit
- tiiuae/Falcon3-10B-Instruct-1.58bit

## Dev Container Configuration

The Dev Container configuration:
1. Sets up a Linux-based environment
2. Installs necessary build tools and dependencies
3. Clones the BitNet repository
4. Configures the build environment
5. Prepares the environment for running inference

## Contributing
Contributions to improve the Dev Container setup are welcome! Please feel free to submit a Pull Request.

## License
This Dev Container configuration is provided under the MIT License, matching the license of the BitNet repository.

## References
- [BitNet GitHub Repository](https://github.com/microsoft/BitNet)
- [BitNet Technical Report](https://arxiv.org/abs/2402.17764)