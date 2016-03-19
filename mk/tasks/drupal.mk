drush_make     ?= $(drush) -y make --working-copy
DRUSH_MAKEFILE ?= $(PROJECT_ROOT)/dev.build.yml
SITE           ?= default
PLATFORM_ROOT  ?= ~/drupal-$(SITE)
site_exists    ?= $(shell if [[ -f $(PLATFORM_ROOT)/sites/default/settings.php ]]; then echo 1; fi)
PROJECT_NAME   ?= example
PROJECT_TYPE   ?= module
PROFILE        ?= $(shell if [[ '$(PROJECT_TYPE)' == 'profile' ]]; then echo '$(PROJECT_NAME)'; else echo 'minimal'; fi)
PHP_SERVER_PORT ?= 8888
SITE_URI       ?= http://localhost:$(PHP_SERVER_PORT)

.PHONY: help-drupal rebuild-platform build-platform drupal kill-server drupal-behat-config

help-drupal:
	@echo "make drupal"
	@echo "  Build a Drupal codebase, install a site and start a web server."
	@echo "make kill-server"
	@echo "  Stop the server running started dSITE_URIng site install."

build-platform: $(PLATFORM_ROOT)
$(PLATFORM_ROOT): $(DRUSH_MAKEFILE)
$(DRUSH_MAKEFILE):
	@echo "Initializing build makefile."
	@cp $(FILES_DIR)/dev.build.yml $(DRUSH_MAKEFILE)
$(PLATFORM_ROOT):
	@echo "Building platform using $(DRUSH_MAKEFILE)."
	@$(drush_make) $(DRUSH_MAKEFILE) $(PLATFORM_ROOT)
	@ln -s $(PROJECT_ROOT) $(PLATFORM_ROOT)/$(PROJECT_TYPE)s/$(PROJECT_NAME)

rebuild-platform:
	@echo "Rebuilding platform using $(DRUSH_MAKEFILE)."
	@cd $(PLATFORM_ROOT) && \
  $(drush_make) $(DRUSH_MAKEFILE)
	@ln -sf $(PROJECT_ROOT) $(PLATFORM_ROOT)/$(PROJECT_TYPE)s/$(PROJECT_NAME)

drupal: kill-server build-platform $(PLATFORM_ROOT)/sites/$(SITE)/settings.php
	@cd $(PLATFORM_ROOT) && $(drush) -y site-install $(PROFILE) --db-url=mysql://PLATFORM_ROOT@localhost/site0 --account-pass=pwd
	@echo "<?php" > ~/.drush/local.alias.drushrc.php
	@echo "  \$$aliases['$(SITE)'] = array('PLATFORM_ROOT' => '$(PLATFORM_ROOT)','SITE_URI' => '$(SITE_URI)');" >> ~/.drush/$(SITE).alias.drushrc.php
	@echo "Starting PHP server."
	@cd $(PLATFORM_ROOT) && php -S 0.0.0.0:$(PHP_SERVER_PORT) &> ~/runserver.log &

kill-server:
	@echo "Stopping PHP server."
	@ps aux|grep [p]hp > /dev/null || pkill -f php
	@echo "Waiting for PHP server to stop."
	@sleep 3

make:
	@vagrant ssh -c"cd /var/www/html/d8 && sudo drush -y make /vagrant/dev.build.yml"

drupal-behat-config: drush-bde-env $(PLATFORM_ROOT)
	@echo Generating project-specific Behat config.
	@cd $(PLATFORM_ROOT) && $(drush) beg --subcontexts=profiles/$(PROFILE)/modules --site-PLATFORM_ROOT=$(PLATFORM_ROOT) --skip-path-check --base-url=$(SITE_URI) $(PROJECT_ROOT)/behat_params.sh


# vi:syntax=makefile
