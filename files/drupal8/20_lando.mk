# Start and destroy Lando environments.

.PHONY: start stop off destroy

start:
				@$(MAKE-QUIET) start-real
start-real:
				@$(ECHO) "$(YELLOW)Starting Lando containers. (Be patient. This may take a while.)$(RESET)"
				lando start $(QUIET)
				@$(ECHO) "$(YELLOW)Started Lando containers.$(RESET)"

stop:
				@$(MAKE-QUIET) stop-real
stop-real:
				@$(ECHO) "$(YELLOW)Stopping Lando containers.$(RESET)"
				lando stop $(QUIET)
				@$(ECHO) "$(YELLOW)Stopped Lando containers.$(RESET)"

off:
				@($MAKE-QUIET) off-real
off-real:
				@$(ECHO) "$(YELLOW)Powering off Lando.$(RESET)"
				lando poweroff $(QUIET)
				@$(ECHO) "$(YELLOW)Lando powered off.$(RESET)"

destroy:
				@$(MAKE-QUIET) destroy-real
destroy-real:
				@$(ECHO) "$(YELLOW)Destroying Lando containers.$(RESET)"
				lando destroy -y $(QUIET)
				@$(ECHO) "$(YELLOW)Destroyed Lando containers.$(RESET)"
