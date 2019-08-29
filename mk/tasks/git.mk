branch ?= master

git-submodule-update: ## Update all Git submodules
	git submodule update --init --recursive

git-submodule-pull: ## [branch=master] Pull in the latest code for all submodules
	git submodule foreach git checkout $(branch)
	git submodule foreach git pull origin $(branch)

git-rm-submodule-help:
	@echo "make git-rm-submodule SUBMODULE=<git submodule path>"
	@echo "  Completely remove the git submodule registered at <git submodule path>"

git-rm-submodule:
	@if git submodule status "$(SUBMODULE)" >/dev/null 2>&1; then \
    echo "Beginning removal of git submodule at $(SUBMODULE)."; \
    echo "De-initializing submodule."; \
    git submodule deinit $(SUBMODULE); \
    echo "Removing submodule code."; \
    git rm -f $(SUBMODULE); \
  fi
	@if [ -d .git/modules/$(SUBMODULE) ]; then \
    echo "Removing submodule directory."; \
    rm -rf .git/modules/$(SUBMODULE); \
  fi
	@#git config -f .gitmodules --remove-section "submodule.$(SUBMODULE)" # No longer needed?
	@if [ -z "$$(cat .gitmodules)" ]; then \
    echo "Removing empty .gitmodules file." \
    git rm -f .gitmodules; \
  else \
    echo "Registering changes to .gitmodules file."; \
    git add .gitmodules; \
  fi

# vi:syntax=makefile
