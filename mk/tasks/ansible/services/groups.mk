GROUPS_PLAYBOOK_DIR   := playbooks/groups
GROUPS_PLAYBOOK_FILES := $(shell if [ -d $(GROUPS_PLAYBOOK_DIR) ]; then find $(GROUPS_PLAYBOOK_DIR) -type f -name "*.yml"; fi)

.PHONY: groups $(GROUPS_PLAYBOOK_FILES)

groups: $(GROUPS_PLAYBOOK_DIR) $(GROUPS_PLAYBOOK_FILES) ## Run all group playbooks.

$(GROUPS_PLAYBOOK_DIR):
	mkdir -p $(GROUPS_PLAYBOOK_DIR)

$(GROUPS_PLAYBOOK_FILES): ## [playbooks/groups/GROUP_NAME.yml] Run the specified group playbook.
	$(ANSIBLE_PLAYBOOK_CMD) $@
