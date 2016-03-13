help_hooks = $(shell grep "^help-[^:]*" $(mk_dir)/mk -rho)
help_hooks_hidden = $(shell grep "^_help-[^:]*" $(mk_dir)/mk -rho)

help: $(help_hooks)
all-help: $(help_hooks) $(help_hooks_hidden)

list-help:
	@echo "The following help hooks are defined:"
	@echo $(help_hooks)
	@echo "The following hidden help hooks are defined (displayed with 'all-help'):"
	@echo $(help_hooks_hidden)

