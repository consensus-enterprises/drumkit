ansible-playbook_NAME         = Ansible Playbook
ansible-playbook_RELEASE      = v2.8.1
ansible-playbook_DOWNLOAD_URL = https://github.com/ansible/ansible.git
ansible-playbook_DEPENDENCIES = python3-paramiko python3-pip python3-yaml python3-jinja2 python3-pycurl
ansible-playbook_BIN_DIR      = bin
ansible-playbook_PARENT       = ansible

ifdef tags
    ANSIBLE_TAGS := -t $(tags)
else
    ANSIBLE_TAGS =
endif

ifdef START_AT_TASK
ANSIBLE_START_AT_TASK := --start-at-task="$(START_AT_TASK)"
endif

ANSIBLE_PLAYBOOK_CMD := ansible-playbook $(ANSIBLE_START_AT_TASK) $(ANSIBLE_INVENTORY) $(ANSIBLE_TAGS)

# vi:syntax=makefile
