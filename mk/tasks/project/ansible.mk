# Tasks for initializing ansible projects.

HOSTS_PLAYBOOK_DIR=$(PROJECT_ROOT)/playbooks/hosts
GROUPS_PLAYBOOK_DIR=$(PROJECT_ROOT)/playbooks/groups
INVENTORY_DIR=$(PROJECT_ROOT)/inventory

init-project-ansible-intro:
	@echo "Initializing Drumkit Ansible project."
init-project-ansible: init-project-ansible-intro roles/consensus.utils ansible.cfg $(HOSTS_PLAYBOOK_DIR) $(GROUPS_PLAYBOOK_DIR) $(INVENTORY_DIR) README.md ## Initialize a project for working with Ansible.
	@echo "Finished initializing Drumkit Ansible project."

roles/consensus.utils:
	@git submodule add $(CONSENSUS_GIT_URL_BASE)/ansible-roles/ansible-role-utils $@

$(HOSTS_PLAYBOOK_DIR):
	@mkdir -p $@
	@cp $(FILES_DIR)/ansible/example-host.yml $@

$(GROUPS_PLAYBOOK_DIR):
	@mkdir -p $@
	@cp $(FILES_DIR)/ansible/example-group.yml $@

$(INVENTORY_DIR):
	@mkdir -p $@
	@cp $(FILES_DIR)/ansible/example-inventory.yml $@

README.md:
	@cp $(FILES_DIR)/ansible/README.md $(PROJECT_ROOT)
