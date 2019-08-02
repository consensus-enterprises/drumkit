ANSIBLE_GROUPS_PLAYBOOK_FILES := $(strip $(shell if [ -d $(ANSIBLE_GROUPS_PLAYBOOK_DIR) ]; then find $(ANSIBLE_GROUPS_PLAYBOOK_DIR) -type f -name "*.yml"; fi))

.PHONY: groups $(ANSIBLE_GROUPS_PLAYBOOK_FILES)

groups: $(ANSIBLE_GROUPS_PLAYBOOK_FILES) ## Run all group playbooks.

ifneq ($(ANSIBLE_GROUPS_PLAYBOOK_FILES),)
$(ANSIBLE_GROUPS_PLAYBOOK_FILES): ansible-playbook ## [playbooks/groups/GROUP_NAME.yml] Run the specified group playbook.
	$(ANSIBLE_PLAYBOOK_CMD) $@
endif
