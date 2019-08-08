# Tasks for initializing full-stack AegirVPS projects.

init-project-aegirvps-intro:
	@echo "Initializing Drumkit AegirVPS project."
# Override default host and group names.
#init-project-aegirvps: host=aegir0
#init-project-aegirvps: group=aegir
init-project-aegirvps: init-project-aegirvps-intro $(INIT_PROJECT_OPENSTACK_DEPENDENCIES) $(INIT_PROJECT_AEGIR_DEPENDENCIES) ## Initialize a project to manage full-stack AegirVPS systems on Openstack. 
	@make -s init-role-aegirvps #host=$(host) group=$(group)
	@echo "Finished initializing Drumkit AegirVPS project."
