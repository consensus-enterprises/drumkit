.PHONY: drupal-behat-config drupal-tests drupal-tests-wip

drupal-behat-config: behat drush-bde-env drush-alias
	@echo Generating project-specific Behat config.
	@cd $(PLATFORM_ROOT) && $(drush) @$(SITE) beg --subcontexts=profiles/$(PROFILE)/modules --site-root=$(PLATFORM_ROOT) --skip-path-check --base-url=$(SITE_URI) $(PROJECT_ROOT)/behat_params.sh

drupal-tests-help:
	@$(ECHO) "$(BOLD)make drupal-tests$(RESET)"
	@echo "  Run Behat tests against dev Drupal site. (Optional) Specify a test file using the CURRENT_TEST option."
	@$(ECHO) "$(BOLD)make drupal-tests-wip$(RESET)"
	@echo "  Run work-in-progress Behat tests against dev Drupal site."
drupal-tests: drupal-behat-config
	@source behat_params.sh && $(behat) $(CURRENT_TEST)
drupal-tests-wip: drupal-behat-config
	@source behat_params.sh && $(behat) $(CURRENT_TEST) --tags=wip

# vi:syntax=makefile
