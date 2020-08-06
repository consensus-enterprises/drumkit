mustache_NAME         ?= mustache
mustache_RELEASE      ?= v1.0.0
mustache_OS           ?= $(shell echo "$(OS)" | tr '[:upper:]' '[:lower:]')
mustache_DOWNLOAD_URL ?= https://github.com/quantumew/mustache-cli/releases/download/$(mustache_RELEASE)/mustache-cli-$(mustache_OS)-amd64.zip
mustache_ZIP          ?= $(mustache_NAME)-$(mustache_RELEASE)-$(mustache_OS).zip

mustache: $(BIN_DIR)/mustache

$(BIN_DIR)/mustache: $(BIN_DIR) $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE)/$(mustache_NAME)
	@if [ -f $(BIN_DIR)/mustache ]; \
  then \
      echo "$@ exists; do 'make clean-mustache mustache' to delete it and force re-download."; \
  else  \
      ln -s $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE)/$(mustache_NAME) $@ ; \
  fi
	mustache --version

$(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE)/$(mustache_NAME):
	@echo "Downloading Mustache."
	@mkdir -p $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE)
	@cd $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE) && curl -o $(mustache_ZIP) -sSL $(mustache_DOWNLOAD_URL) && unzip $(mustache_ZIP) > /dev/null

clean-mustache:
	@echo "Cleaning Mustache."
	@rm -rf $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE) $(BIN_DIR)/mustache
