ansible-galaxy_NAME         = Ansible Galaxy
ansible-galaxy_RELEASE      = v2.0.1.0-1
ansible-galaxy_DOWNLOAD_URL = https://github.com/ansible/ansible.git
ansible-galaxy_DEPENDENCIES = python-paramiko python-pip python-yaml python-jinja2 python-pycurl
ansible-galaxy_BIN_DIR      = bin
ansible-galaxy_PARENT       = ansible

ansible-roles:
	ansible-galaxy install -r ansible/requirements.yml

ansible-roles-quiet:
	@ansible-galaxy install -r ansible/requirements.yml > /dev/null

# vi:syntax=makefile
