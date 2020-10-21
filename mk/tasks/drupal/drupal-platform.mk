drush_make      ?= $(drush) -y make --working-copy
DRUSH_MAKEFILE  ?= $(PROJECT_ROOT)/dev.build.yml
PLATFORM_ROOT   ?= $(DRUPAL_DIR)/drupal-$(SITE)

.PHONY: drupal-rebuild drupal-rebuild-help clean-drupal-platform drupal-build-platform

drupal-rebuild-help:
	@$(ECHO) "$(BOLD)make drupal-rebuild$(RESET)"
	@echo "  Destroy the current Drupal site and rebuild it from scratch."
drupal-rebuild: clean-drupal drupal

clean-drupal-platform: clean-drupal-site
	@echo "Deleting '$(SITE)' site platform."
	@if [ -d $(PLATFORM_ROOT) ]; then chmod -f -R 700 $(PLATFORM_ROOT); fi
	@rm -rf $(PLATFORM_ROOT)

drupal-build-platform: drush $(PLATFORM_ROOT)
$(PLATFORM_ROOT): $(DRUSH_MAKEFILE) $(DRUPAL_DIR)
	@echo "Building platform using $(DRUSH_MAKEFILE)."
	@mkdir -p $(PLATFORM_ROOT)/$(PROJECT_TYPE)s
	@if [ ! -L $(PLATFORM_ROOT)/$(PROJECT_TYPE)s/$(PROJECT_NAME) ]; then ln -s $(PROJECT_ROOT) $(PLATFORM_ROOT)/$(PROJECT_TYPE)s/$(PROJECT_NAME); fi
	@cd $(PLATFORM_ROOT) && $(drush_make) $(DRUSH_MAKEFILE)
	@touch $(PLATFORM_ROOT)
$(DRUSH_MAKEFILE):
	@echo "Initializing build makefile."
	@cp $(FILES_DIR)/dev.build.yml $(DRUSH_MAKEFILE)
	@touch $(DRUSH_MAKEFILE)
$(DRUPAL_DIR): $(LOCAL_DIR)
	@echo Creating local Drupal directory.
	@mkdir -p $(DRUPAL_DIR)
	@touch $(DRUPAL_DIR)

# vi:syntax=makefile
