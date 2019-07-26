HOSTS_PLAYBOOK_FILES := $(shell if [ -d $(HOSTS_PLAYBOOK_DIR) ]; then find $(HOSTS_PLAYBOOK_DIR) -type f -name "*.yml"; fi)

.PHONY: hosts $(HOSTS_PLAYBOOK_FILES)

hosts: $(HOSTS_PLAYBOOK_DIR) $(HOSTS_PLAYBOOK_FILES) ## Run all host playbooks.

ifeq ($(strip $(HOSTS_PLAYBOOK_FILES)),)
$(HOSTS_PLAYBOOK_FILES): ## [playbooks/hosts/HOST_NAME.yml] Run the specified host playbook.
	$(ANSIBLE_PLAYBOOK_CMD) $@
endif
