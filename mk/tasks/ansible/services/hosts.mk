HOSTS_PLAYBOOK_DIR := playbooks/hosts
HOSTS_PLAYBOOK_FILES := $(shell if [ -d $(HOSTS_PLAYBOOK_DIR) ]; then find $(HOSTS_PLAYBOOK_DIR) -type f -name "*.yml"; fi)

.PHONY: hosts $(HOSTS_PLAYBOOK_FILES)

hosts: $(HOSTS_PLAYBOOK_DIR) $(HOSTS_PLAYBOOK_FILES) ## Run all host playbooks.

$(HOSTS_PLAYBOOK_DIR):
	mkdir -p $(HOSTS_PLAYBOOK_DIR)

$(HOSTS_PLAYBOOK_FILES): ## [Full/path/to/host/playbook] Run the specified host playbook.
	$(ANSIBLE_PLAYBOOK_CMD) $@
