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
	@$(ECHO) "$(YELLOW)Beginning build of codebase. (Be patient. This may take a while.)$(RESET)"
	$(LANDO) composer --ansi create-project --no-progress $(QUIET)
	@$(ECHO) "$(YELLOW)Completed build of codebase.$(RESET)"

clean-composer-cache: ## Clean Composer cache.
ifneq ("$(wildcard $(COMPOSER_CACHE_DIR))","")
	rm -rf $(COMPOSER_CACHE_DIR)/*
	$(ECHO) "$(YELLOW)Deleted Composer cache contents.$(RESET)"
endif

clean-build: ## Clean Composer built code.
ifneq ("$(wildcard web)","")
	chmod -R 700 web
	rm -rf web
	@$(ECHO) "$(YELLOW)Deleted platform directory.$(RESET)"
endif
ifneq ("$(wildcard vendor)","")
	rm -rf vendor
	@$(ECHO) "$(YELLOW)Deleted vendor directory.$(RESET)"
endif

update: ## Run composer update
	@$(MAKE-QUIET) update-real
update-real:
	@$(ECHO) "$(YELLOW)Beginning update of codebase. (Be patient. This may take a while.)$(RESET)"
	$(LANDO) composer --ansi update --no-progress $(QUIET)
	@$(ECHO) "$(YELLOW)Completed update of codebase.$(RESET)"
