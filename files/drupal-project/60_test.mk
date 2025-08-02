# Run our test suite.

.PHONY: tests tests-ci tests-wip tests-js vnc test-steps tests-upstream

tests-complete: tests tests-upstream

tests: ## Run functional Behat test suite
	$(BEHAT) --stop-on-failure

tests-upstream:
	$(BEHAT) --stop-on-failure --colors --suite=upstream --tags='~@wip'

tests-ci:
	$(BEHAT) --stop-on-failure --colors --suite=ci

tests-wip: test-wip

test-wip:
	$(BEHAT) --stop-on-failure --tags=wip

tests-js:
	$(BEHAT) --tags=javascript

test-steps:
	$(BEHAT) -dl

vnc: ## Spawn xvncviewer to see local chromedriver running.
	@$(ECHO) "$(ORANGE)Consider using the in-browser client: $(BLUE)https://$(SITE_URL):7900/$(RESET)"
	@$(ECHO) "$(YELLOW)Beginning spawn of xvncviewer in background.$(RESET)"
	@xvncviewer localhost:5900
	@$(ECHO) "$(YELLOW)Completed spawn of xvncviewer in background.$(RESET)"
