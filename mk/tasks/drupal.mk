drush_make      ?= $(drush) -y make --working-copy
DRUPAL_DIR      ?= $(LOCAL_DIR)/drupal
SQLITE_DIR      ?= $(DRUPAL_DIR)/sqlite
DRUSH_MAKEFILE  ?= $(PROJECT_ROOT)/dev.build.yml
SITE            ?= default
PLATFORM_ROOT   ?= $(DRUPAL_DIR)/drupal-$(SITE)
SITE_DIR        ?= $(PLATFORM_ROOT)/sites/$(SITE)
site_exists     ?= $(shell if [[ -f $(SITE_DIR)/settings.php ]]; then echo 1; fi)
PROJECT_NAME    ?= example
PROJECT_TYPE    ?= module
PROFILE         ?= $(shell if [[ '$(PROJECT_TYPE)' == 'profile' ]]; then echo '$(PROJECT_NAME)'; else echo 'minimal'; fi)
PHP_SERVER_PORT ?= 8888
SITE_URI        ?= http://localhost:$(PHP_SERVER_PORT)

.PHONY: help-drupal drush-alias

help-drupal: drupal-help drupal-reinstall-help drupal-rebuild-help drupal-tests-help clean-drupal-help drupal-user-login-help drush-alias-help
	@echo "make help-drupal-all"
	@echo "  Display help for additional Drupal targets."

help-drupal-all: help-drupal debug-drupal-help drupal-start-server-help drupal-kill-server-help

debug-drupal-help:
	@echo "make debug-drupal"
	@echo "  Print some variables for debugging."
debug-drupal:
	@echo "PROJECT_ROOT: $(PROJECT_ROOT)"
	@echo "PLATFORM_ROOT: $(PLATFORM_ROOT)"

drupal-rebuild-help:
	@echo "make drupal-rebuild"
	@echo "  Destroy the current Drupal site and rebuild it from scratch."
drupal-rebuild: clean-drupal drupal

drupal-reinstall-help:
	@echo "make drupal-reinstall"
	@echo "  Re-install the current Drupal site."
drupal-reinstall: clean-drupal-site drupal-install drupal-start-server drupal-user-login

clean-drupal-help:
	@echo "make clean-drupal"
	@echo "  Delete the Drupal codebase and database, and stop the PHP server."
clean-drupal: clean-drupal-platform
clean-drupal-site: drupal-kill-server
	@echo "Deleting '$(SITE)' site database."
	@rm -rf $(SQLITE_DIR)/$(SITE)
	@echo "Deleting '$(SITE)' site settings.php."
	@if [ -d $(SITE_DIR) ]; then chmod 755 $(SITE_DIR); fi
	@if [ -f $(SITE_DIR)/settings.php ]; then chmod 644 $(SITE_DIR)/settings.php; fi
	@rm -f $(SITE_DIR)/settings.php
clean-drupal-platform: clean-drupal-site
	@echo "Deleting '$(SITE)' site platform."
	@if [ -d $(PLATFORM_ROOT) ]; then chmod -f -R 700 $(PLATFORM_ROOT); fi
	@rm -rf $(PLATFORM_ROOT)

drupal-help:
	@echo "make drupal"
	@echo "  Build a Drupal codebase, install a site and start a web server."
drupal: drupal-kill-server drupal-install drupal-start-server drush-alias drupal-user-login

drupal-install: drush $(SITE_DIR)/settings.php
$(SITE_DIR)/settings.php: drupal-build-platform drupal-create-sqlite-db
	@cd $(PLATFORM_ROOT) && $(drush) -y site-install $(PROFILE) --db-url=sqlite://$(SQLITE_DIR)/$(SITE)/db.sqlite --account-pass=pwd --sites-subdir=$(SITE)
	@touch $(SITE_DIR)/settings.php

drupal-build-platform: drush $(PLATFORM_ROOT)
$(PLATFORM_ROOT): $(DRUSH_MAKEFILE) $(DRUPAL_DIR)
	@echo "Building platform using $(DRUSH_MAKEFILE)."
	@mkdir -p $(PLATFORM_ROOT)/$(PROJECT_TYPE)s
	@if [ ! -L $(PLATFORM_ROOT)/$(PROJECT_TYPE)s/$(PROJECT_NAME) ]; then ln -s $(PROJECT_ROOT) $(PLATFORM_ROOT)/$(PROJECT_TYPE)s/$(PROJECT_NAME); fi
	@cd $(PLATFORM_ROOT) && $(drush_make) $(DRUSH_MAKEFILE)
	@touch $(PLATFORM_ROOT)
$(DRUSH_MAKEFILE):
	@echo "Initializing build makefile."
	@cp $(FILES_DIR)/dev.build.yml $(DRUSH_MAKEFILE)
	@touch $(DRUSH_MAKEFILE)
$(DRUPAL_DIR): $(LOCAL_DIR)
	@echo Creating local Drupal directory.
	@mkdir -p $(DRUPAL_DIR)
	@touch $(DRUPAL_DIR)

drupal-create-sqlite-db: $(SQLITE_DIR)/$(SITE)
$(SQLITE_DIR)/$(SITE): $(SQLITE_DIR)
	@echo Creating SQLite directory for '$(SITE)'.
	@mkdir -p $(SQLITE_DIR)/$(SITE)
	@touch $(SQLITE_DIR)/$(SITE)
$(SQLITE_DIR): $(DRUPAL_DIR)
	@echo Creating local SQLite directory.
	@mkdir -p $(SQLITE_DIR)
	@touch $(SQLITE_DIR)

drush-alias-help:
	@echo "make drush-alias"
	@echo "  Generate a Drush alias for the dev site."
drush-alias:
	@echo "Creating Drush alias @$(SITE)."
	@echo "<?php" > $(HOME)/.drush/$(SITE).alias.drushrc.php
	@echo "  \$$aliases['$(SITE)'] = array('root' => '$(PLATFORM_ROOT)','uri' => '$(SITE_URI)');" >> ~/.drush/$(SITE).alias.drushrc.php

drupal-start-server-help:
	@echo "make drupal-start-server"
	@echo "  Start an embedded PHP server."
drupal-start-server:
	@echo "Starting PHP server."
	@cd $(PLATFORM_ROOT) && php -S 0.0.0.0:$(PHP_SERVER_PORT) &> runserver.log &
	@echo "Giving PHP server a chance to start."
	@sleep 3

drupal-kill-server-help:
	@echo "make drupal-kill-server"
	@echo "  Stop the PHP server."
drupal-kill-server:
	@echo "Stopping any running PHP servers."
	@ps aux|grep "[p]hp -S" > /dev/null; if [ "$?" == 0 ]; then pkill -f "php -S"; fi
	@echo "Giving PHP servers a chance to stop."
	@sleep 3

drupal-user-login-help:
	@echo "make drupal-user-login"
	@echo "  Open a browser and login to the dev site."
drupal-user-login: drupal-install drupal-start-server
	@echo "A browser window should open on your new site. If not, use the following URL:"
	@drush @$(SITE) uli admin admin

# vi:syntax=makefile
