mustache_NAME         ?= mustache
mustache_RELEASE      ?= v1.0.0
mustache_OS           ?= $(shell echo "$(OS)" | tr '[:upper:]' '[:lower:]')
mustache_DOWNLOAD_URL ?= https://github.com/quantumew/mustache-cli/releases/download/$(mustache_RELEASE)/mustache-cli-$(mustache_OS)-amd64.zip
mustache_ZIP          ?= $(mustache_NAME)-$(mustache_RELEASE)-$(mustache_OS).zip

.PHONY: mustache install-mustache clean-mustache

install-mustache: init-mk $(BIN_DIR)/mustache
mustache: install-mustache

$(BIN_DIR)/mustache: $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE)/$(mustache_NAME)
	@echo "Installing mustache $(mustache_RELEASE)."
	@ln -sf $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE)/$(mustache_NAME) $@
	@cd $(PROJECT_ROOT) && unset DRUMKIT && source d && \
	  mustache --version

$(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE)/$(mustache_NAME):
	@echo "Downloading mustache release $(mustache_RELEASE)."
	@mkdir -p $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE)
	@cd $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE) && curl -o $(mustache_ZIP) -sSL $(mustache_DOWNLOAD_URL) && unzip $(mustache_ZIP) > /dev/null

clean-mustache:
	@echo "Cleaning mustache."
	@rm -rf $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE) $(BIN_DIR)/mustache
