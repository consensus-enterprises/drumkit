# Inspired by https://www.client9.com/self-documenting-makefiles/

.PHONY: help help-selfdoc help-message-header selfdoc-howto help-categories help-category

############################################################################
# What this next bit of grep/perl does:
# * grep for all lines containing self-doc messages
# * collect all categories from those lines
# * output the categories in a sorted list, which 
# * can then be captured in the HELP_CATEGORIES make variable.
#
# If you want to test this shell invocation on the command line, note the make-specific
# escaping of # chars and doubled $ chars, both of which you'll need to undo.
#
HELP_CATEGORIES ?= $(shell grep -h -E '^[a-zA-Z0-9_-]+:.*?\#\#@[^ ]* .*$$' $(MAKEFILE_LIST) | perl -nle'/\#\#@([^ ]+?) /; @a = split /[@ ]/, $$1; print join "\n", @a' | sort -u)
  
help-message-header:
	@$(ECHO) "$(BOLD)$(GREY)Available 'make' commands:$(RESET)"

help: help-selfdoc
help-selfdoc: help-message-header
help-selfdoc: ## Aggregate and print all short self-documentation messages from all included makefiles.
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?##@?[^ ]* .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?##@?[^ ]* "}; \
    {printf "$(BOLD)$(CYAN)%-30s $(RESET)%s\n", $$1, $$2}' | sort -u

help-category: ##@help [category] Aggregate and print all short self-documentation messages tagged with this category in all included makefiles.
ifeq ($(category),) # No category supplied: display the help categories doc
	@make -s help-categories
else ifeq ($(shell echo $(HELP_CATEGORIES)|grep $(category)),)
	@$(ECHO) ""
	@$(ECHO) "$(BOLD)$(GREY)Unrecognized help category: $(category)$(RESET)"
	@make -s help-categories
else
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?##@?.*?@$(category)' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##@[^ ]*? "}; \
    {printf "$(BOLD)$(CYAN)%-30s $(RESET)%s\n", $$1, $$2}'
endif

help-categories: ##@help List all available help categories.
	@$(ECHO) ""
	@$(ECHO) "$(BOLD)Available help categories:$(RESET)"
	@$(ECHO) ""
	@for categ in $(HELP_CATEGORIES); do echo $$categ; done
	@$(ECHO) ""
	@$(ECHO) "To see help for a particular category, try $(BOLD)$(CYAN)make help-[category].$(RESET)"
	@$(ECHO) ""

# Magical make-fu: achieving dyamic definition of targets like "make
# help-[category]" using a pattern rule (% matches anything not otherwise
# defined) and an automatic variable ($* gives the matched part of the rule).
# See: # https://www.gnu.org/software/make/manual/html_node/Pattern-Rules.html#Pattern-Rules
help-%:
	@make -s help-category category=$*

selfdoc-howto: ##@help Print a brief message explaining how to write self-documenting makefiles
	@echo
	@$(ECHO) "\t$(BOLD)$(GREY)WRITING SELF-DOCUMENTING MAKEFILES$(RESET)"
	@echo	
	@$(ECHO) "\t$(BOLD)To add a one-line description of a target that will display in $(YELLOW)make help-selfdoc$(RESET):"
	@$(ECHO) "\tAt the end of the list of dependencies for the target, add a pair of octothorpes (##) followed by"
	@$(ECHO) "\tthe text you want to have printed."
	@echo
	@$(ECHO) "\t$(BOLD)BASIC SYNTAX:$(RESET)"
	@$(ECHO) "\ttarget-name: ## Description of the current target."
	@echo
	@$(ECHO) "\t$(BOLD)NOTE:$(RESET)"
	@$(ECHO) "\t* The list of dependencies may be empty."
	@$(ECHO) "\t* Use $(YELLOW)[]$(RESET) to indicate arguments to the make target."
	@echo
	@$(ECHO) "\t* You can assign the target to one or more help categories by adding any number of '@foo' '@bar' tags between"
	@$(ECHO) "\tthe '##'' indicators and the text. The message will then appear when the user runs 'make help-foo' "
	@echo
	@$(ECHO) "\tYou can also introduce new categories this way. If it is the first use of a paricular category, it will be"
	@$(ECHO) "\tautomatically added to the list produced by 'make help-categories'. "
	@echo
	@$(ECHO) "\t$(BOLD)COMPLETE SYNTAX:$(RESET)"
	@$(ECHO) "\ttarget-name: list dependencies ##@foo @bar [argument1 argument2] Description of the current target."
	@echo
	@$(ECHO) "\t'[argument1 argument2] Description of the current target.' will appear in the " 
	@$(ECHO) "\tlists of targets when you run $(YELLOW)make help-selfdoc$(RESET), $(YELLOW)make help-foo$(RESET), and $(YELLOW)make help-bar$(RESET)"
	@echo	
	@$(ECHO) "\t$(YELLOW)foo$(RESET) and $(YELLOW)bar$(RESET) will appear in the list when you run $(YELLOW)make help-categories$(RESET)"
	@echo
	@$(ECHO) "\t$(GREY)Run $(YELLOW)make help-selfdoc$(GREY) to see more examples.$(RESET)"
	@echo
	@$(ECHO) "\t$(BOLD)To Add Multi-line help (like this one)... $(RESET)"
	@echo
	@$(ECHO) "\tWe use the .PHONY feature of makefiles to generate arbitrary targets which use ECHO"
	@$(ECHO) "\tto make multi-line output. To ensure that they are listed as possible help targets:"
	@$(ECHO) "\t* Start their target name with 'help-' and"
	@$(ECHO) "\t* Include a useful one-line description as above."
	@echo
	@$(ECHO) "\tThis message came from mk/selfdoc.mk if you want to look at an example."
	@echo
