mustache_NAME         ?= mustache
mustache_RELEASE      ?= 1.4.0
mustache_OS           ?= $(shell echo "$(OS)" | tr '[:upper:]' '[:lower:]')
mustache_ARCH         ?= $(shell uname -m)
mustache_DOWNLOAD_URL ?= https://github.com/cbroglie/mustache/releases/download/v$(mustache_RELEASE)/mustache_$(mustache_RELEASE)_$(mustache_OS)_$(mustache_ARCH).tar.gz
mustache_SRC_DIR      ?= $(SRC_DIR)/$(mustache_NAME)/$(mustache_RELEASE)
mustache_TAR          ?= $(mustache_NAME)-$(mustache_RELEASE)-$(mustache_OS).tar.gz

.PHONY: mustache install-mustache clean-mustache

install-mustache: init-mk $(BIN_DIR)/mustache
mustache: install-mustache

$(BIN_DIR)/mustache: $(mustache_SRC_DIR)/$(mustache_NAME)
	@echo "Installing mustache $(mustache_RELEASE)."
	@ln -sf $(mustache_SRC_DIR)/$(mustache_NAME) $@
	@cd $(PROJECT_ROOT) && unset DRUMKIT && source d && \
	  mustache --version

$(mustache_SRC_DIR)/$(mustache_NAME):
	@echo "Downloading mustache release $(mustache_RELEASE)."
	@mkdir -p $(mustache_SRC_DIR)
	@cd $(mustache_SRC_DIR) && curl -o $(mustache_TAR) -sSL $(mustache_DOWNLOAD_URL) && tar -xzf $(mustache_TAR) > /dev/null

clean-mustache:
	@echo "Cleaning mustache."
	@rm -rf $(mustache_SRC_DIR) $(BIN_DIR)/mustache
