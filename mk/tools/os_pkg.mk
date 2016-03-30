OS = $(shell uname)
ifeq ($(OS), Darwin)
  include $(MK_DIR)/mk/tools/os_pkg/dmg.mk
else
  $(error '$(OS)' is not a supported operating system)
endif


