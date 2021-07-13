.PHONY: config-export config-import

config-import: ## Import configuration from the config sync directory to the current site.
	$(DRUSH) -y config-import

config-export: ## Export the site's current configuration to the config sync directory.
	$(DRUSH) -y config-export
