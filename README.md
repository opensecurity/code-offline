# Pi Coding Agent + Llama.cpp Stack

A localized, containerized development environment for running the [pi coding agent](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent) backed by [llama.cpp](https://github.com/ggml-org/llama.cpp). This stack lets you run local models and the agent without needing external API dependencies, keeping your code and data private. It supports both CPU and NVIDIA GPU setups via a unified interface.

## Prerequisites

- Docker
- Docker Compose
- NVIDIA Container Toolkit (if you want to use the GPU mode)

## Configuration

Settings are managed via the `.env` file. Copy the example file to get started:

```bash
cp .env.example .env
```

You can change the Hugging Face repo and model file in `.env` to try different models. By default, it downloads the highly-capable Qwen 3.5 models using the preferred `UD-Q4_K_XL` quantization for the best balance of speed and precision. 

## Usage

The environment is managed through a Makefile. The default mode is CPU. To use GPU acceleration, just append `MODE=gpu` to any command.

### Building

Build the images before starting:

```bash
make build
make build MODE=gpu
```

If you need to pull fresh base images and rebuild without cache:

```bash
make upgrade
```

### Starting the backend

Start the llama.cpp server in the background. It will automatically download the models specified in your `.env` file to the local `models` directory on its first run.

```bash
make start
make start MODE=gpu
```

You can check the download progress or server status by tailing the logs:

```bash
make logs
```

### Running the agent

Once the LLM backend is up and running, you can drop into the interactive agent terminal. This spins up a temporary container that attaches to your current TTY and cleans itself up when you exit.

```bash
make agent
make agent MODE=gpu
```

### Stopping

To spin down the background services:

```bash
make stop
```

To nuke all containers, networks, and volumes (this will not delete your downloaded models or workspace code):

```bash
make clean
```

## Storage

Volumes are mapped to your host machine for persistence:

- `workspace/` - Your actual codebase. Mounted inside the agent.
- `models/` - Hugging Face cache. Shared with the llama.cpp container so you don't redownload models.
- `agent_data/` - Holds the agent's history, auth, and state.


## Agent configs
agent_data/agent/models.json
```json
{
  "providers": {
    "llama-cpp": {
      "baseUrl": "http://llm:8001/v1",
      "api": "openai-completions",
      "apiKey": "none",
      "models": [
        {
          "id": "unsloth/Qwen3.5-4B-GGUF"
        },
        {
          "id": "unsloth/Qwen3.5-35B-A3B-GGUF"
        }
      ]
    }
  }
}

```

agent_data/agent/settings.json
```json
{
  "defaultProvider": "llama-cpp",
  "defaultModel": "unsloth/Qwen3.5-4B-GGUF",
  "lastChangelogVersion": "0.55.4"
}
```

---

Brought to you by [brain.fr](https://brain.fr)
