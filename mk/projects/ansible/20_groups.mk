ANSIBLE_GROUPS_PLAYBOOK_DIR=$(ANSIBLE_PLAYBOOKS_DIR)/groups
ANSIBLE_GROUPS_PLAYBOOK_TEMPLATE=$(FILES_DIR)/ansible/templates/group-playbook.yml.j2
ANSIBLE_GROUP_VARS_DIR=$(ANSIBLE_INVENTORY_DIR)/group_vars
ANSIBLE_GROUP_VARS_TEMPLATE=$(FILES_DIR)/ansible/templates/group-vars.yml.j2

group:=example_group

ansible-add-group: $(ANSIBLE_GROUPS_PLAYBOOK_DIR) $(ANSIBLE_GROUP_VARS_DIR)
	@echo "Generating Ansible group config files for $(group)."
	@echo "Generating group playbook."
	@jinja2 -D group=$(group) -o $(ANSIBLE_GROUPS_PLAYBOOK_DIR)/$(group).yml $(ANSIBLE_GROUPS_PLAYBOOK_TEMPLATE)
	@echo "Initializing Ansible group variables file."
	@jinja2 -D group=$(group) -o $(ANSIBLE_GROUP_VARS_DIR)/$(group).yml $(ANSIBLE_GROUP_VARS_TEMPLATE)
	@echo "Finished generating Ansible group config files for $(group)."

ansible-clean-group:
	@echo "Cleaning up Ansible group config files for $(group)."
	@rm -f $(ANSIBLE_GROUPS_PLAYBOOK_DIR)/$(group).yml $(ANSIBLE_GROUP_VARS_DIR)/$(group).yml

$(ANSIBLE_GROUPS_PLAYBOOK_DIR) $(ANSIBLE_GROUP_VARS_DIR):
	@echo "Initializing directory '$@'."
	@mkdir -p $@
