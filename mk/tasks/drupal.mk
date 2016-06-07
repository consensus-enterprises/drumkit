drush_make      ?= $(drush) -y make --working-copy
DRUPAL_DIR      ?= $(LOCAL_DIR)/drupal
SQLITE_DIR      ?= $(DRUPAL_DIR)/sqlite
DRUSH_MAKEFILE  ?= $(PROJECT_ROOT)/dev.build.yml
SITE            ?= default
PLATFORM_ROOT   ?= $(DRUPAL_DIR)/drupal-$(SITE)
site_exists     ?= $(shell if [[ -f $(PLATFORM_ROOT)/sites/$(SITE)/settings.php ]]; then echo 1; fi)
PROJECT_NAME    ?= example
PROJECT_TYPE    ?= module
PROFILE         ?= $(shell if [[ '$(PROJECT_TYPE)' == 'profile' ]]; then echo '$(PROJECT_NAME)'; else echo 'minimal'; fi)
PHP_SERVER_PORT ?= 8888
SITE_URI        ?= http://localhost:$(PHP_SERVER_PORT)

.PHONY: help-drupal drupal-behat-config drush-alias

help-drupal: drupal-help drupal-tests-help clean-drupal-help drupal-user-login-help drush-alias-help
	@echo "make help-drupal-all"
	@echo "  Display help for additional Drupal targets."

help-drupal-all: help-drupal debug-drupal-help drupal-start-server-help drupal-kill-server-help

debug-drupal-help:
	@echo "make debug-drupal"
	@echo "  Print some variables for debugging."
debug-drupal:
	@echo "PROJECT_ROOT: $(PROJECT_ROOT)"
	@echo "PLATFORM_ROOT: $(PLATFORM_ROOT)"

clean-drupal-help:
	@echo "make clean-drupal"
	@echo "  Delete the Drupal codebase and database, and stop the PHP server."
clean-drupal: drupal-kill-server
	@echo "Deleting '$(SITE)' site database."
	@rm -rf $(SQLITE_DIR)/$(SITE)
	@echo "Deleting '$(SITE)' site platform."
	@if [ -d $(PLATFORM_ROOT) ]; then chmod -f -R 700 $(PLATFORM_ROOT); fi
	@rm -rf $(PLATFORM_ROOT)

drupal-help:
	@echo "make drupal"
	@echo "  Build a Drupal codebase, install a site and start a web server."
drupal: drupal-kill-server drupal-install drupal-start-server drush-alias drupal-user-login

drupal-install: drush $(PLATFORM_ROOT)/sites/$(SITE)/settings.php
$(PLATFORM_ROOT)/sites/$(SITE)/settings.php: drupal-build-platform drupal-create-sqlite-db
	@cd $(PLATFORM_ROOT) && $(drush) -y site-install $(PROFILE) --db-url=sqlite://$(SQLITE_DIR)/$(SITE)/db.sqlite --account-pass=pwd
	@touch $(PLATFORM_ROOT)/sites/$(SITE)/settings.php

drupal-build-platform: drush $(PLATFORM_ROOT)
$(PLATFORM_ROOT): $(DRUSH_MAKEFILE) $(DRUPAL_DIR)
	@echo "Building platform using $(DRUSH_MAKEFILE)."
	@mkdir -p $(PLATFORM_ROOT)
	@cd $(PLATFORM_ROOT) && $(drush_make) $(DRUSH_MAKEFILE)
	@ln -sf $(PROJECT_ROOT) $(PLATFORM_ROOT)/$(PROJECT_TYPE)s/$(PROJECT_NAME)
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
	@echo Creating SQLite directory for $(SITE).
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

make:
	@vagrant ssh -c"cd /var/www/html/d8 && sudo drush -y make /vagrant/dev.build.yml"

drupal-behat-config: drush-bde-env
	@echo Generating project-specific Behat config.
	@cd $(PLATFORM_ROOT) && $(drush) beg --subcontexts=profiles/$(PROFILE)/modules --site-root=$(PLATFORM_ROOT) --skip-path-check --base-url=$(SITE_URI) $(PROJECT_ROOT)/behat_params.sh

drupal-tests-help:
	@echo "make drupal-tests"
	@echo "  Run Behat tests against dev Drupal site."
	@echo "make drupal-tests-wip"
	@echo "  Run work-in-progress Behat tests against dev Drupal site."
drupal-tests: drupal-behat-config
	@source behat_params.sh && $(behat) $(CURRENT_TEST)
drupal-tests-wip: drupal-behat-config
	@source behat_params.sh && $(behat) $(CURRENT_TEST) --tags=wip

# vi:syntax=makefile
