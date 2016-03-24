help-install:
	@echo "make install"
	@echo "  Install all tools."

install: phars

list-tools:
	@echo "The following tools are available for install:"
	@echo "  " $(PHARS)

# vi:syntax=makefile
