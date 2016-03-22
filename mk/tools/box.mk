TOOL ?= box

box      ?= $(BOX_BIN)
BOX_REL  ?= 2.7.2
BOX_URL  ?= https://github.com/box-project/box2/releases/download/$(BOX_REL)/box-$(BOX_REL).phar
BOX_DEPS ?= php5-cli
BOX_DIR  ?= $(MK_DIR)/.local/box
BOX_SRC  ?= $(SRC_DIR)/box
BOX_BIN  ?= $(BIN_DIR)/box
BOX_PHAR ?= $(BOX_SRC)/box-$(BOX_REL).phar

tools-help-box:
	@echo "make box"
	@echo "  Install Box."
	@echo "make box BOX_REL=$(BOX_REL)"
	@echo "  Install the $(BOX_REL) release of Box."

clean-box:
	@echo Removing Box.
	@rm -f $(BOX_BIN)
	@rm -rf $(BOX_SRC)

deps-box: apt-update mysql-server
	@echo Installing Box dependencies.
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install $(BOX_DEPS)

install-box: init $(BOX_BIN)
box: install-box

$(BOX_BIN): $(BOX_PHAR)
	@echo Installing the $(BOX_REL) release of Box.
	@ln -sf $(BOX_PHAR) $(BOX_BIN)
	@chmod a+x $(BOX_BIN)
	@$(box) --version

$(BOX_PHAR):
	@echo Downloading the $(BOX_REL) release of Box.
	@mkdir -p $(BOX_SRC)
	@curl -SsL $(BOX_URL) -z $(BOX_PHAR) -o $(BOX_PHAR)

# vi:syntax=makefile
