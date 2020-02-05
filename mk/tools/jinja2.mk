jinja2: deps-python
	@echo "Installing jinja2."
	@if test -f "$(BIN_DIR)/jinja2"; then (echo "Jinja2 already installed on your system."); else (sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq python3-jinja2) && (echo "Installed jinja2 on your system."); fi
	@if test -f "$(BIN_DIR)/jinja2"; then (echo "Found jinja2c-li already in your kit."); else (pip3 install jinja2-cli --install-option="--install-scripts=$(BIN_DIR)") && (echo "Installed jinja2-cli in your kit."); fi
	@which jinja2

clean-jinja2:
	@echo "Cleaning jinja2."
	@pip3 list 2>/dev/null | grep jinja2-cli >/dev/null || pip3 uninstall -y jinja2-cli
	@sudo DEBIAN_FRONTEND=noninteractive apt-get remove -y -qq python3-jinja2
