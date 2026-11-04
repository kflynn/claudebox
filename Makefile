.PHONY: all claudebox

all: claudebox

claudebox:
	docker buildx build -t claudebox:latest .
