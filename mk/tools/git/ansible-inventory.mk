ansible-inventory_NAME         = Ansible Inventory
ansible-inventory_RELEASE      = v2.8.1
ansible-inventory_DOWNLOAD_URL = https://github.com/ansible/ansible.git
ansible-inventory_DEPENDENCIES = python-paramiko python-pip python-yaml python-jinja2 python-pycurl
ansible-inventory_BIN_DIR      = bin
ansible-inventory_PARENT       = ansible

.PHONY: inventory

ifdef inventory
    ANSIBLE_INVENTORY = -i $(inventory)
else
    ANSIBLE_INVENTORY =
endif

ANSIBLE_INVENTORY_CMD = ansible-inventory $(ANSIBLE_INVENTORY)

inventory: ## List cloud inventory.
	$(ANSIBLE_INVENTORY_CMD) --list

# vi:syntax=makefile
