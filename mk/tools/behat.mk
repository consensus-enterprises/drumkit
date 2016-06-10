behat      ?= $(BEHAT_BIN) --colors
BEHAT_BIN  ?= $(BIN_DIR)/behat
BEHAT_SRC  ?= $(SRC_DIR)/behat
BEHAT_EXEC ?= $(BEHAT_SRC)/bin/behat
BEHAT_DEPS ?= php5-curl
BDE_DIR    ?= $(DRUSH_DIR)/drush-bde-env
BDE_EXISTS ?= $(shell if [[ -d $(BDE_DIR) ]]; then echo 1; fi)

tools-help-behat:
	@echo "make behat"
	@echo "  Install Behat."

drush-bde-env: drush $(BDE_DIR)
$(BDE_DIR): $(DRUSH_DIR)
	@echo Cloning Drush Behat config extension.
	@git clone https://github.com/pfrenssen/drush-bde-env.git $(BDE_DIR)
	@$(drush) cc drush

deps: deps-behat
deps-behat: apt-update composer
	@echo Installing Behat dependencies.
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install $(BEHAT_DEPS)

clean-behat:
	@echo Removing Behat.
	@rm -rf $(BEHAT_SRC)
	@rm -f $(BEHAT_BIN)

install-behat: init composer $(BEHAT_BIN)
behat: install-behat

$(BEHAT_SRC)/composer.json: $(FILES_DIR)/behat/composer.json
	@mkdir -p $(BEHAT_SRC)
	@cp $(FILES_DIR)/behat/composer.* $(BEHAT_SRC)/

$(BEHAT_SRC)/composer.lock: $(BEHAT_SRC)/composer.json
	@echo Downloading Behat.
	@cd $(BEHAT_SRC) && \
	$(composer) install --no-dev --prefer-dist -q

$(BEHAT_BIN): $(BEHAT_SRC)/composer.lock
	@echo Installing Behat.
	@ln -sf $(BEHAT_EXEC) $(BEHAT_BIN)
	@touch $(BEHAT_BIN)
	@$(behat) --version

# vi:syntax=makefile
