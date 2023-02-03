# Generic templating method.

.template: mustache
	$(ECHO) "$(YELLOW)Creating file: '$(TEMPLATE_TARGET)'.$(RESET)"
	@mkdir -p $(TEMPLATE_TARGETDIR)
	@$(TEMPLATE_VARS) mustache ENV $(TEMPLATE_SOURCE) > $(TEMPLATE_TARGET)

