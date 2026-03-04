MODE ?= cpu

.PHONY: help build upgrade start stop agent logs clean

help:
	@echo "🚀 Pi Coding Agent + Llama.cpp Environment"
	@echo ""
	@echo "Usage: make [target] [MODE=cpu|gpu]"
	@echo "Default MODE is 'cpu'."
	@echo ""
	@echo "Available commands:"
	@echo "  make start      - Start the LLM environment in the background"
	@echo "  make agent      - Start and enter the interactive coding agent"
	@echo "  make stop       - Stop the environment"
	@echo "  make logs       - View logs for the running services"
	@echo "  make build      - Build the Docker images"
	@echo "  make upgrade    - Pull latest base images and rebuild without cache"
	@echo "  make clean      - Stop all and remove containers/networks/volumes"
	@echo ""
	@echo "Examples:"
	@echo "  make start                (Starts in CPU mode)"
	@echo "  make start MODE=gpu       (Starts in GPU mode)"
	@echo "  make agent                (Enters agent using CPU mode config)"
	@echo "  make agent MODE=gpu       (Enters agent using GPU mode config)"
	@echo ""

build:
	docker compose -f docker-compose.$(MODE).yml build

upgrade:
	docker compose -f docker-compose.$(MODE).yml build --pull --no-cache

start:
	mkdir -p workspace models agent_data
	chmod 777 models agent_data
	docker compose -f docker-compose.$(MODE).yml up --build -d

stop:
	docker compose -f docker-compose.$(MODE).yml down

agent:
	docker compose -f docker-compose.$(MODE).yml run --rm agent

logs:
	docker compose -f docker-compose.$(MODE).yml logs -f

clean:
	docker compose -f docker-compose.cpu.yml down -v
	docker compose -f docker-compose.gpu.yml down -v
