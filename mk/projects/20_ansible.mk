# Tasks for initializing ansible projects.
ANSIBLE_PLAYBOOKS_DIR=$(PROJECT_ROOT)/playbooks
ANSIBLE_HOSTS_PLAYBOOK_DIR=$(ANSIBLE_PLAYBOOKS_DIR)/hosts
ANSIBLE_GROUPS_PLAYBOOK_DIR=$(ANSIBLE_PLAYBOOKS_DIR)/groups
ANSIBLE_INVENTORY_DIR=$(PROJECT_ROOT)/inventory
ANSIBLE_HOST_VARS_DIR=$(ANSIBLE_INVENTORY_DIR)/host_vars
ANSIBLE_GROUP_VARS_DIR=$(ANSIBLE_INVENTORY_DIR)/group_vars

init-project-ansible-intro:
	@echo "Initializing Drumkit Ansible project."
init-project-ansible: init-project-ansible-intro ansible roles/consensus.utils ansible.cfg $(ANSIBLE_HOSTS_PLAYBOOK_DIR) $(ANSIBLE_GROUPS_PLAYBOOK_DIR) $(ANSIBLE_INVENTORY_DIR) $(ANSIBLE_HOST_VARS_DIR) $(ANSIBLE_GROUP_VARS_DIR) README.md ## Initialize a project for working with Ansible.
	@echo "Finished initializing Drumkit Ansible project."

roles/consensus.utils:
	@git submodule add $(CONSENSUS_GIT_URL_BASE)/ansible-roles/ansible-role-utils $@

$(ANSIBLE_HOSTS_PLAYBOOK_DIR):
	@echo "Initializing Ansible hosts playbook directory ($@)."
	@mkdir -p $@
	@cp $(FILES_DIR)/ansible/examples/host_playbook.yml $@/example_host.yml

$(ANSIBLE_GROUPS_PLAYBOOK_DIR):
	@echo "Initializing Ansible groups playbook directory ($@)."
	@mkdir -p $@
	@cp $(FILES_DIR)/ansible/examples/group_playbook.yml $@/example_group.yml

$(ANSIBLE_INVENTORY_DIR):
	@echo "Initializing Ansible inventory directory ($@)."
	@mkdir -p $@
	@cp $(FILES_DIR)/ansible/examples/inventory.yml $@/example_inventory.yml

$(ANSIBLE_HOST_VARS_DIR): $(ANSIBLE_INVENTORY_DIR)
	@echo "Initializing Ansible host variables directory ($@)."
	@mkdir -p $@
	@cp $(FILES_DIR)/ansible/examples/host_vars.yml $@/example_host.yml

$(ANSIBLE_GROUP_VARS_DIR): $(ANSIBLE_INVENTORY_DIR)
	@echo "Initializing Ansible group variables directory ($@)."
	@mkdir -p $@
	@cp $(FILES_DIR)/ansible/example/group_vars.yml $@/example_group.yml

README.md:
	@cp $(FILES_DIR)/ansible/README.md $(PROJECT_ROOT)
