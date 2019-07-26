# Tasks for initializing ansible projects.

init-project-ansible-intro:
	@echo "Initializing Drumkit Ansible project."
init-project-ansible-real: init-project-ansible-intro roles/consensus.utils roles/consensus.admin-users ansible.cfg playbooks/groups/example-group.yml playbooks/hosts/example-host.yml inventory/example-inventory.yml README.md
	@echo "Finished initializing Drumkit Ansible project."
init-project-ansible: init-project-ansible-real ## Initialize a project for working with Ansible.

roles/consensus.utils:
	@git submodule add $(CONSENSUS_GIT_URL_BASE)/ansible-roles/ansible-role-utils roles/consensus.utils

roles/consensus.admin-users:
	@git submodule add $(CONSENSUS_GIT_URL_BASE)/ansible-roles/ansible-role-admin-users roles/consensus.admin-users

playbooks/hosts/example-host.yml:
	@mkdir -p $(PROJECT_ROOT)/playbooks/hosts
	@cp $(FILES_DIR)/ansible/example-host.yml $(PROJECT_ROOT)/playbooks/hosts

playbooks/groups/example-group.yml:
	@mkdir -p $(PROJECT_ROOT)/playbooks/groups
	@cp $(FILES_DIR)/ansible/example-group.yml $(PROJECT_ROOT)/playbooks/groups

inventory/example-inventory.yml:
	@mkdir -p $(PROJECT_ROOT)/inventory
	@cp $(FILES_DIR)/ansible/example-inventory.yml $(PROJECT_ROOT)/inventory

README.md:
	@cp $(FILES_DIR)/ansible/README.md $(PROJECT_ROOT)
