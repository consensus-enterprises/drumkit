# Build (and clean up) a Drupal codebase.

.PHONY: clean-build

check-composer-cache:
	@if [ -z ${COMPOSER_CACHE_DIR} ]; then echo -e "$(YELLOW)Missing required variable $(GREY)COMPOSER_CACHE_DIR$(YELLOW).$(RESET)"; echo -e "$(BOLD)$(WHITE)Remember to bootstrap Drumkit ($(GREEN). d$(WHITE))$(RESET)"; exit 1; fi

build: check-composer-cache web/index.php ## Build Composer codebase.
web/index.php: composer
	@$(MAKE-QUIET) build-real
build-real:
	mkdir -p $(COMPOSER_CACHE_DIR)
	mkdir -p vendor
	$(ECHO) "$(YELLOW)Beginning build of codebase. (Be patient. This may take a while.)$(RESET)"
	$(LANDO) composer --ansi create-project --no-progress $(QUIET)
	$(ECHO) "$(YELLOW)Completed build of codebase.$(RESET)"

clean-composer-cache: ## Clean Composer cache.
ifneq ("$(wildcard $(COMPOSER_CACHE_DIR))","")
	rm -rf $(COMPOSER_CACHE_DIR)/*
	$(ECHO) "$(YELLOW)Deleted Composer cache contents.$(RESET)"
endif

clean-build: ## Clean Composer built code.
	$(ECHO) "$(YELLOW)Beginning clean of composer-built code.$(RESET)"
	@chmod -R +w web
	@# We want to keep the .env, .lando.local.yml, and settings.local.php because
	@# they contain machine-specific config. Also, tmp/backups has database
	@# backups and .idea contains IDE configuration.
	@git clean -dfx -e '/.env' -e '/.lando.local.yml' -e '/web/sites/default/settings.local.php' -e '/.idea' -e '/tmp/backups/'
	@# Git clean won't delete repos that composer cloned; so delete these. See
	@# composer.json -> extra.installer-paths for the list of places these repos
	@# could end up.
	@if [ -d web/core/ ] ; then rm -r web/core/ ; fi
	@if [ -d web/libraries/ ] ; then rm -r web/libraries/ ; fi
	@if [ -d web/modules/contrib/ ] ; then rm -r web/modules/contrib/ ; fi
	@if [ -d web/profiles/contrib/ ] ; then rm -r web/profiles/contrib/ ; fi
	@if [ -d web/themes/contrib/ ] ; then rm -r web/themes/contrib/ ; fi
	@if [ -d drush/Commands/contrib/ ] ; then rm -r drush/Commands/contrib/ ; fi
	@if [ -d web/private/scripts/quicksilver/ ] ; then rm -r web/private/scripts/quicksilver/ ; fi
	$(ECHO) "$(YELLOW)Completed clean of composer-built code.$(RESET)"

update: ## Run composer update
	@$(MAKE-QUIET) update-real
update-real:
	$(ECHO) "$(YELLOW)Beginning update of codebase. (Be patient. This may take a while.)$(RESET)"
	$(LANDO) composer --ansi update --no-progress $(QUIET)
	$(ECHO) "$(YELLOW)Completed update of codebase.$(RESET)"
