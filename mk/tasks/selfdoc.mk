# Inspired by https://www.client9.com/self-documenting-makefiles/

.PHONY: help-selfdoc help-message-header selfdoc-howto
help-message-header:
	@$(ECHO) "$(BOLD)$(GREY)Available 'make' commands:$(RESET)"

help-selfdoc: help-message-header ## Aggregate and print all self-documentation from all included makefiles.
	@awk -F ':|##' '/^[^\t].+?:.*?##/ {\
      printf "  "; \
      if ($$1 !~ /^\$$/) printf "$(GREEN)%s$(RESET) ", $$1; \
      if ((NF==3) && $$3 ~ /^\s+?[][]/) {\
        split($$3, a, "[][]"); \
        printf "$(GREY)[%s]$(GREY)\n    $(YELLOW)%s$(RESET)\n", a[2], a[3]; \
      } else {\
        printf "\n    $(YELLOW)%s$(RESET)\n", $$3; \
      }\
  }' $(MAKEFILE_LIST)

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
	@$(ECHO) "\t\t\$$(VIRTUAL_TARGET): ## [arguments to the virtual target] One-line description of virtual target."
	@$(ECHO)
	@$(ECHO) "\t$(GREY)Run $(YELLOW)make help-selfdoc$(GREY) to see more examples.$(RESET)"
	@$(ECHO)
