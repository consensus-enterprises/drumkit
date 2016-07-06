SQLITE_DIR      ?= $(DRUPAL_DIR)/sqlite
SITE            ?= default
SITE_DIR        ?= $(PLATFORM_ROOT)/sites/$(SITE)
site_exists     ?= $(shell if [[ -f $(SITE_DIR)/settings.php ]]; then echo 1; fi)
SITE_URI        ?= http://localhost:$(PHP_SERVER_PORT)

.PHONY: drupal-reinstall-help drupal-reinstall clean-drupal-site drupal-install drupal-create-sqlite-db 

drupal-reinstall-help:
	@echo "make drupal-reinstall"
	@echo "  Re-install the current Drupal site."
drupal-reinstall: clean-drupal-site drupal-install drupal-start-server drupal-user-login

clean-drupal-site: drupal-kill-server
	@echo "Deleting '$(SITE)' site database."
	@rm -rf $(SQLITE_DIR)/$(SITE)
	@echo "Deleting '$(SITE)' site settings.php."
	@if [ -d $(SITE_DIR) ]; then chmod 755 $(SITE_DIR); fi
	@if [ -f $(SITE_DIR)/settings.php ]; then chmod 644 $(SITE_DIR)/settings.php; fi
	@rm -f $(SITE_DIR)/settings.php

drupal-install: drush $(SITE_DIR)/settings.php
$(SITE_DIR)/settings.php: drupal-create-sqlite-db
	@cd $(PLATFORM_ROOT) && $(drush) -y site-install $(PROFILE) --db-url=sqlite://$(SQLITE_DIR)/$(SITE)/db.sqlite --account-pass=pwd --sites-subdir=$(SITE) install_configure_form.update_status_module='array(FALSE,FALSE)'
	@touch $(SITE_DIR)/settings.php

drupal-create-sqlite-db: $(SQLITE_DIR)/$(SITE)
$(SQLITE_DIR)/$(SITE): $(SQLITE_DIR)
	@echo Creating SQLite directory for '$(SITE)'.
	@mkdir -p $(SQLITE_DIR)/$(SITE)
	@touch $(SQLITE_DIR)/$(SITE)
$(SQLITE_DIR): $(DRUPAL_DIR)
	@echo Creating local SQLite directory.
	@mkdir -p $(SQLITE_DIR)
	@touch $(SQLITE_DIR)

# vi:syntax=makefile
