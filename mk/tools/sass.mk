SASS_VERSION ?= 1.24.4
SASS_OS      ?= linux
SASS_ARCH    ?= x64
SASS_RELEASE ?= dart-sass-$(SASS_VERSION)-$(SASS_OS)-$(SASS_ARCH)

.PHONY: sass

sass: $(BIN_DIR)/sass
	$(ECHO) "Sass installed."
clean-sass:
	@rm -rf $(SRC_DIR)/sass $(BIN_DIR)/sass

$(BIN_DIR)/sass: $(SRC_DIR)/sass/$(SASS_RELEASE)
	$(ECHO) "Creating link to Sass binary."
	@ln -s $(SRC_DIR)/sass/$(SASS_RELEASE)/dart-sass/sass $(BIN_DIR)/sass
	@$(SRC_DIR)/sass/$(SASS_RELEASE)/dart-sass/sass --version

$(SRC_DIR)/sass:
	$(ECHO) "Creating source directory for Sass."
	@mkdir -p $(SRC_DIR)/sass

$(SRC_DIR)/sass/$(SASS_RELEASE): $(SRC_DIR)/sass
	$(ECHO) "Downloading $(SASS_RELEASE) tarball."
	@wget -q https://github.com/sass/dart-sass/releases/download/$(SASS_VERSION)/$(SASS_RELEASE).tar.gz -O /tmp/$(SASS_RELEASE).tar.gz
	$(ECHO) "Creating source directory for $(SASS_VERSION) release of Sass."
	@mkdir $(SRC_DIR)/sass/$(SASS_RELEASE)
	$(ECHO) "Expanding Sass from tarball."
	@tar xzf /tmp/$(SASS_RELEASE).tar.gz -C $(SRC_DIR)/sass/$(SASS_RELEASE)
	$(ECHO) "Removing tarball."
	@rm /tmp/$(SASS_RELEASE).tar.gz
