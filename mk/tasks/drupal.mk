DRUSH_MAKEFILE ?= $(FILES_DIR)/dev.build.yml
root           ?= ~/drupal
root_exists    ?= $(shell if [[ -d $(root) ]]; then echo 1; fi)
site_exists    ?= $(shell if [[ -f $(root)/sites/default/settings.php ]]; then echo 1; fi)
PROJECT_NAME   ?= example
PROJECT_TYPE   ?= module
PROFILE        ?= $(shell if [[ '$(PROJECT_TYPE)' == 'profile' ]]; then echo '$(PROJECT_NAME)'; else echo 'minimal'; fi)
port           ?= 8888
uri            ?= http://localhost:$(port)

help-drupal:
	@echo "make drupal"
	@echo "  Build a Drupal codebase, install a site and start a web server."
	@echo "make kill-server"
	@echo "  Stop the server running started during site install."

rebuild-platform: $(root)
$(root): $(DRUSH_MAKEFILE)

build-platform:
ifneq '$(root_exists)' '1'
	@$(drush) -y make $(DRUSH_MAKEFILE) $(root)
	@ln -s $(PROJECT_ROOT) $(root)/$(PROJECT_TYPE)s/$(PROJECT_NAME)
endif

drupal: kill-server build-platform
ifneq '$(site_exists)' '1'
	@cd $(root) && $(drush) -y site-install $(PROFILE) --db-url=mysql://root@localhost/site0 --account-pass=pwd
endif
	@echo "<?php" > ~/.drush/local.alias.drushrc.php
	@echo "  \$$aliases['local'] = array('root' => '$(root)','uri' => '$(uri)');" >> ~/.drush/local.alias.drushrc.php
	@echo "Starting PHP server."
	@cd $(root) && php -S 0.0.0.0:$(port) &> ~/runserver.log &

kill-server:
	@echo "Stopping PHP server."
	@ps aux|grep [p]hp > /dev/null || pkill -f php
	@sleep 3


make:
	@vagrant ssh -c"cd /var/www/html/d8 && sudo drush -y make /vagrant/dev.build.yml"

drupal-behat-config: drush-bde-env $(root)
	@echo Generating project-specific Behat config.
	@cd $(root) && $(drush) beg --subcontexts=profiles/$(PROFILE)/modules --site-root=$(root) --skip-path-check --base-url=$(uri) $(PROJECT_ROOT)/behat_params.sh


# vi:syntax=makefile
