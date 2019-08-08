ANSIBLE_HOSTS_PLAYBOOK_DIR=$(ANSIBLE_PLAYBOOKS_DIR)/hosts
ANSIBLE_HOSTS_PLAYBOOK_TEMPLATE=$(FILES_DIR)/ansible/templates/host-playbook.yml.j2
ANSIBLE_HOST_VARS_DIR=$(ANSIBLE_INVENTORY_DIR)/host_vars
ANSIBLE_HOST_VARS_TEMPLATE=$(FILES_DIR)/ansible/templates/host-vars.yml.j2

host ?= example-host
ANSIBLE_HOST_VARS_FILENAME ?= $(host).yml

.PHONY: ansible-add-host ansible-add-host-vars-file ansible-add-host-playbook ansible-clean-host

ansible-add-host-vars-file: $(ANSIBLE_HOST_VARS_DIR)
	@echo "Initializing Ansible host variables file."
	@jinja2 -D host=$(host) -D group=$(group) -o $(ANSIBLE_HOST_VARS_DIR)/$(ANSIBLE_HOST_VARS_FILENAME) $(ANSIBLE_HOST_VARS_TEMPLATE)

ansible-add-host-playbook: $(ANSIBLE_HOSTS_PLAYBOOK_DIR)
	@echo "Generating host playbook."
	@jinja2 -D host=$(host) -o $(ANSIBLE_HOSTS_PLAYBOOK_DIR)/$(host).yml $(ANSIBLE_HOSTS_PLAYBOOK_TEMPLATE)

ansible-add-host-intro:
	@echo "Generating Ansible host config files for $(host)."
ansible-add-host: ansible-add-host-intro ansible-add-host-playbook ansible-add-host-vars-file
	@echo "Finished generating Ansible host config files for $(host)."

ansible-clean-host:
	@echo "Cleaning up Ansible host config files for $(host)."
	@rm -f $(ANSIBLE_HOSTS_PLAYBOOK_DIR)/$(host).yml $(ANSIBLE_HOST_VARS_DIR)/$(host).yml

$(ANSIBLE_HOSTS_PLAYBOOK_DIR) $(ANSIBLE_HOST_VARS_DIR):
	@echo "Initializing directory '$@'."
	@mkdir -p $@
