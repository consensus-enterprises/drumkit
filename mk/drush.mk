DRUSH_DIR     ?= $(mk_dir)/.local/drush
DRUSH_SRC     ?= $(src_dir)/drush
DRUSH_BIN     ?= $(bin_dir)/drush
DRUSH_RELEASE ?= 8.0.5
DRUSH_PHAR    ?= $(DRUSH_SRC)/drush-$(DRUSH_RELEASE).phar
drush         ?= $(DRUSH_BIN) --include=$(DRUSH_DIR)

_help-drush:
	@echo "make drush"
	@echo "  Install Drush."

clean-drush:
	@rm -f $(DRUSH_BIN)
	@rm -f $(DRUSH_SRC)

deps-drush: aptitude-update mysql-server
	@echo Installing Drush dependencies
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install git php5-mysql php5-cli php5-gd

$(DRUSH_PHAR): init
	@echo Downloading the $(DRUSH_RELEASE) release of Drush.
	mkdir -p $(DRUSH_SRC)
	curl -Ss "https://github.com/drush-ops/drush/releases/download/$(DRUSH_RELEASE)/drush.phar" -z $(DRUSH_PHAR) -o $(DRUSH_PHAR)

$(DRUSH_BIN): $(DRUSH_SRC)/drush-$(DRUSH_RELEASE).phar
	@echo Installing the $(DRUSH_RELEASE) release of Drush.
	@cd $(bin_dir) && \
	ln -sf ../src/drush-$(DRUSH_RELEASE).phar drush
	@chmod a+x $(DRUSH_BIN)
	@$(drush) --version

drush: $(DRUSH_BIN)
