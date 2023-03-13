prompt = $(shell read -p '$(1) [$(2)]: '; echo "$${REPLY:-$(2)}")

# Example:
#  PROMPT  = "Tell me what you want MY_VAR to be"
#  DEFAULT = "Some default value"
#  MY_VAR ?= $(call prompt,$(PROMPT),$(DEFAULT))
#
#  foo:
#  	@echo "Var is: $(MY_VAR)"
