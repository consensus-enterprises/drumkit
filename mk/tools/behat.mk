behat      ?= $(BEHAT_BIN)
BEHAT_BIN  ?= $(BIN_DIR)/behat
BEHAT_SRC  ?= $(SRC_DIR)/behat
BEHAT_EXEC ?= $(BEHAT_SRC)/vendor/behat/behat/bin/behat
BDE_DIR    ?= $(DRUSH_DIR)/drush-bde-env
BDE_EXISTS ?= $(shell if [[ -d $(BDE_DIR) ]]; then echo 1; fi)

tools-help-behat:
	@echo "make behat"
	@echo "  Install Behat."

drush-bde-env: drush BDE_DIR
	@echo Cloning Drush Behat config extension.
	@git clone https://github.com/pfrenssen/drush-bde-env.git $(BDE_DIR)
	@$(drush) cc drush

deps-behat: apt-update composer
	@echo Installing Behat dependencies.
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install php5-curl

clean-behat:
	@echo Removing Behat.
	@rm -rf $(BEHAT_SRC)
	@rm -f $(BEHAT_BIN)

install-behat: init composer $(BEHAT_BIN)
behat: install-behat

$(BEHAT_SRC)/composer.json: $(MK_DIR)/behat.composer.json
	@mkdir -p $(BEHAT_SRC)
	@cp $(MK_DIR)/behat.composer.json $(BEHAT_SRC)/composer.json

$(BEHAT_SRC)/composer.lock: $(MK_DIR)/behat.composer.lock $(BEHAT_SRC)/composer.json
	@mkdir -p $(BEHAT_SRC)
	@cp $(MK_DIR)/behat.composer.lock $(BEHAT_SRC)/composer.lock

$(BEHAT_EXEC): $(BEHAT_SRC)/composer.lock
	@echo Downloading Behat.
	@cd $(BEHAT_SRC) && \
	$(composer) install --no-dev --prefer-dist -q

$(BEHAT_BIN): $(BEHAT_EXEC)
	@echo Installing Behat.
	@rm -f $(BEHAT_BIN)
	@ln -sf $(BEHAT_EXEC) $(BEHAT_BIN)

# vi:syntax=makefile
