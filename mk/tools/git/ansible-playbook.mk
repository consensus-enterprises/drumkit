ansible-playbook_NAME         = Ansible Playbook
ansible-playbook_RELEASE      = v2.8.1
ansible-playbook_DOWNLOAD_URL = https://github.com/ansible/ansible.git
ansible-playbook_DEPENDENCIES = python-paramiko python-pip python-yaml python-jinja2 python-pycurl
ansible-playbook_BIN_DIR      = bin
ansible-playbook_PARENT       = ansible

ifdef tags
    ANSIBLE_TAGS := -t $(tags)
else
    ANSIBLE_TAGS =
endif

ifdef START_AT_TASK
ANSIBLE_START_AT_TASK := --start-at-task="$(START_AT_TASK)"
endif

ANSIBLE_PLAYBOOK_CMD := ansible-playbook $(ANSIBLE_START_AT_TASK) $(ANSIBLE_INVENTORY) $(ANSIBLE_TAGS)

# Below are helpers for development and testing of Ansible roles.
ifdef ANSIBLE_ROLE_NAME

ANSIBLE_TEST_PLAYBOOK ?= tests/playbook.yml

ansible-playbook-test-idempotence ansible-playbook-test: inventory=tests/inventory
ansible-playbook-test-idempotence: ansible-playbook ansible-playbook-test
	@echo "Run the role/playbook again, checking to make sure it's idempotent."
	$(ANSIBLE_PLAYBOOK_CMD) --connection=local --sudo --extra-vars "$(ANSIBLE_EXTRA_VARS)" $(ANSIBLE_TEST_PLAYBOOK) \
  | grep -q 'changed=0.*failed=0' \
  && (echo 'Idempotence test: pass' && exit 0) \
  || (echo 'Idempotence test: fail' && exit 1)

ansible-playbook-test: ansible-playbook ansible-roles $(ANSIBLE_ROLES_PATH)/$(ANSIBLE_ROLE_NAME)
	@echo "Check the role/playbook's syntax."
	$(ANSIBLE_PLAYBOOK_CMD) --syntax-check $(ANSIBLE_TEST_PLAYBOOK)
	@echo "Run the role/playbook with ansible-playbook."
	$(ANSIBLE_PLAYBOOK_CMD) --connection=local --sudo --extra-vars "$(ANSIBLE_EXTRA_VARS)" $(ANSIBLE_TEST_PLAYBOOK)

$(ANSIBLE_ROLES_PATH)/$(ANSIBLE_ROLE_NAME): $(ANSIBLE_ROLES_PATH)
	@echo "Creating symlink to include this role for tests."
	rm -f $(ANSIBLE_ROLES_PATH)/$(ANSIBLE_ROLE_NAME)
	cd $(ANSIBLE_ROLES_PATH) && \
  ln -f -s ../.. $(ANSIBLE_ROLE_NAME)

endif

# vi:syntax=makefile
