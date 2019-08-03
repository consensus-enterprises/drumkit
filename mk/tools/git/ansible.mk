ansible_NAME         = Ansible
ansible_RELEASE      ?= v2.8.1
ansible_DOWNLOAD_URL = https://github.com/ansible/ansible.git
ansible_DEPENDENCIES = python-paramiko python-pip python-yaml python-jinja2 python-pycurl
ansible_BIN_DIR      = bin
ansible_PARENT       = ansible

ANSIBLE_BOOTSTRAP_SCRIPT = $(BOOTSTRAP_D)/40_ansible.sh

ansible: ansible.cfg $(BOOTSTRAP_D) $(ANSIBLE_BOOTSTRAP_SCRIPT)
ansible.cfg:
	@cp $(FILES_DIR)/ansible/ansible.cfg $(PROJECT_ROOT)

$(ANSIBLE_BOOTSTRAP_SCRIPT):
	@echo "Deploying Ansible bootstrap script."
	@echo "export PYTHONPATH=.mk/.local/src/ansible/ansible-latest/lib" > $@

clean-ansible: remove-ansible-bootstrap-script
remove-ansible-bootstrap-script:
	@echo "Removing Ansible bootstrap script."
	@rm -f $(ANSIBLE_BOOTSTRAP_SCRIPT)

# vi:syntax=makefile
