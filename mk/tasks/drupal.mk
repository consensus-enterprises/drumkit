DRUPAL_DIR      ?= $(LOCAL_DIR)/drupal
PROJECT_NAME    ?= example
PROJECT_TYPE    ?= module
PROFILE         ?= $(shell if [[ '$(PROJECT_TYPE)' == 'profile' ]]; then echo '$(PROJECT_NAME)'; else echo 'minimal'; fi)

.PHONY: help-drupal help-drupal-all debug-drupal-help debug-drupal clean-drupal-help clean-drupal drupal-help drupal

include $(MK_DIR)/mk/tasks/drupal/*.mk

help-drupal: drupal-help drupal-reinstall-help drupal-rebuild-help drupal-tests-help clean-drupal-help drupal-user-login-help drush-alias-help ##@help Show special help targets for drupal
	@$(ECHO) "$(BOLD)make help-drupal-all$(RESET)"
	@echo "  Display help for additional Drupal targets."

help-drupal-all: help-drupal debug-drupal-help drupal-start-server-help drupal-kill-server-help

debug-drupal-help:
	@$(ECHO) "$(BOLD)make debug-drupal$(RESET)"
	@echo "  Print some variables for debugging."
debug-drupal:
	@echo "PROJECT_ROOT: $(PROJECT_ROOT)"
	@echo "PLATFORM_ROOT: $(PLATFORM_ROOT)"

clean-drupal-help:
	@$(ECHO) "$(BOLD)make clean-drupal$(RESET)"
	@echo "  Delete the Drupal codebase and database, and stop the PHP server."
clean-drupal: clean-drupal-platform

drupal-help:
	@$(ECHO) "$(BOLD)make drupal$(RESET)"
	@echo "  Build a Drupal codebase, install a site and start a web server."
drupal: drupal-kill-server drupal-build-platform drupal-install drupal-start-server drush-alias drupal-user-login

# vi:syntax=makefile
