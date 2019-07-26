# Tasks for initializing aegir projects.

init-project-aegir-intro:
	@echo "Initializing Drumkit Aegir project."
init-project-aegir: init-project-aegir-intro init-project-ansible roles/consensus.aegir-policy $(MK_D)/20_project_aegir.mk  ## Initialize a project for deploying Aegir with Ansible (application only, no infrastructure management).
	@make -s init-aegir-policy
	@echo "Finished initializing Drumkit Aegir project."

$(MK_D)/20_project_aegir.mk: $(MK_D) 
	@echo 'include roles/consensus.aegir-policy/drumkit/mk.d/*.mk' > $@

roles/consensus.aegir-policy:
	@git submodule add $(CONSENSUS_GIT_URL_BASE)/ansible-roles/ansible-role-aegir-policy $@
