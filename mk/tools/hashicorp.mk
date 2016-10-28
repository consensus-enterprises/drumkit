define HASHICORP_template 

include $(MK_DIR)/mk/tools/hashicorp/$(1).mk

$(1) ?= $(BIN_DIR)/$(1)

hashicorp-apps: $(1)

debug-hashicorp-apps: debug-$(1)
debug-$(1):
	@echo NAME: $$($(1)_NAME)
	@echo RELEASE: $$($(1)_RELEASE)
	@echo DOWNLOAD_URL: $$($(1)_DOWNLOAD_URL)
	@echo DEPENDENCIES: $$($(1)_DEPENDENCIES)
	@echo EXECUTABLE: $(BIN_DIR)/$(1)
	@echo SOURCE: $(SRC_DIR)/$(1)
	@echo HASHICORP: $(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE)
	@echo command w/options: $(1) $$($(1)_OPTIONS)
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

deps: deps-$(1)
deps-$(1):
	@echo Installing $$($(1)_NAME) dependencies.
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install $$($(1)_DEPENDENCIES)

install-$(1): init $(BIN_DIR)/$(1)
$(1): install-$(1)

$(BIN_DIR)/$(1): $(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE)/$(1)
	@echo Installing the $$($(1)_RELEASE) release of $$($(1)_NAME).
	@ln -sf $(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE)/$(1) $(BIN_DIR)/$(1)
	@chmod a+x $(BIN_DIR)/$(1)
	@. $(MK_DIR)/scripts/hacking.sh && \
	$(1) version

$(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE)/$(1): $(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE)/$(1)-$$($(1)_RELEASE).zip
	@echo Unzipping $$($(1)_NAME).
	@cd $(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE) && unzip $(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE)/$(1)-$$($(1)_RELEASE).zip
	@touch $(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE)/$(1)

$(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE)/$(1)-$$($(1)_RELEASE).zip:
	@echo Downloading the $$($(1)_RELEASE) release of $$($(1)_NAME).
	@mkdir -p $(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE)
	@curl -SsL $$($(1)_DOWNLOAD_URL) -z $(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE)/$(1)-$$($(1)_RELEASE).zip -o $(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE)/$(1)-$$($(1)_RELEASE).zip

endef

hashicorp-apps ?= packer

$(foreach hashicorp-app,$(hashicorp-apps),$(eval $(call HASHICORP_template,$(hashicorp-app))))

# vi:syntax=makefile
