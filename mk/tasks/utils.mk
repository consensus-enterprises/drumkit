user   = $(shell whoami)
utils  = screen htop strace tree
bashrc = export PATH="$(BIN_DIR):$$PATH"

bashrc:
	@grep -q -F '$(bashrc)' ~/.bashrc || echo '$(bashrc)' >> ~/.bashrc

check: check-paths list-help list-install

check-paths:
	$(info PROJECT_ROOT: $(PROJECT_ROOT))
	$(info MK_DIR: $(MK_DIR))
	$(info FILES_DIR: $(FILES_DIR))

fix-time:
	@sudo ntpdate -s time.nist.gov

deps: deps-utils
deps-utils:
	@echo Installing some utilities
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install $(utils)

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
