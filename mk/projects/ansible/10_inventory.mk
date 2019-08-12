environment ?= default
ipaddress   ?= IP_ADDRESS_GOES_HERE

ANSIBLE_INVENTORY_FILENAME             ?= $(environment).yml
ANSIBLE_INVENTORY_DIR                  := $(PROJECT_ROOT)/inventory
ANSIBLE_STATIC_INVENTORY_FILE_TEMPLATE := $(FILES_DIR)/ansible/templates/inventory.yml.j2

ansible-add-static-inventory: $(ANSIBLE_INVENTORY_DIR) $(ANSIBLE_INVENTORY_DIR)/$(ANSIBLE_INVENTORY_FILENAME) ## [host,group,ipaddress,environment] Generate Ansible static inventory file with the given host, group and IP address for the given environment.

ansible-clean-static-inventory:
	@echo "Cleaning up Ansible static inventory file."
	@rm -f $(ANSIBLE_INVENTORY_DIR)/$(ANSIBLE_INVENTORY_FILENAME)

$(ANSIBLE_INVENTORY_DIR):
	@echo "Initializing directory '$@'."
	@mkdir -p $@

$(ANSIBLE_INVENTORY_DIR)/$(ANSIBLE_INVENTORY_FILENAME):
	@echo "Generating Ansible static inventory file ($@)."
	@jinja2 -D host=$(host) -D group=$(group) -D ipaddress=$(ipaddress) -o $@ $(ANSIBLE_STATIC_INVENTORY_FILE_TEMPLATE)
ifeq ($(ipaddress), IP_ADDRESS_GOES_HERE)
	@echo 'Next, specify an IP address for $(host) in inventory/$(ANSIBLE_INVENTORY_FILENAME)'
endif
