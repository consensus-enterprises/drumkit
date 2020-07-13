jinja2_installed = $(shell test -f "$(BIN_DIR)/jinja2")

jinja2-real: deps-python
	@echo "Installing jinja2."
	@pip3 install jinja2-cli --install-option="--install-scripts=$(BIN_DIR)"
	@echo "Installed jinja2-cli in your kit."
	@which jinja2

jinja2:
ifeq (jinja2_installed,)
	@make -s jinja2-real
else
	@echo "Found jinja2-cli already in your kit."
endif

clean-jinja2:
	@echo "Cleaning jinja2."
	@pip3 list 2>/dev/null | grep jinja2-cli >/dev/null || pip3 uninstall -y jinja2-cli
	@sudo DEBIAN_FRONTEND=noninteractive apt-get remove -y -qq python3-jinja2
