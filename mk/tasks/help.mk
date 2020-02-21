HELP_HOOKS = $(shell grep "^help-[^:]*" $(MK_DIR)/mk -rho)
HELP_HOOKS_TOOLS = $(shell grep "^tools-help-[^:]*" $(MK_DIR)/mk -rho)

help-help:
	@echo "make help"
	@echo "  Print this help message."
	@echo "make tools-help"
	@echo "  Print install help for all tools."

#help: $(HELP_HOOKS)
tools-help: $(HELP_HOOKS_TOOLS)

list-help:
	@echo "The following help hooks are defined:"
	@echo "  " $(HELP_HOOKS)
	@echo "The following 'tools' help hooks are defined (displayed with 'make tools-help'):"
	@echo "  " $(HELP_HOOKS_TOOLS)

# vi:syntax=makefile
