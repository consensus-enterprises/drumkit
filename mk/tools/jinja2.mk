jinja2: deps-python
	@echo "Installing jinja2."
	@sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq python3-jinja2
	@pip3 list 2>/dev/null | grep jinja2-cli || pip3 install jinja2-cli --install-option="--install-scripts=$(BIN_DIR)"
	@which jinja2

clean-jinja2:
	@echo "Cleaning jinja2."
	@pip3 list 2>/dev/null | grep jinja2-cli >/dev/null || pip3 uninstall -y jinja2-cli
	@sudo DEBIAN_FRONTEND=noninteractive apt-get remove -y -qq python3-jinja2
