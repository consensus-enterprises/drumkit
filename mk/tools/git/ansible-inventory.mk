ansible-inventory_NAME         = Ansible Inventory
ansible-inventory_RELEASE      ?= $(ansible_RELEASE)
ansible-inventory_DOWNLOAD_URL ?= $(ansible_DOWNLOAD_URL)
ansible-inventory_DEPENDENCIES ?= $(ansible_DEPENDENCIES)
ansible-inventory_BIN_DIR      ?= $(ansible_BIN_DIR)
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
