SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)k8s_environment/environments.mk

K8S_ENVIRONMENT_DEFAULT_NAME = DEV
K8S_ENVIRONMENT_RESOURCES_DIR =.mk/mk/projects/k8s_environment
K8S_ENVIRONMENT_NAME  ?= $(K8S_ENVIRONMENT_DEFAULT_NAME)
K8S_ENVIRONMENT_TEMPLATE_DIR  = $(K8S_ENVIRONMENT_RESOURCES_DIR)/$(K8S_ENVIRONMENT_DIR)/$(K8S_ENVIRONMENT_DEFAULT_NAME)
K8S_ENVIRONMENT_DIR = build/environments
K8S_ENVIRONMENT_DRUMKIT_PREFIX= 35_environment

K8S_ENVIRONMENT_TEMPLATE_VARS = \
    PROJECT_NAME=$(PROJECT_NAME) \
    ENVIRONMENT_NAME=$(K8S_ENVIRONMENT_NAME) \
    ENVIRONMENT_NAME_LC=$(call lc,$(K8S_ENVIRONMENT_NAME)) \
    CLUSTER_NAME=$(K8S_CLUSTER_NAME)

K8S_ENVIRONMENT_FILES = \
    $(K8S_ENVIRONMENT_DIR)/base/kustomization.yaml \
    $(K8S_ENVIRONMENT_DIR)/base/storage_data.yaml \
    $(K8S_ENVIRONMENT_DIR)/base/storage_files.yaml

K8S_ENVIRONMENT_TEMPLATE_FILES = \
    $(K8S_ENVIRONMENT_DIR)/$(K8S_ENVIRONMENT_NAME)/kustomization.yaml\
    $(K8S_ENVIRONMENT_DIR)/$(K8S_ENVIRONMENT_NAME)/namespace.yaml

K8S_ENVIRONMENT_DRUMKIT_FILES= \
    drumkit/mk.d/$(K8S_ENVIRONMENT_DRUMKIT_PREFIX)_$(K8S_ENVIRONMENT_NAME).mk

init-k8s-environment: .init-k8s-environment-intro
init-k8s-environment: $(K8S_ENVIRONMENT_FILES)
init-k8s-environment: $(K8S_ENVIRONMENT_TEMPLATE_FILES)
init-k8s-environment: $(K8S_ENVIRONMENT_DRUMKIT_FILES)
init-k8s-environment: ## Initialize configuration and Drumkit targets to create and manage environments on Kubernetes clusters.

.init-k8s-environment-intro:
	$(ECHO) ">>> $(WHITE)Creating '$(K8S_ENVIRONMENT_NAME)' environment.$(RESET) <<<"
	$(ECHO)
	$(ECHO) "You should update the documentation in the following files to reflect"
	$(ECHO) "the intended use of this environment:"
	$(ECHO) $(K8S_ENVIRONMENT_DRUMKIT_FILES)
	$(ECHO)
	$(ECHO) "If you need to add additional storage or otherwise customize the environment,"
	$(ECHO) "take a look at the files in 'build/environments'."
	$(ECHO)

$(K8S_ENVIRONMENT_TEMPLATE_FILES):
	@$(make) .template \
        TEMPLATE_VARS=$(K8S_ENVIRONMENT_TEMPLATE_VARS) \
        TEMPLATE_SOURCE=$(K8S_ENVIRONMENT_TEMPLATE_DIR)/$(@F) \
        TEMPLATE_TARGETDIR=$(@D) \
        TEMPLATE_TARGET=$@

$(K8S_ENVIRONMENT_FILES):
	@$(make) .template \
        TEMPLATE_VARS=$(K8S_ENVIRONMENT_TEMPLATE_VARS) \
        TEMPLATE_SOURCE=$(K8S_ENVIRONMENT_RESOURCES_DIR)/$@ \
        TEMPLATE_TARGETDIR=$(@D) \
        TEMPLATE_TARGET=$@

$(K8S_ENVIRONMENT_DRUMKIT_FILES):
	@$(make) .template \
        TEMPLATE_VARS=$(K8S_ENVIRONMENT_TEMPLATE_VARS) \
        TEMPLATE_SOURCE=$(K8S_ENVIRONMENT_RESOURCES_DIR)/$(@D)/$(K8S_ENVIRONMENT_DRUMKIT_PREFIX)_$(K8S_ENVIRONMENT_DEFAULT_NAME).mk \
        TEMPLATE_TARGETDIR=$(@D) \
        TEMPLATE_TARGET=$@

