ansible_NAME         = Ansible
ansible_RELEASE      ?= v2.17.5
ansible_DOWNLOAD_URL ?= https://github.com/ansible/ansible.git
ansible_DEPENDENCIES ?= python3-minimal python3-paramiko python3-pip python3-yaml python3-jinja2 python3-pycurl
ansible_BIN_DIR      ?= bin
ansible_PARENT       = ansible

ansible_installed = $(shell test -f "$(BIN_DIR)/ansible")

ansible:
ifneq ($(ansible_installed),)
	$(MAKE-QUIET) ansible-real
else
	$(ECHO) "Ansible already installed."
endif

ansible-real: ansible.cfg $(BOOTSTRAP_D) $(BOOTSTRAP_D)/40_ansible.sh ansible-all
ansible.cfg:
	@echo "Deploying Ansible config file."
	@cp $(FILES_DIR)/ansible/ansible.cfg $(PROJECT_ROOT)

ansible-all: ansible-config ansible-connection ansible-console ansible-doc ansible-galaxy ansible-inventory ansible-playbook ansible-pull ansible-test ansible-vault

# vi:syntax=makefile
