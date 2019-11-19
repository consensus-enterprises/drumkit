ansible-playbook_NAME         = Ansible Playbook
ansible-playbook_RELEASE      = v2.8.1
ansible-playbook_DOWNLOAD_URL = https://github.com/ansible/ansible.git
ansible-playbook_DEPENDENCIES = python3-paramiko python3-pip python3-yaml python3-jinja2 python3-pycurl
ansible-playbook_BIN_DIR      = bin
ansible-playbook_PARENT       = ansible

ifdef tags
    ANSIBLE_TAGS := -t $(tags)
else
    ANSIBLE_TAGS =
endif

ifdef start_at_task
ANSIBLE_START_AT_TASK := --start-at-task="$(start_at_task)"
endif

ifdef extra_vars
ANSIBLE_EXTRA_VARS := --extra-vars="$(extra_vars)"
endif

ifdef limit
ANSIBLE_EXTRA_VARS := --limit="$(limit)"
endif

ANSIBLE_PLAYBOOK_CMD := ansible-playbook $(ANSIBLE_LIMIT) $(ANSIBLE_START_AT_TASK) $(ANSIBLE_INVENTORY) $(ANSIBLE_TAGS) $(ANSIBLE_EXTRA_VARS)

# Below are some helpers that are useful for ansible role testing.
# TODO: migrate to a new ansible role project type.

ANSIBLE_TEST_INVENTORY ?= tests/inventory
ANSIBLE_TEST_PLAYBOOK ?= tests/test.yml
ANSIBLE_TEST_CMD      ?= $(ANSIBLE_PLAYBOOK_CMD) $(ANSIBLE_TEST_PLAYBOOK) --connection=local -i $(ANSIBLE_TEST_INVENTORY)

ansible-role-test: ansible-playbook
	@echo "Run the test playbook $(ANSIBLE_TEST_PLAYBOOK)."
	$(ANSIBLE_TEST_CMD)

ansible-role-check: ansible-playbook
	@echo "Run the test playbook $(ANSIBLE_TEST_PLAYBOOK) with --check to predict changes without actually making any."
	$(ANSIBLE_TEST_CMD) --check

ansible-playbook-syntax: ansible-playbook
	@echo "Check the syntax of test playbook $(ANSIBLE_TEST_PLAYBOOK)."
	$(ANSIBLE_PLAYBOOK_CMD) --syntax-check $(ANSIBLE_TEST_PLAYBOOK)

# vi:syntax=makefile
