# Start and destroy DDEV environments.

.PHONY: start stop off destroy

start: ## Start DDEV containers.
	@$(MAKE-QUIET) start-real
start-real:
	$(ECHO) "$(YELLOW)Starting DDEV containers. (Be patient. This may take a while.)$(RESET)"
	ddev start $(QUIET)
	$(ECHO) "$(YELLOW)Started DDEV containers.$(RESET)"

stop: ## Stop DDEV containers.
	@$(MAKE-QUIET) stop-real
stop-real:
	$(ECHO) "$(YELLOW)Stopping DDEV containers.$(RESET)"
	ddev stop $(QUIET)
	$(ECHO) "$(YELLOW)Stopped DDEV containers.$(RESET)"

off: ## Power off DDEV containers (including Traefik proxy)
	@$(MAKE-QUIET) off-real
off-real:
	$(ECHO) "$(YELLOW)Powering off DDEV.$(RESET)"
	ddev poweroff $(QUIET)
	$(ECHO) "$(YELLOW)DDEV powered off.$(RESET)"

destroy: ## Destroy DDEV containers
	@$(MAKE-QUIET) destroy-real
destroy-real:
	$(ECHO) "$(YELLOW)Destroying DDEV containers.$(RESET)"
	ddev delete -y $(QUIET)
	$(ECHO) "$(YELLOW)Destroyed DDEV containers.$(RESET)"
