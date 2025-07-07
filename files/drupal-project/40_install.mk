# Install (and clean up) Drupal site.

.PHONY: install install-real ci-install uninstall uninstall-real

SITE_INSTALL_DIR = web/sites/$(SITE_URL)

SITE_INSTALL_CMD = site:install $(INSTALL_PROFILE)\
                       --site-name=\"$(SITE_NAME)\" \
                       --yes --locale="en" \
                        --yes --locale="en" \
                       --db-url="mysql://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)" \
                       --sites-subdir=$(SITE_URL) \
                       --account-name="$(ADMIN_USER)" \
                       --account-mail="dev@$(SITE_URL)" \
                       --account-pass="$(ADMIN_PASS)"

site-clean:
	@$(ECHO) "$(YELLOW)Deleting $(GREY)$(SITE_URL)$(YELLOW) directory.$(RESET)"
	@[ ! -d $(SITE_INSTALL_DIR) ] || chmod -R 775 $(SITE_INSTALL_DIR)
	@rm -rf $(SITE_INSTALL_DIR)

install: ## Install Drupal site.
				@$(MAKE-QUIET) install-real
install-real:
				$(ECHO) "$(YELLOW)Beginning installation of $(GREY)$(SITE_URL)$(YELLOW). (Be patient. This may take a while.)$(RESET)"
				$(DRUSH) $(SITE_INSTALL_CMD) $(QUIET)
				@$(ECHO) "$(YELLOW)Enforcing optional configs.$(RESET)"
				@$(DRUSH) config-enforce:enforce --only-optional
				$(ECHO) "$(YELLOW)Completed installation of $(GREY)$(SITE_URL).$(RESET)"

uninstall: ## Uninstall Drupal site.
				@$(MAKE-QUIET) uninstall-real
uninstall-real:
				-$(DRUSH) -y sql:drop $(QUIET)
				chmod 700 web/sites/$(SITE_URL)/
				rm -rf web/sites/$(SITE_URL)/files/config*
				rm -f web/sites/$(SITE_URL)/settings.php
				$(ECHO) "$(YELLOW)Deleted $(GREY)$(SITE_URL).$(RESET)"

locale: ## Check and update Locale module for translation updates.
				$(DRUSH) locale-check && $(DRUSH) locale-update && $(DRUSH) cr
