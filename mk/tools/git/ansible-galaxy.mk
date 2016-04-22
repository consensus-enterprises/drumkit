ansible-galaxy_NAME         = Ansible Galaxy
ansible-galaxy_RELEASE      = v2.0.1.0-1
ansible-galaxy_DOWNLOAD_URL = https://github.com/ansible/ansible.git
ansible-galaxy_DEPENDENCIES = python-paramiko python-pip python-yaml python-jinja2 python-pycurl
ansible-galaxy_BIN_DIR      = bin
ansible-galaxy_PARENT       = ansible

ANSIBLE_REQUIREMENTS       ?= roles/requirements.yml

$(ANSIBLE_REQUIREMENTS):
	@mkdir -p $(dir $(ANSIBLE_REQUIREMENTS))
	echo "---" >> $(ANSIBLE_REQUIREMENTS)

ansible-roles: $(ANSIBLE_REQUIREMENTS)
	ansible-galaxy install -i -r $(ANSIBLE_REQUIREMENTS)

ansible-roles-quiet: $(ANSIBLE_REQUIREMENTS)
	@ansible-galaxy install -i -r $(ANSIBLE_REQUIREMENTS) > /dev/null

# vi:syntax=makefile
