help-test:
	@echo "make test"
	@echo "  Run tests."

test: behat-config
	@source behat_params.sh && bin/behat
wip: behat-config
	@source behat_params.sh && bin/behat --tags=wip

self-test: behat
	@behat
self-wip: behat
	@behat --tags=wip --append-snippets

# vi:syntax=makefile
