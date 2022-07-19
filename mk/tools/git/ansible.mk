ansible_NAME         = Ansible
ansible_RELEASE      ?= v2.10.8
ansible_DOWNLOAD_URL = https://github.com/ansible/ansible.git
ansible_DEPENDENCIES = python3-minimal python3-paramiko python3-pip python3-yaml python3-jinja2 python3-pycurl
ansible_BIN_DIR      = bin
ansible_PARENT       = ansible

ansible_installed = $(shell test -f "$(BIN_DIR)/ansible")

ansible:
ifneq ($(ansible_installed),)
	$(MAKE-QUIET) ansible-real
else
	$(ECHO) "Ansible already installed."
endif

ansible-real: ansible.cfg $(BOOTSTRAP_D) $(BOOTSTRAP_D)/40_ansible.sh
ansible.cfg:
	@echo "Deploying Ansible config file."
	@cp $(FILES_DIR)/ansible/ansible.cfg $(PROJECT_ROOT)

# vi:syntax=makefile
