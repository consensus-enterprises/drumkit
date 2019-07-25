# Tasks for initializing aegir projects.

init-project-aegir-intro:
	@echo "Initializing Drumkit Aegir project."
init-project-aegir-real: init-project-aegir-intro $(MK_D) roles/consensus.aegir-policy $(MK_D)/consensus.aegir-policy.mk playbooks/groups/example-aegir-policy-group.yml
	@make -s init-aegir-policy
	@echo "Finished initializing Drumkit Aegir project."

init-project-aegir: init-project-aegir-real ## Initialize a project for deploying Aegir with Ansible (application only, no infrastructure management).

$(MK_D)/consensus.aegir-policy.mk:
	@echo 'include roles/consensus.aegir-policy/drumkit/mk.d/*.mk' > $@

roles/consensus.aegir-policy:
	@git submodule add $(CONSENSUS_GIT_URL_BASE)/ansible-roles/ansible-role-aegir-policy roles/consensus.aegir-policy

playbooks/groups/example-aegir-policy-group.yml:
	@mkdir -p $(PROJECT_ROOT)/playbooks/groups
	@cp $(FILES_DIR)/aegir-policy/example-aegir-policy-group.yml $(PROJECT_ROOT)/playbooks/groups
