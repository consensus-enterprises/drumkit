# Run our test suite.

.PHONY: tests tests-ci tests-wip tests-js vnc test-steps tests-upstream

tests-complete: tests tests-upstream
tests: ## Run Behat test suite
	ddev behat

tests-upstream:
	ddev behat --stop-on-failure --colors --suite=upstream --tags='~@wip'

tests-ci:
	./bin/behat --stop-on-failure --colors --suite=ci

tests-wip:
	ddev behat --tags=wip

tests-js:
	ddev behat --tags=javascript

test-steps:
	ddev behat -dl
