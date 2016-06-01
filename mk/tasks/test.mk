help-test:
	@echo "make test-drumkit"
	@echo "  Run Behat tests for Drumkit."
	@echo "make test-drumkit-wip"
	@echo "  Run work-in-progress Behat tests for Drumkit."

test-drumkit: behat
	@cd $(MK_DIR) && \
	behat
test-drumkit-wip: behat
	@cd $(MK_DIR) && \
	behat --tags=wip --append-snippets

# vi:syntax=makefile
