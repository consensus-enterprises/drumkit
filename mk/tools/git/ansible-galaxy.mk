ansible-galaxy_NAME         = Ansible Galaxy
ansible-galaxy_RELEASE      ?= $(ansible_RELEASE)
ansible-galaxy_DOWNLOAD_URL ?= $(ansible_DOWNLOAD_URL)
ansible-galaxy_DEPENDENCIES ?= $(ansible_DEPENDENCIES)
ansible-galaxy_BIN_DIR      ?= $(ansible_BIN_DIR)
ansible-galaxy_PARENT       = ansible

ANSIBLE_REQUIREMENTS       ?= roles/requirements.yml
ANSIBLE_ROLES_PATH         ?= roles
ANSIBLE_GALAXY_CMD:=ansible-galaxy install -i -r $(ANSIBLE_REQUIREMENTS) -p $(ANSIBLE_ROLES_PATH)

$(ANSIBLE_REQUIREMENTS):
	@mkdir -p $(dir $(ANSIBLE_REQUIREMENTS))
	echo "---" >> $(ANSIBLE_REQUIREMENTS)

$(ANSIBLE_ROLES_PATH):
	@mkdir -p $(ANSIBLE_ROLES_PATH)

ansible-roles: ansible-galaxy $(ANSIBLE_REQUIREMENTS) $(ANSIBLE_ROLES_PATH)
	$(ANSIBLE_GALAXY_CMD)

ansible-roles-force: ansible-galaxy $(ANSIBLE_REQUIREMENTS) $(ANSIBLE_ROLES_PATH)
	$(ANSIBLE_GALAXY_CMD) --force

ansible-roles-quiet: ansible-galaxy $(ANSIBLE_REQUIREMENTS) $(ANSIBLE_ROLES_PATH)
	$(ANSIBLE_GALAXY_CMD) > /dev/null

# vi:syntax=makefile
