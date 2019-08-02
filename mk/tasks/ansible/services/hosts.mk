ANSIBLE_HOSTS_PLAYBOOK_FILES := $(strip $(shell if [ -d $(ANSIBLE_HOSTS_PLAYBOOK_DIR) ]; then find $(ANSIBLE_HOSTS_PLAYBOOK_DIR) -type f -name "*.yml"; fi))

.PHONY: hosts $(ANSIBLE_HOSTS_PLAYBOOK_FILES)

hosts: $(ANSIBLE_HOSTS_PLAYBOOK_FILES) ## Run all host playbooks.

ifneq ($(ANSIBLE_HOSTS_PLAYBOOK_FILES),)
$(ANSIBLE_HOSTS_PLAYBOOK_FILES): ansible-playbook ## [playbooks/hosts/HOST_NAME.yml] Run the specified host playbook.
	$(ANSIBLE_PLAYBOOK_CMD) $@
endif
