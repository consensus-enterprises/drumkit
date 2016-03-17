drush      ?= $(DRUSH_BIN) --include=$(DRUSH_DIR)
DRUSH_REL  ?= 8.0.5
DRUSH_URL  ?= https://github.com/drush-ops/drush/releases/download/$(DRUSH_REL)/drush.phar
DRUSH_DEPS ?= git php5-mysql php5-cli php5-gd
DRUSH_DIR  ?= $(MK_DIR)/.local/drush
DRUSH_SRC  ?= $(SRC_DIR)/drush
DRUSH_BIN  ?= $(BIN_DIR)/drush
DRUSH_PHAR ?= $(DRUSH_SRC)/drush-$(DRUSH_REL).phar

tools-help-drush:
	@echo "make drush"
	@echo "  Install Drush."
	@echo "make drush DRUSH_REL=$(DRUSH_REL)"
	@echo "  Install the $(DRUSH_REL) release of Drush."

clean-drush:
	@echo Removing Drush.
	@rm -f $(DRUSH_BIN)
	@rm -rf $(DRUSH_SRC)

deps-drush: apt-update mysql-server
	@echo Installing Drush dependencies.
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install $(DRUSH_DEPS)

install-drush: init $(DRUSH_BIN)
drush: install-drush

$(DRUSH_BIN): $(DRUSH_PHAR)
	@echo Installing the $(DRUSH_REL) release of Drush.
	@ln -sf $(DRUSH_PHAR) $(DRUSH_BIN)
	@chmod a+x $(DRUSH_BIN)
	@$(drush) --version

$(DRUSH_PHAR):
	@echo Downloading the $(DRUSH_REL) release of Drush.
	@mkdir -p $(DRUSH_SRC)
	@curl -SsL $(DRUSH_URL) -z $(DRUSH_PHAR) -o $(DRUSH_PHAR)

# vi:syntax=makefile
