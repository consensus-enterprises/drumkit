init-project-ansible-role-intro:
	@echo "Initializing Drumkit Ansible role '$(role)'."
init-project-ansible-role: init-project-ansible-role-intro ansible-galaxy init-behat setup-ansible-role ## Initialize a project for developing Ansible roles.

setup-ansible-role: ansible-galaxy behat.yml
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

# TODO: Consider setting roles_path in ansible.cfg instead of the symlink trick for tests, 
# cf. https://github.com/cjsteel/galaxy-role-skeleton/blob/master/skeleton/ansible.cfg 

# TODO: Drop all ansible role test caching in favour of self-bootstrapping Drumkit cleanly.
# Commits with caching stuff to be removed:
# 34d4a7704975bbf8368ff32cf3b9c0e78b4231d8
# 24276da1d6376134b42a27078e8796a2483c08a6

# Below is a helpful fixture for testing ansible role project functionality.

ANSIBLE_ROLE_TEST_CACHE_DIR=~/.drumkit/ansible-role-test-cache

$(ANSIBLE_ROLE_TEST_CACHE_DIR):
	@echo "Building Ansible test cache in $(ANSIBLE_ROLE_TEST_CACHE_DIR)."
	@mkdir -p $(ANSIBLE_ROLE_TEST_CACHE_DIR)
	@cp -r  $(MK_DIR) $(ANSIBLE_ROLE_TEST_CACHE_DIR)/.mk
	@cd $(ANSIBLE_ROLE_TEST_CACHE_DIR) && echo 'include .mk/GNUmakefile' > Makefile 
	@cd $(ANSIBLE_ROLE_TEST_CACHE_DIR) && make -s init-drumkit ansible-suite behat

ansible-role-test-cache: $(ANSIBLE_ROLE_TEST_CACHE_DIR)

link-ansible-role-test-cache: ansible-role-test-cache
	@readlink .mk/.local eq $(ANSIBLE_ROLE_TEST_CACHE_DIR)/.mk/.local || (rm -rf .mk/.local && ln -s $(ANSIBLE_ROLE_TEST_CACHE_DIR)/.mk/.local .mk/.local)
	@readlink drumkit eq $(ANSIBLE_ROLE_TEST_CACHE_DIR)/drumkit || (rm -rf drumkit && ln -s $(ANSIBLE_ROLE_TEST_CACHE_DIR)/drumkit drumkit)

clean-ansible-role-test-cache:
	@rm -rf $(ANSIBLE_ROLE_TEST_CACHE_DIR)
