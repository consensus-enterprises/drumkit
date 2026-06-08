# Build and serve our docs site locally.

.PHONY: docs-start docs-kill

HUGO_SERVER_PORT ?= 1313
HUGO_SERVER_CMD=hugo server --quiet --buildDrafts --buildFuture --disableFastRender --noHTTPCache --openBrowser --navigateToChanged --port $(HUGO_SERVER_PORT) --renderStaticToDisk --tlsAuto --noBuildLock --renderToMemory

docs-start: ## Run Hugo server locally in the background.
	@cd docs && $(HUGO_SERVER_CMD) 2>&1 > /dev/null &

#TODO add support to kill local server on a mac
docs-kill: ## Shut down the Hugo server.
	@pkill -xf "$(HUGO_SERVER_CMD)"

check-links:
	@echo "Checking for broken links."
	@echo "--"
	@if \
           wget https://localhost:$(HUGO_SERVER_PORT) \
             --spider \
             --recursive \
             --level=0 \
             --no-directories \
             --no-parent \
             --force-html \
             --reject="*.js" \
             --debug \
             --execute robots=off \
           2>&1 \
           | grep "HTTP/1.1 [4-9]" -B 15 \
           | grep --invert-match "^---" \
           | grep --extended-regexp 'HEAD|Referer|HTTP/1.1|--'; \
         then \
           echo -e "--\nFound broken links (see above)"; \
           exit 1; \
         else \
           echo -e "--\nNo broken links found"; \
         fi
