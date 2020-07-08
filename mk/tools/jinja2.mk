jinja2_installed = $(shell test -f "$(BIN_DIR)/jinja2")

jinja2-real: deps-python
	@echo "Installing jinja2."
	@if test -f "$(BIN_DIR)/jinja2"; then (echo "Found jinja2-cli already in your kit."); else (pip install jinja2-cli) && (echo "Installed jinja2-cli in your kit."); fi
	@which jinja2

jinja2:
ifeq ($(jinja2_installed),)
	make -s jinja2-real
endif

clean-jinja2:
	@echo "Cleaning jinja2."
	@pip list 2>/dev/null | grep jinja2-cli >/dev/null || pip uninstall -y jinja2-cli
	@pip list 2>/dev/null | grep jinja2 >/dev/null || pip uninstall -y jinja2
