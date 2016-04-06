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
	@echo Removing git submodule at $(SUBMODULE)
	if git submodule status "$(SUBMODULE)" >/dev/null 2>&1; then git submodule deinit $(SUBMODULE); git rm -f $(SUBMODULE); fi
	if [ -d .git/modules/$(SUBMODULE) ]; then rm -rf .git/modules/$(SUBMODULE); fi
	git config -f .gitmodules --remove-section "submodule.$(SUBMODULE)"
	if [ -z "$$(cat .gitmodules)" ]; then git rm -f .gitmodules; else git add .gitmodules; fi

# vi:syntax=makefile
