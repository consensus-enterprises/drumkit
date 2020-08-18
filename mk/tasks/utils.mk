user   = $(shell whoami)
utils  = screen htop strace tree unzip
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

# vi:syntax=makefile
