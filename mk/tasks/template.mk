# Generic templating method.

.template:
	$(ECHO) "$(YELLOW)Creating file: '$(TEMPLATE_TARGET)'.$(RESET)"
	@mkdir -p $(TEMPLATE_TARGETDIR)
	@$(TEMPLATE_VARS) envsubst < $(TEMPLATE_SOURCE) > $(TEMPLATE_TARGET)
