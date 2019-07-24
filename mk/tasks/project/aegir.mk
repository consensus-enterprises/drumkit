# Tasks for initializing aegir projects.

CONSENSUS_GIT_URL_BASE := https://gitlab.com/consensus.enterprises
ROLE_NAME = consensus.aegir-policy

init-project-aegir-intro:
	@echo "Initializing Drumkit Aegir project."
init-project-aegir: init-project-aegir-intro $(MK_D) roles/$(ROLE_NAME) $(MK_D)/$(ROLE_NAME).mk
	@make -s init-aegir-policy
	@echo "Finished initializing Drumkit Aegir project."

$(MK_D)/$(ROLE_NAME).mk:
	@echo 'include roles/$(ROLE_NAME)/drumkit/mk.d/*.mk' > $@

roles/$(ROLE_NAME):
	@git submodule add $(CONSENSUS_GIT_URL_BASE)/ansible-roles/ansible-role-aegir-policy roles/$(ROLE_NAME)
