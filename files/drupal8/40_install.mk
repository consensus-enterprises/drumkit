# Install (and clean up) Drupal site.

.PHONY: install install-real ci-install uninstall uninstall-real

MYSQL_DATABASE ?= $(DB_NAME)
MYSQL_USER     ?= $(DB_USER)
MYSQL_PASSWORD ?= $(DB_PASS)

SITE_INSTALL_CMD = site:install $(INSTALL_PROFILE)\
                       --site-name=$(SITE_NAME) \
                       --yes --locale="en" \
                       --db-url="mysql://$(MYSQL_USER):$(MYSQL_PASSWORD)@database/$(MYSQL_DATABASE)" \
                       --sites-subdir=$(SITE_URL) \
                       --account-name="$(ADMIN_USER)" \
                       --account-mail="dev@$(SITE_URL)" \
                       --account-pass="$(ADMIN_PASS)"

install:
				@$(MAKE-QUIET) install-real
install-real:
				@$(ECHO) "$(YELLOW)Beginning installation of $(GREY)$(SITE_URL)$(YELLOW). (Be patient. This may take a while.)$(RESET)"
				$(DRUSH) $(SITE_INSTALL_CMD) $(QUIET)
				@$(ECHO) "$(YELLOW)Completed installation of $(GREY)$(SITE_URL).$(RESET)"

uninstall:
				@$(MAKE-QUIET) uninstall-real
uninstall-real:
				-$(DRUSH) -y sql:drop $(QUIET)
				chmod 700 web/sites/$(SITE_URL)/
				rm -rf web/sites/$(SITE_URL)/files/config*
				rm -f web/sites/$(SITE_URL)/settings.php
				@$(ECHO) "$(YELLOW)Deleted $(GREY)$(SITE_URL).$(RESET)"

locale:
				$(DRUSH) locale-check && $(DRUSH) locale-update && $(DRUSH) cr
