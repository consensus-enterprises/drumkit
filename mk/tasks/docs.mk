# Build and serve our docs site locally.

.PHONY: docs docs-kill

HUGO_SERVE_CMD=hugo serve --noHTTPCache --quiet --disableFastRender

docs: ## Run Hugo server locally in the background (http://localhost:1313).
	cd docs && $(HUGO_SERVE_CMD) 2>&1 > /dev/null &

#TODO add support to kill local server on a mac
docs-kill: ## Shut down the Hugo server.
	pkill -xfe "$(HUGO_SERVE_CMD)"
