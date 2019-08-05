# Tasks for initializing full-stack AegirVPS projects.

init-project-aegirvps-intro:
	@echo "Initializing Drumkit AegirVPS project."
# Override default host and group names.
init-project-aegirvps: group=aegir
init-project-aegirvps: host=aegir0
# TODO: override group and host templates
#init-project-aegirvps: group_template=...
#init-project-aegirvps: host_template=...
init-project-aegirvps: init-project-aegirvps-intro init-project-openstack init-project-aegir ## Initialize a project to manage full-stack AegirVPS systems on Openstack. 
	@echo "Finished initializing Drumkit AegirVPS project."

