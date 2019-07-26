# Tasks for initializing full-stack AegirVPS projects.

init-project-aegirvps-intro:
	@echo "Initializing Drumkit AegirVPS project."
init-project-aegirvps: init-project-aegirvps-intro init-project-openstack init-project-aegir ## Initialize a project to manage full-stack AegirVPS systems on Openstack. 
	@echo "Finished initializing Drumkit AegirVPS project."

