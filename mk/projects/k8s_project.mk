SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)k8s_project/projects.mk

K8S_PROJECT_TEMPLATE_VARS = \
    PROJECT_NAME=$(PROJECT_NAME) \

K8S_PROJECT_RESOURCES_DIR =.mk/mk/projects/k8s_project

K8S_PROJECT_DRUMKIT_FILES = \
    drumkit/mk.d/20_project.mk \
    drumkit/mk.d/20_project_drupal.mk

$(K8S_PROJECT_DRUMKIT_FILES):
	@$(make) .template \
        TEMPLATE_VARS=$(K8S_PROJECT_TEMPLATE_VARS) \
        TEMPLATE_SOURCE=$(K8S_PROJECT_RESOURCES_DIR)/$@ \
        TEMPLATE_TARGETDIR=$(@D) \
        TEMPLATE_TARGET=$@

init-k8s-project: .checkvar-PROJECT_NAME
init-k8s-project: .init-k8s-project-intro
init-k8s-project: $(K8S_PROJECT_DRUMKIT_FILES)
init-k8s-project: ## Initialize Drumkit targets to manage a Drupal project on Kubernetes.

.init-k8s-project-intro:
	$(ECHO) ">>> $(WHITE)Creating project makefiles.$(RESET) <<<"
	$(ECHO)

.clean-k8s-project-intro:
	$(ECHO) ">>> $(WHITE)Cleaning up project makefiles.$(RESET) <<<"
	$(ECHO)
clean-k8s-project: .clean-k8s-project-intro
clean-k8s-project: ## Remove configuration for a Kubernetes project.
	@$(make) .remove \
        FILES_TO_REMOVE="$(K8S_PROJECT_DRUMKIT_FILES)"


