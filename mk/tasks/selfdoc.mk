# Inspired by https://www.client9.com/self-documenting-makefiles/

.PHONY: help help-selfdoc help-selfdoc-short help-message-header selfdoc-howto help-categories help-category

HELP_CATEGORIES ?= $(shell grep -h -E '^[a-zA-Z0-9_-]+:.*?\#\#@[^ ]* .*$$' $(MAKEFILE_LIST) | awk 'match($$0,/@[^ ]+/){ print substr($$0, RSTART+1,RLENGTH-1)}' | sort -u)

help-message-header:
	@$(ECHO) "$(BOLD)$(GREY)Available 'make' commands:$(RESET)"

help: help-selfdoc-short
help-selfdoc-short: help-message-header 
help-selfdoc-short: ## Aggregate and print all short self-documentation messages from all included makefiles.
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?##@?[^ ]* .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?##@?[^ ]* "}; \
    {printf "$(BOLD)$(CYAN)%-30s $(RESET)%s\n", $$1, $$2}' | sort -u

help-category: ##@help [category] Aggregate and print all short self-documentation messages from this category from all included makefiles.
ifeq ($(category),) # No category supplied: display the help categories doc
	@make -s help-categories
else ifeq ($(shell echo $(HELP_CATEGORIES)|grep $(category)),)
	@$(ECHO) ""
	@$(ECHO) "$(BOLD)$(GREY)Unrecognized help category: $(category)$(RESET)"
	@make -s help-categories
else
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?##@$(category) .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##@$(category)"}; \
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

selfdoc-howto: ## Print a brief message explaining how to write self-documenting makefiles
	@$(ECHO)
	@$(ECHO) "$(BOLD)$(GREY)WRITING SELF-DOCUMENTING MAKEFILES$(RESET)"
	@$(ECHO)
	@$(ECHO) "\t$(GREY)When adding make targets to your Drumkit makefiles, target names (ending with a colon),"
	@$(ECHO) "\talong with comments that start with '##', will be scraped and aggregated in the output of"
	@$(ECHO) "\t$(YELLOW)make help-selfdoc$(GREY). Use $(YELLOW)[]$(GREY) to indicate arguments to the make target.$(RESET)"
	@$(ECHO)
	@$(ECHO) "\t$(GREY)Virtual make targets will be documented with no target name.$(RESET)" 
	@$(ECHO)
	@$(ECHO) "$(BOLD)$(GREY)EXAMPLE$(RESET)"
	@$(ECHO)
	@$(ECHO) "\t$(GREY)In a makefile:$(RESET)"
	@$(ECHO)
	@$(ECHO) "\t\ttarget: ## [arguments to the target] A one-line description of target."
	@$(ECHO)
	@$(ECHO) "\t$(GREY)Run $(YELLOW)make help-selfdoc$(GREY) to see more examples.$(RESET)"
	@$(ECHO)
