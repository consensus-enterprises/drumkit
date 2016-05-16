ansible_NAME         = Ansible
ansible_RELEASE      = v2.0.2.0-1
ansible_DOWNLOAD_URL = https://github.com/ansible/ansible.git
ansible_DEPENDENCIES = python-paramiko python-pip python-yaml python-jinja2 python-pycurl
ansible_BIN_DIR      = bin
ansible_PARENT       = ansible
ansible_COMMAND      = . hacking/env-setup

ansible: ansible.cfg
ansible.cfg:
	@ln -s .mk/files/ansible/ansible.cfg .

# vi:syntax=makefile
