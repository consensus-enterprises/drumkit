ANSIBLE_INVENTORY_DIR=$(PROJECT_ROOT)/inventory
ANSIBLE_STATIC_INVENTORY_FILE_TEMPLATE=$(FILES_DIR)/ansible/templates/inventory.yml.j2

ipaddress:=IP_ADDRESS_GOES_HERE

ansible-add-static-inventory: $(ANSIBLE_INVENTORY_DIR)/inventory.yml

ansible-clean-static-inventory:
	@echo "Cleaning up Ansible static inventory file."
	@rm -f $(ANSIBLE_INVENTORY_DIR)/inventory.yml

$(ANSIBLE_INVENTORY_DIR):
	@echo "Initializing directory '$@'."
	@mkdir -p $@

$(ANSIBLE_INVENTORY_DIR)/inventory.yml: $(ANSIBLE_INVENTORY_DIR)
	@echo "Generating Ansible static inventory file ($@)."
	@jinja2 -D host=$(host) -D group=$(group) -D ipaddress=$(ipaddress) -o $@ $(ANSIBLE_STATIC_INVENTORY_FILE_TEMPLATE)
ifeq ($(ipaddress), IP_ADDRESS_GOES_HERE)
	@echo 'Next, specify an IP address for $(host) in inventory/inventory.yml'
endif
