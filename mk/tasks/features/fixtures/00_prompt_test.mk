MY_PROMPT    = Tell me what you want MY_VARIABLE to be
MY_DEFAULT   = Some default value
MY_VARIABLE ?= $(call prompt,$(MY_PROMPT),$(MY_DEFAULT))

target_without_var:
	@echo "I'm not using MY_VARIABLE."

target_with_var:
	@echo "MY_VARIABLE is: $(MY_VARIABLE)"
