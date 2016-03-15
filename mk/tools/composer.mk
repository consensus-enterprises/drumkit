composer      ?= $(BIN_DIR)/composer
COMPOSER_REL  ?= 1.0.0-beta1
COMPOSER_URL  ?= https://getcomposer.org/download/$(COMPOSER_REL)/composer.phar
COMPOSER_DIR  ?= $(MK_DIR)/.local/composer
COMPOSER_SRC  ?= $(SRC_DIR)/composer
COMPOSER_BIN  ?= $(BIN_DIR)/composer
COMPOSER_PHAR ?= $(COMPOSER_SRC)/composer-$(COMPOSER_REL).phar

tools-help-composer:
	@echo "make composer"
	@echo "  Install Composer."
	@echo "make composer COMPOSER_REL=$(COMPOSER_REL)"
	@echo "  Install the $(COMPOSER_REL) release of Composer."

clean-composer:
	@echo Removing Composer.
	@rm -f $(COMPOSER_BIN)
	@rm -rf $(COMPOSER_SRC)

composer: install-composer
install-composer: init $(COMPOSER_BIN)

$(COMPOSER_BIN): $(COMPOSER_PHAR)
	@echo Installing the $(COMPOSER_REL) release of Composer.
	@mkdir -p $(SRC_DIR)
	@ln -sf $(COMPOSER_PHAR) $(COMPOSER_BIN)
	@chmod a+x $(COMPOSER_BIN)
	@$(composer) --version

$(COMPOSER_PHAR):
	@echo Downloading the $(COMPOSER_REL) release of Composer.
	@mkdir -p $(COMPOSER_SRC)
	@curl -SsL $(COMPOSER_URL) -z $(COMPOSER_PHAR) -o $(COMPOSER_PHAR)

# vi:syntax=makefile
