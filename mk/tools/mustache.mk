mustache_NAME         ?= mustache
mustache_RELEASE      ?= v1.0.0
mustache_OS           ?= $(shell echo "$(OS)" | tr '[:upper:]' '[:lower:]')
mustache_DOWNLOAD_URL ?= https://github.com/quantumew/mustache-cli/releases/download/$(mustache_RELEASE)/mustache-cli-$(mustache_OS)-amd64.zip

mustache: $(BIN_DIR)/mustache

$(BIN_DIR)/mustache: $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE)/$(mustache_NAME)
	@ln -s $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE)/$(mustache_NAME) $@
	@mustache --version

$(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE)/$(mustache_NAME):
	@echo "Downloading mustache."
	@mkdir -p $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE)
	@cd $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE) && curl -O -sSL $(mustache_DOWNLOAD_URL) && unzip mustache-cli-linux-amd64.zip > /dev/null

clean-mustache:
	@echo "Cleaning mustache."
	@rm -rf $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE) $(BIN_DIR)/mustache
