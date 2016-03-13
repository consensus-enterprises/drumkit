BIN_DIR       = $(MK_DIR)/.local/bin
SRC_DIR       = $(MK_DIR)/.local/src

init: $(SRC_DIR) $(BIN_DIR)

$(SRC_DIR):
	@echo Creating source directory.
	@mkdir -p $(SRC_DIR)

$(BIN_DIR):
	@echo Creating binary directory.
	@mkdir -p $(BIN_DIR)

clean:
	@rm -rf $(BIN_DIR)
	@rm -rf $(SRC_DIR)

# vi:syntax=makefile
