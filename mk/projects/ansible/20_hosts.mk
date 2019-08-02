ANSIBLE_HOSTS_PLAYBOOK_DIR=$(ANSIBLE_PLAYBOOKS_DIR)/hosts
ANSIBLE_HOSTS_PLAYBOOK_TEMPLATE=$(FILES_DIR)/ansible/templates/host-playbook.yml
ANSIBLE_HOST_VARS_DIR=$(ANSIBLE_INVENTORY_DIR)/host_vars
ANSIBLE_HOST_VARS_TEMPLATE=$(FILES_DIR)/ansible/templates/host-vars.yml

host:=example-host

ansible-add-host: $(ANSIBLE_HOSTS_PLAYBOOK_DIR) $(ANSIBLE_HOST_VARS_DIR)
	@echo "Generating Ansible host config files for $(host)."
	@echo "Generating host playbook."
	@jinja2 -D host=$(host) -o $(ANSIBLE_HOSTS_PLAYBOOK_DIR)/$(host).yml $(ANSIBLE_HOSTS_PLAYBOOK_TEMPLATE)
	@echo "Initializing Ansible host variables file."
	@jinja2 -D host=$(host) -o $(ANSIBLE_HOST_VARS_DIR)/$(host).yml $(ANSIBLE_HOST_VARS_TEMPLATE)
	@echo "Finished generating Ansible host config files for $(host)."

ansible-clean-host:
	@echo "Cleaning up Ansible host config files for $(host)."
	@rm -f $(ANSIBLE_HOSTS_PLAYBOOK_DIR)/$(host).yml $(ANSIBLE_HOST_VARS_DIR)/$(host).yml

$(ANSIBLE_HOSTS_PLAYBOOK_DIR) $(ANSIBLE_HOST_VARS_DIR):
	@echo "Initializing directory '$@'."
	@mkdir -p $@
