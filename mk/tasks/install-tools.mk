help-install-tools:
	@echo "make install-tools"
	@echo "  Install all tools."

install-tools: phars

list-tools:
	@echo "The following tools are available for install:"
	@echo "  " $(PHARS)

# vi:syntax=makefile
