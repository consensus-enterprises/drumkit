INSTALL_HOOKS = $(shell grep "^install-[^:]*" $(MK_DIR)/mk -rho)

help-install:
	@echo "make install"
	@echo "  Install all tools."

phars: drush composer

install: $(INSTALL_HOOKS)

list-install:
	@echo "The following 'install' hooks are defined:"
	@echo "  " $(INSTALL_HOOKS)

# vi:syntax=makefile
