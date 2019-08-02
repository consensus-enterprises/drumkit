SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

.PHONY: inventory

ifdef inventory
    ANSIBLE_INVENTORY = -i $(inventory)
else
    ANSIBLE_INVENTORY =
endif

ANSIBLE_INVENTORY_CMD = ansible-inventory $(ANSIBLE_INVENTORY)

inventory: ## List cloud inventory.
	$(ANSIBLE_INVENTORY_CMD) --list

include $(SELF_DIR)ansible/*.mk
