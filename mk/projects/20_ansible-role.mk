init-project-ansible-role-intro:
	@echo "Initializing Drumkit Ansible role '$(role)'."
init-project-ansible-role: init-project-ansible-role-intro ansible-galaxy init-behat behat.yml ## Initialize a project for developing Ansible roles.
	$(MAKE) init-project-ansible-role-real
# Call into a submake so we get re-bootstrapped
init-project-ansible-role-real:
	@echo "Using ansible-galaxy to generate role files."
	@ansible-galaxy init $(role)
	@echo "Deploying generated role files to current directory and cleaning up."
	@mv $(role)/* .
	@rm -rf $(role)
	@echo "Customizing tests."
	@cd tests && ln -s .. $(role)
	@rm tests/test.yml
	@jinja2 -D role=$(role) -o tests/test.yml $(FILES_DIR)/ansible-role/test.yml.j2
	@mkdir -p features
	@cp $(FILES_DIR)/ansible-role/ansible-role-example.feature features/
	@echo "Finished initializing Drumkit Ansible role project."

# Below are some helpers that are useful for ansible role testing.

ANSIBLE_TEST_INVENTORY ?= tests/inventory
ANSIBLE_TEST_PLAYBOOK  ?= tests/test.yml
ANSIBLE_TEST_CMD       ?= $(ANSIBLE_PLAYBOOK_CMD) $(ANSIBLE_TEST_PLAYBOOK) --connection=local -i $(ANSIBLE_TEST_INVENTORY)

ansible-role-test: ansible-playbook
	@echo "Run the test playbook $(ANSIBLE_TEST_PLAYBOOK)."
	$(ANSIBLE_TEST_CMD)

ansible-role-check: ansible-playbook
	@echo "Run the test playbook $(ANSIBLE_TEST_PLAYBOOK) with --check to predict changes without actually making any."
	$(ANSIBLE_TEST_CMD) --check

ansible-playbook-syntax: ansible-playbook
	@echo "Check the syntax of test playbook $(ANSIBLE_TEST_PLAYBOOK)."
	$(ANSIBLE_PLAYBOOK_CMD) --syntax-check $(ANSIBLE_TEST_PLAYBOOK)

# TODO: Consider setting roles_path in ansible.cfg instead of the symlink trick for tests, 
# cf. https://github.com/cjsteel/galaxy-role-skeleton/blob/master/skeleton/ansible.cfg 

