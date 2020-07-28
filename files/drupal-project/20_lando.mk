# Start and destroy Lando environments.

.PHONY: start stop off destroy

start: ## Start Lando containers.
				@$(MAKE-QUIET) start-real
start-real:
				@$(ECHO) "$(YELLOW)Starting Lando containers. (Be patient. This may take a while.)$(RESET)"
				lando start $(QUIET)
				@$(ECHO) "$(YELLOW)Started Lando containers.$(RESET)"

stop: ## Stop Lando containers.
				@$(MAKE-QUIET) stop-real
stop-real:
				@$(ECHO) "$(YELLOW)Stopping Lando containers.$(RESET)"
				lando stop $(QUIET)
				@$(ECHO) "$(YELLOW)Stopped Lando containers.$(RESET)"

off: ## Power off Lando containers (including Traefik proxy)
				@($MAKE-QUIET) off-real
off-real:
				@$(ECHO) "$(YELLOW)Powering off Lando.$(RESET)"
				lando poweroff $(QUIET)
				@$(ECHO) "$(YELLOW)Lando powered off.$(RESET)"

destroy: ## Destroy Lando containers
				@$(MAKE-QUIET) destroy-real
destroy-real:
				@$(ECHO) "$(YELLOW)Destroying Lando containers.$(RESET)"
				lando destroy -y $(QUIET)
				@$(ECHO) "$(YELLOW)Destroyed Lando containers.$(RESET)"

rebuild: ## Rebuild Lando containers
	@$(MAKE-QUIET) rebuild-real
rebuild-real:
	@$(ECHO) "$(YELLOW)Rebuilding Lando containers.$(RESET)"
	lando rebuild -y $(QUIET)
	@$(ECHO) "$(YELLOW)Rebuilt Lando containers.$(RESET)"
