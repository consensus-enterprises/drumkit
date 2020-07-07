jinja2_installed = $(shell test -f "$(BIN_DIR)/jinja2")

jinja2-real: deps-python
	@echo "Installing jinja2."
	CWD=`pwd`
	pip3 install --prefix=`pwd`/.mk/.local jinja2
	pip3 install --prefix=`pwd`/.mk/.local jinja2-cli 
	echo "Installed jinja2-cli inside .mk/.local."

jinja2:
ifeq ($(jinja2_installed),)
	make -s jinja2-real
else
	@echo "Found jinja2-cli already in your kit.";
endif

clean-jinja2:
	@echo "Cleaning jinja2."
	@pip3 list 2>/dev/null | grep jinja2-cli >/dev/null || pip3 uninstall -y jinja2-cli
	@pip3 list 2>/dev/null | grep jinja2 > /dev/null || pip3 uninstall -y jinja2
