# Tasks for initializing ansible projects.
ANSIBLE_PLAYBOOKS_DIR=$(PROJECT_ROOT)/playbooks
ANSIBLE_HOSTS_PLAYBOOK_DIR=$(ANSIBLE_PLAYBOOKS_DIR)/hosts
ANSIBLE_GROUPS_PLAYBOOK_DIR=$(ANSIBLE_PLAYBOOKS_DIR)/groups
ANSIBLE_INVENTORY_DIR=$(PROJECT_ROOT)/inventory
ANSIBLE_HOST_VARS_DIR=$(ANSIBLE_INVENTORY_DIR)/host_vars
ANSIBLE_GROUP_VARS_DIR=$(ANSIBLE_INVENTORY_DIR)/group_vars

host:=example-host
group:=example_group
ipaddress:=IP_ADDRESS_GOES_HERE

init-project-ansible-intro:
	@echo "Initializing Drumkit Ansible project."
init-project-ansible: init-project-ansible-intro ansible roles/consensus.utils ansible.cfg generate-ansible-config README.md ## Initialize a project for working with Ansible.
	@echo "Finished initializing Drumkit Ansible project."

generate-ansible-config-intro:
	@echo "Generating Ansible config files."
generate-ansible-config: generate-ansible-config-intro $(ANSIBLE_HOSTS_PLAYBOOK_DIR)/$(host).yml $(ANSIBLE_GROUPS_PLAYBOOK_DIR)/$(group).yml $(ANSIBLE_INVENTORY_DIR)/inventory.yml $(ANSIBLE_HOST_VARS_DIR)/$(host).yml $(ANSIBLE_GROUP_VARS_DIR)/$(group).yml
	@echo "Finished generating Ansible config files."

roles/consensus.utils:
	@git submodule add $(CONSENSUS_GIT_URL_BASE)/ansible-roles/ansible-role-utils $@

$(ANSIBLE_HOSTS_PLAYBOOK_DIR) $(ANSIBLE_GROUPS_PLAYBOOK_DIR) $(ANSIBLE_INVENTORY_DIR) $(ANSIBLE_HOST_VARS_DIR) $(ANSIBLE_GROUP_VARS_DIR):
	@echo "Initializing directory '$@'."
	@mkdir -p $@

$(ANSIBLE_HOSTS_PLAYBOOK_DIR)/$(host).yml: $(ANSIBLE_HOSTS_PLAYBOOK_DIR)
	@echo "Generating host playbook ($@)."
	@jinja2 -D host=$(host) -D group=$(group) -o $@ $(FILES_DIR)/ansible/templates/host-playbook.yml

$(ANSIBLE_GROUPS_PLAYBOOK_DIR)/$(group).yml: $(ANSIBLE_GROUPS_PLAYBOOK_DIR)
	@echo "Generating group playbook ($@)."
	@jinja2 -D host=$(host) -D group=$(group) -o $@ $(FILES_DIR)/ansible/templates/group-playbook.yml

$(ANSIBLE_INVENTORY_DIR)/inventory.yml: $(ANSIBLE_INVENTORY_DIR)
	@echo "Generating ansible static inventory file ($@)."
	@jinja2 -D host=$(host) -D group=$(group) -D ipaddress=$(ipaddress) -o $@ $(FILES_DIR)/ansible/templates/inventory.yml

$(ANSIBLE_HOST_VARS_DIR)/$(host).yml: $(ANSIBLE_HOST_VARS_DIR)
	@echo "Generating Ansible host variables file ($@)."
	@jinja2 -D host=$(host) -D group=$(group) -o $@ $(FILES_DIR)/ansible/templates/host-vars.yml

$(ANSIBLE_GROUP_VARS_DIR)/$(group).yml: $(ANSIBLE_GROUP_VARS_DIR)
	@echo "Initializing Ansible group variables file ($@)."
	@jinja2 -D host=$(host) -D group=$(group) -o $@ $(FILES_DIR)/ansible/templates/group-vars.yml

README.md:
	@cp $(FILES_DIR)/ansible/README.md $(PROJECT_ROOT)
