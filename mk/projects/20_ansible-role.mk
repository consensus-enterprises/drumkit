init-project-ansible-role-intro:
	@echo "Initializing Drumkit Ansible role '$(role)'."
init-project-ansible-role: init-project-ansible-role-intro ansible-galaxy init-behat setup-ansible-role ## Initialize a project for developing Ansible roles.

setup-ansible-role: behat.yml
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


