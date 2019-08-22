define DMG_template 

include $(MK_DIR)/mk/tools/os_pkg/dmg/$(1).mk

$(1) ?= $(BIN_DIR)/$(1) $$(OPTIONS)

dmgs: $(1)

debug-dmgs: debug-$(1)
debug-$(1):
	@echo NAME: $$($(1)_NAME)
	@echo RELEASE: $$($(1)_RELEASE)
	@echo DOWNLOAD_URL: $$($(1)_DOWNLOAD_URL)
#	@echo DEPENDENCIES: $$($(1)_DEPENDENCIES)
#	@echo EXECUTABLE: $(BIN_DIR)/$(1)
#	@echo SOURCE: $(SRC_DIR)/$(1)
#	@echo PHAR: $(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE).phar
	@echo command w/options: $(1) $$($(1)_OPTIONS)
	@echo

install-help: install-$(1)-help
install-$(1)-help:
	@echo "make $(1)"
	@echo "  Install $$($(1)_NAME)."

install-release-help: install-release-$(1)-help
install-release-$(1)-help:
	@echo "make $(1) $(1)_RELEASE=$$($(1)_RELEASE)"
	@echo "  Install the $$($(1)_RELEASE) release of $$($(1)_NAME)."

clean-all: clean-$(1)
clean-$(1):
	@echo Removing $$($(1)_NAME).
	echo How does one uninstall a dmg?
	rm .drumkit/install/dmg/$(1)

#deps: deps-$(1)
#deps-$(1):
#	@echo Installing $$($(1)_NAME) dependencies.
#	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install $$($(1)_DEPENDENCIES)

install-$(1): init-mk $(SRC_DIR)/dmg/$(1)/release/$$($(1)_RELEASE)/
$(1): install-$(1)

$(BIN_DIR)/$(1): $(SRC_DIR)/dmg/$(1)/release/$$($(1)_RELEASE)/$(1)-$$($(1)_RELEASE).dmg
	@echo Installing the $$($(1)_RELEASE) release of $$($(1)_NAME).
#	@ln -sf $(SRC_DIR)/$(1)/$(1)-$$($(1)_RELEASE).dmg $(BIN_DIR)/$(1)
#	@chmod a+x $(BIN_DIR)/$(1)
	@. $(MK_DIR)/scripts/hacking.sh && \
	$(1) --version

#$(SRC_DIR)/dmg/$(1)/release/$$($(1)_RELEASE)/:

#$(SRC_DIR)/dmg/$(1)/release/$$($(1)_RELEASE)/$(1)-$$($(1)_RELEASE).dmg: $(SRC_DIR)/dmg/$(1)/release/$$($(1)_RELEASE)/
$(SRC_DIR)/dmg/$(1)/release/$$($(1)_RELEASE)/:
	mkdir -p $(SRC_DIR)/dmg/$(1)/release/$$($(1)_RELEASE)/
	echo Downloading the $$($(1)_RELEASE) release of $$($(1)_NAME).
	curl -SsL $$($(1)_DOWNLOAD_URL) -z $(SRC_DIR)/dmg/$(1)/release/$$($(1)_RELEASE)/$(1)-$$($(1)_RELEASE).dmg -o $(SRC_DIR)/dmg/$(1)/release/$$($(1)_RELEASE)/$(1)-$$($(1)_RELEASE).dmg
endef

DMGS = vagrant virtualbox

$(foreach dmg,$(DMGS),$(eval $(call DMG_template,$(dmg))))

# vi:syntax=makefile
