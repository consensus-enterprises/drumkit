GROUPS_PLAYBOOK_FILES := $(shell if [ -d $(GROUPS_PLAYBOOK_DIR) ]; then find $(GROUPS_PLAYBOOK_DIR) -type f -name "*.yml"; fi)

.PHONY: groups $(GROUPS_PLAYBOOK_FILES)

groups: $(GROUPS_PLAYBOOK_DIR) $(GROUPS_PLAYBOOK_FILES) ## Run all group playbooks.

ifeq ($(strip $(GROUPS_PLAYBOOK_FILES)),)
$(GROUPS_PLAYBOOK_FILES): ## [playbooks/groups/GROUP_NAME.yml] Run the specified group playbook.
	$(ANSIBLE_PLAYBOOK_CMD) $@
endif
