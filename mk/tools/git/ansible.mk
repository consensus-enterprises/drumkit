ansible_NAME         = Ansible
ansible_RELEASE      ?= v2.8.1
ansible_DOWNLOAD_URL = https://github.com/ansible/ansible.git
ansible_DEPENDENCIES = python3-minimal python3-paramiko python3-pip python3-yaml python3-jinja2 python3-pycurl
ansible_BIN_DIR      = bin
ansible_PARENT       = ansible

ANSIBLE_BOOTSTRAP_SCRIPT = $(BOOTSTRAP_D)/40_ansible.sh
ANSIBLE_SELF_BOOTSTRAP_SCRIPT = $(BOOTSTRAP_D)/40_ansible.mk
$(ANSIBLE_BOOTSTRAP_SCRIPT):
	@echo "Deploying Ansible bootstrap script."
	@echo "export PYTHONPATH=$(SRC_DIR)/ansible/ansible-latest/lib" > $@
$(ANSIBLE_SELF_BOOTSTRAP_SCRIPT):
	@echo "Deploying Ansible self-bootstrap script."
	@echo "export PYTHONPATH=$(SRC_DIR)/ansible/ansible-latest/lib" > $@

ansible: ansible.cfg $(BOOTSTRAP_D) $(ANSIBLE_BOOTSTRAP_SCRIPT) $(ANSIBLE_SELF_BOOTSTRAP_SCRIPT)
ansible.cfg:
	@echo "Deploying Ansible config file."
	@cp $(FILES_DIR)/ansible/ansible.cfg $(PROJECT_ROOT)

clean-ansible: remove-ansible-bootstrap-script
remove-ansible-bootstrap-script:
	@echo "Removing Ansible bootstrap scripts."
	@rm -f $(ANSIBLE_BOOTSTRAP_SCRIPT)
	@rm -f $(ANSIBLE_SELF_BOOTSTRAP_SCRIPT)

# vi:syntax=makefile
