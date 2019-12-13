# Run our test suite.

.PHONY: tests tests-ci tests-wip tests-js vnc test-steps tests-upstream

tests-complete: tests tests-upstream
tests:
	lando behat

tests-upstream:
	lando behat --stop-on-failure --colors --suite=upstream --tags='~@wip'

tests-ci:
	./bin/behat --stop-on-failure --colors --suite=ci

tests-wip:
	lando behat --tags=wip

tests-js:
	lando behat --tags=javascript

test-steps:
	lando behat -dl
