SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

.PHONY: inventory

ifdef inventory
    ANSIBLE_INVENTORY = -i $(inventory)
else
    ANSIBLE_INVENTORY =
endif

ifdef tags
    ANSIBLE_TAGS = -t $(tags)
else
    ANSIBLE_TAGS =
endif

ANSIBLE_PLAYBOOK_CMD = ansible-playbook $(ANSIBLE_TAGS) $(ANSIBLE_INVENTORY)
ANSIBLE_INVENTORY_CMD = ansible-inventory $(ANSIBLE_INVENTORY)

inventory: ## List cloud inventory.
	$(ANSIBLE_INVENTORY_CMD) --list

include $(SELF_DIR)ansible/*.mk
