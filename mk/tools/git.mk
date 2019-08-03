define git_template 

include $(MK_DIR)/mk/tools/git/$(1).mk

$(1) ?= $(BIN_DIR)/$(1) $$($(1)_OPTIONS)

gits: $(1)

debug-gits: debug-$(1)
debug-$(1):
	@echo NAME: $$($(1)_NAME)
	@echo DOWNLOAD_URL: $$($(1)_DOWNLOAD_URL)
	@echo DEPENDENCIES: $$($(1)_DEPENDENCIES)
	@echo PARENT: $$($(1)_PARENT)
	@echo EXECUTABLE: $(BIN_DIR)/$(1)
	@echo SOURCE: $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-latest
	@echo command w/options: $(1) $$($(1)_OPTIONS)
ifeq ($(1), $$($(1)_PARENT))
	@echo RELEASE: $$($(1)_RELEASE)
endif
	@echo

tools-help-$(1):
	@echo "make $(1)"
	@echo "  Install $$($(1)_NAME)."
ifeq ($(1), $$($(1)_PARENT))
	@echo "make $(1) $(1)_RELEASE=$$($(1)_RELEASE)"
	@echo "  Install the $$($(1)_RELEASE) release of $$($(1)_NAME)."
endif

clean-gits: clean-$(1)
clean-$(1):
	@echo Removing $$($(1)_NAME).
	@rm -f $(BIN_DIR)/$(1)
ifeq ($(1), $$($(1)_PARENT))
	@rm -rf $(SRC_DIR)/$(1)
endif

deps: deps-$(1)
deps-$(1): apt-update
	@echo Installing $$($(1)_NAME) dependencies.
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install $$($(1)_DEPENDENCIES)

gits: $$($(1)_COMMANDS)

$(1): init-mk $(BIN_DIR)/$(1)

ifneq ($(1), $$($(1)_PARENT))
$$($(1)_PARENT): $(1)
clean-$$($(1)_PARENT): clean-$(1)
endif

$(BIN_DIR)/$(1): $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-latest/$$($(1)_BIN_DIR)/$(1)
	@echo Installing $$($(1)_NAME).
	@cd $(BIN_DIR) && \
  ln -sf ../src/$$($(1)_PARENT)/$$($(1)_PARENT)-latest/$$($(1)_BIN_DIR)/$(1) $(1)
	@chmod a+x $(BIN_DIR)/$(1)
ifeq ($(1), $$($(1)_PARENT))
ifdef ($(1)_COMMAND))
	@cd $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-latest && \
  $$($(1)_COMMAND)
endif
	@cd $(PROJECT_ROOT) && unset DRUMKIT && source d && \
	$(1) --version
endif

$(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-latest/$$($(1)_BIN_DIR)/$(1): $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-latest

ifeq ($(1), $$($(1)_PARENT))

$(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-latest: $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE)
	@echo Symlinking the $$($(1)_RELEASE) release of $$($(1)_NAME) to $$($(1)_PARENT)-latest.
	@cd $(SRC_DIR)/$$($(1)_PARENT)/ && \
  ln -sf $$($(1)_PARENT)-$$($(1)_RELEASE) $$($(1)_PARENT)-latest

$(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE): $(GIT_EXECUTABLE)
	@echo Cloning the $$($(1)_RELEASE) release of $$($(1)_NAME) via Git.
	@git clone --quiet --depth 1 $$($(1)_DOWNLOAD_URL) $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE)
	@echo Fetching the $$($(1)_RELEASE) release of $$($(1)_NAME).
	@cd $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE) && \
	git fetch origin tag $$($(1)_RELEASE) --no-tags --quiet --depth 1
	@echo Checking out the $$($(1)_RELEASE) release of $$($(1)_NAME).
	@cd $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE) && \
	git checkout --quiet $$($(1)_RELEASE)
	@echo Updating submodules for $$($(1)_NAME).
	@cd $(SRC_DIR)/$$($(1)_PARENT)/$$($(1)_PARENT)-$$($(1)_RELEASE) && \
	git submodule update --quiet --init --recursive --depth 1

endif

endef

GIT_EXECUTABLE = /usr/bin/git

$(GIT_EXECUTABLE):
	@echo Installing Git.
	@sudo apt-get update
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install git

GITS ?= ansible ansible-doc ansible-galaxy ansible-inventory ansible-playbook ansible-pull ansible-vault
$(foreach git,$(GITS),$(eval $(call git_template,$(git))))

# vi:syntax=makefile
