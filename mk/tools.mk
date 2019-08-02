LOCAL_DIR = $(MK_DIR)/.local
BIN_DIR   = $(LOCAL_DIR)/bin
SRC_DIR   = $(LOCAL_DIR)/src
MK_OS     = $(shell echo `uname -s` | tr A-Z a-z)
MK_ARCH   = $(shell echo `uname -p` | tr A-Z a-z)

init-mk: $(SRC_DIR) $(BIN_DIR)

$(LOCAL_DIR):
	@echo Creating .local directory.
	@mkdir -p $(SRC_DIR)

$(SRC_DIR): $(LOCAL_DIR)
	@echo Creating local source directory.
	@mkdir -p $(SRC_DIR)
	@touch $(SRC_DIR)

$(BIN_DIR): $(LOCAL_DIR)
	@echo Creating local binary directory.
	@mkdir -p $(BIN_DIR)
	@touch $(BIN_DIR)

clean-mk:
	@rm -rf $(BIN_DIR)
	@rm -rf $(SRC_DIR)

include $(MK_DIR)/mk/tools/*.mk

# vi:syntax=makefile
