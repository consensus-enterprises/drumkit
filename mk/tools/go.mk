define GOAPP_template

include $(MK_DIR)/mk/tools/go/$(1).mk

$(1) ?= $(BIN_DIR)/$(1)

goapps: $(1)

debug-goapps: debug-$(1)
debug-$(1):
	@echo NAME: $$($(1)_NAME)
	@echo RELEASE: $$($(1)_RELEASE)
	@echo DOWNLOAD_URL: $$($(1)_DOWNLOAD_URL)
	@echo EXECUTABLE: $(BIN_DIR)/$(1)
	@echo SOURCE: $(SRC_DIR)/$(1)
	@echo GOAPP: $(SRC_DIR)/$(1)/$(1)
	@echo

tools-help-$(1):
	@echo "make $(1)"
	@echo "  Install $$($(1)_NAME)."
	@echo "make $(1) $(1)_RELEASE=$$($(1)_RELEASE)"
	@echo "  Install the $$($(1)_RELEASE) release of $$($(1)_NAME)."

clean-$(1):
	@echo Removing $$($(1)_NAME).
	@rm -f $(BIN_DIR)/$(1)
	@rm -rf $(SRC_DIR)/$(1)

install-$(1): init-mk $(BIN_DIR)/$(1)
$(1): install-$(1)

$(BIN_DIR)/$(1): $(SRC_DIR)/$(1)/$(1)
	@echo Installing the $$($(1)_RELEASE) release of $$($(1)_NAME).
	@ln -sf $(SRC_DIR)/$(1)/$(1) $(BIN_DIR)/$(1)
	@chmod a+x $(BIN_DIR)/$(1)
	@cd $(PROJECT_ROOT) && unset DRUMKIT && source d && \
	$(1) version

$(SRC_DIR)/$(1)/$(1): $(SRC_DIR)/$(1)/$(1).tar.gz
	@cd $(SRC_DIR)/$(1) && tar xzf $(1).tar.gz

$(SRC_DIR)/$(1)/$(1).tar.gz:
	@echo Downloading the $$($(1)_RELEASE) release of $$($(1)_NAME).
	@mkdir -p $(SRC_DIR)/$(1)
	@curl -SsL $$($(1)_DOWNLOAD_URL) -z $(SRC_DIR)/$(1)/$(1).tar.gz -o $(SRC_DIR)/$(1)/$(1).tar.gz

endef

GOAPPS ?= hugo

$(foreach goapp,$(GOAPPS),$(eval $(call GOAPP_template,$(goapp))))

# vi:syntax=makefile
