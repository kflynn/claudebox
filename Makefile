.PHONY: all claudebox local publish check

all: claudebox

export BUILD_ARCH ?= amd64,arm64
export REGISTRY ?= ghcr.io/kflynn/claudebox

LOCAL_ARCH := $(shell uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/')

# Snapshot builds load one image per arch, tagged $(REGISTRY):snapshot-<arch>.
# Retag the native one as claudebox:latest for the claudebox wrapper script.
claudebox:
	goreleaser release --snapshot --clean
	docker tag $(REGISTRY):snapshot-$(LOCAL_ARCH) claudebox:latest

local:
	$(MAKE) BUILD_ARCH=$(LOCAL_ARCH) claudebox

# Builds and pushes a multiarch manifest for the current git tag.
publish:
	goreleaser release --clean

check:
	goreleaser check
