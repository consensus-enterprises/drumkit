OS ?= $(shell uname)
ifeq ($(OS), Darwin)
  include $(MK_DIR)/mk/tools/os_pkg/dmg.mk
else ifeq ($(OS), Linux)
  #include $(MK_DIR)/mk/tools/os_pkg/deb.mk
else
  $(error '$(OS)' is not a supported operating system)
endif


