SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

# Tasks for initializing ansible projects.
ANSIBLE_PLAYBOOKS_DIR=playbooks

include $(SELF_DIR)ansible/*.mk

init-project-ansible-intro:
	@echo "Initializing Drumkit Ansible project."
init-project-ansible: init-project-ansible-intro roles/consensus.utils ansible.cfg ansible-add-host ansible-add-group README.md ##@projects Initialize a project for working with Ansible.
	@echo "Finished initializing Drumkit Ansible project."

ansible-clean-examples:
	make -s ansible-clean-host host=example-host
	make -s ansible-clean-group group=example_group

roles/consensus.utils:
	@git submodule add $(CONSENSUS_GIT_URL_BASE)/ansible-roles/ansible-role-utils $@

README.md:
	@cp $(FILES_DIR)/ansible/README.md $(PROJECT_ROOT)
