user         = $(shell whoami)
utils        = screen htop strace tree
bashrc       = export PATH="$(BIN_DIR):$$PATH"

init: $(BIN_DIR) $(SRC_DIR)
	@grep -q -F '$(bashrc)' ~/.bashrc || echo '$(bashrc)' >> ~/.bashrc

$(BIN_DIR):
	@mkdir -p $(BIN_DIR)

$(SRC_DIR):
	@mkdir -p $(SRC_DIR)

fix-time:
	@sudo ntpdate -s time.nist.gov

deps-utils: vagrant
	@echo Installing some utilities
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install $(utils)

clean:
	@rm -rf $(BIN_DIR)
	@rm -rf $(SRC_DIR)

vm:
ifneq ($(user), vagrant)
ifneq ($(user), travis)
	@echo Current user is \'$(user)\'.
	@echo This command \(make $@\) must be built in a \'vagrant\' or \'travis\' vm.
	@exit 1
endif
endif

vagrant:
ifneq ($(user), vagrant)
	@echo Current user is \'$(user)\'.
	@echo This command \(make $@\) must be built in a \'vagrant\' vm.
	@exit 1
endif

