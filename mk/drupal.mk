makefile     = dev.build.yml
root         = ~/drupal
root_exists  = $(shell if [[ -d $(root) ]]; then echo 1; fi)
site_exists  = $(shell if [[ -f $(root)/sites/default/settings.php ]]; then echo 1; fi)
profile      = make_server
port         = 8888
uri          = http://localhost:$(port)

help-drupal:
	@echo "make drupal"
	@echo "  Build a Drupal codebase, install a site and start a web server."
	@echo "make kill-server"
	@echo "  Stop the server running started during site install."

rebuild-platform: $(root)
$(root): $(project_root)/$(makefile)

build-platform: vm
ifneq '$(root_exists)' '1'
	@$(drush) -y make $(project_root)/$(makefile) $(root)
	@ln -s $(project_root) $(root)/profiles/$(profile) 
endif

drupal: kill-server build-platform
ifneq '$(site_exists)' '1'
	@cd $(root) && $(drush) -y site-install $(profile) --db-url=mysql://root@localhost/site0 --account-pass=pwd
endif
	@echo "<?php" > ~/.drush/local.alias.drushrc.php
	@echo "  \$$aliases['local'] = array('root' => '$(root)','uri' => '$(uri)');" >> ~/.drush/local.alias.drushrc.php
	@echo "Starting PHP server."
	@cd $(root) && php -S 0.0.0.0:$(port) &> ~/runserver.log &

kill-server:
	@echo "Stopping PHP server."
	@ps aux|grep [p]hp > /dev/null || pkill -f php
	@sleep 3
