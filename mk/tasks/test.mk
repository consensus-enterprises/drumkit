help-test:
	@echo "make test-drupal"
	@echo "  Run Behat tests against dev Drupal site."
	@echo "make test-drupal-wip"
	@echo "  Run work-in-progress Behat tests against dev Drupal site."
	@echo "make test-drumkit"
	@echo "  Run Behat tests for Drumkit."
	@echo "make test-drumkit-wip"
	@echo "  Run work-in-progress Behat tests for Drumkit."

test-drupal: behat-config
	@source behat_params.sh && bin/behat
test-drupal-wip: behat-config
	@source behat_params.sh && bin/behat --tags=wip

test-drumkit: behat
	@cd $(MK_DIR) && \
	behat
test-drumkit-wip: behat
	@cd $(MK_DIR) && \
	behat --tags=wip --append-snippets

# vi:syntax=makefile
