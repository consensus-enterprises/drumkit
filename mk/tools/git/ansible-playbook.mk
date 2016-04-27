ansible-playbook_NAME         = Ansible Playbook
ansible-playbook_RELEASE      = v2.0.1.0-1
ansible-playbook_DOWNLOAD_URL = https://github.com/ansible/ansible.git
ansible-playbook_DEPENDENCIES = python-paramiko python-pip python-yaml python-jinja2 python-pycurl
ansible-playbook_BIN_DIR      = bin
ansible-playbook_PARENT       = ansible

ANSIBLE_PLAYBOOK  ?= tests/playbook.yml
ANSIBLE_INVENTORY ?= tests/inventory

ansible-playbook-test: ansible-roles
	@echo "Check the role/playbook's syntax."
	ansible-playbook -i $(ANSIBLE_INVENTORY) $(ANSIBLE_PLAYBOOK) --syntax-check
	@echo "Run the role/playbook with ansible-playbook."
	ansible-playbook -i $(ANSIBLE_INVENTORY) $(ANSIBLE_PLAYBOOK) --connection=local --sudo
	@echo "Run the role/playbook again, checking to make sure it's idempotent."
	ansible-playbook -i $(ANSIBLE_INVENTORY) $(ANSIBLE_PLAYBOOK) --connection=local --sudo \
  | grep -q 'changed=0.*failed=0' \
  && (echo 'Idempotence test: pass' && exit 0) \
  || (echo 'Idempotence test: fail' && exit 1)

# vi:syntax=makefile
