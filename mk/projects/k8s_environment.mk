SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)k8s_environment/environments.mk

K8S_ENVIRONMENT_DEFAULT_NAME = DEV
K8S_ENVIRONMENT_RESOURCES_DIR =.mk/mk/projects/k8s_environment
K8S_ENVIRONMENT_NAME  ?= $(K8S_ENVIRONMENT_DEFAULT_NAME)
K8S_ENVIRONMENT_TEMPLATE_DIR  = $(K8S_ENVIRONMENT_RESOURCES_DIR)/$(K8S_ENVIRONMENT_DIR)/$(K8S_ENVIRONMENT_DEFAULT_NAME)
K8S_ENVIRONMENT_DIR = build/environments

K8S_ENVIRONMENT_BASE_FILES = \
    $(K8S_ENVIRONMENT_DIR)/base/kustomization.yaml \
    $(K8S_ENVIRONMENT_DIR)/base/storage_data.yaml \
    $(K8S_ENVIRONMENT_DIR)/base/storage_files.yaml

K8S_ENVIRONMENT_TEMPLATE_FILES = \
    $(K8S_ENVIRONMENT_DIR)/$(K8S_ENVIRONMENT_NAME)/kustomization.yaml\
    $(K8S_ENVIRONMENT_DIR)/$(K8S_ENVIRONMENT_NAME)/namespace.yaml

init-k8s-environment: init-k8s-environment-intro
init-k8s-environment: $(K8S_ENVIRONMENT_BASE_FILES)
init-k8s-environment: $(K8S_ENVIRONMENT_TEMPLATE_FILES)
init-k8s-environment: drumkit/mk.d/35_environment_$(K8S_ENVIRONMENT_NAME).mk
init-k8s-environment: ## Initialize configuration and Drumkit targets to create and manage environments on Kubernetes clusters.

init-k8s-environment-intro:
	@$(ECHO) ">>> $(WHITE)Creating '$(K8S_ENVIRONMENT_NAME)' environment.$(RESET) <<<"
	@$(ECHO)

drumkit/mk.d/35_environment_$(K8S_ENVIRONMENT_NAME).mk:
	@$(ECHO) "$(YELLOW)Creating makefile: '$(@F)'.$(RESET)"
	@mkdir -p $(@D)
	@CLUSTER_NAME=$(K8S_CLUSTER_NAME) ENVIRONMENT_NAME=$(K8S_ENVIRONMENT_NAME) ENVIRONMENT_NAME_LC=$(call lc,$(K8S_ENVIRONMENT_NAME)) mustache ENV $(K8S_ENVIRONMENT_RESOURCES_DIR)/drumkit/mk.d/35_environment_$(K8S_ENVIRONMENT_DEFAULT_NAME).mk > $@

$(K8S_ENVIRONMENT_TEMPLATE_FILES):
	@$(ECHO) "$(YELLOW)Creating file: '$(@F)'.$(RESET)"
	@mkdir -p $(@D)
	@CLUSTER_NAME=$(K8S_CLUSTER_NAME) ENVIRONMENT_NAME=$(K8S_ENVIRONMENT_NAME) ENVIRONMENT_NAME_LC=$(call lc,$(K8S_ENVIRONMENT_NAME)) mustache ENV $(K8S_ENVIRONMENT_TEMPLATE_DIR)/$(@F) > $@
$(K8S_ENVIRONMENT_BASE_FILES):
	@$(ECHO) "$(YELLOW)Creating file: '$(@F)'.$(RESET)"
	@mkdir -p $(@D)
	@ENVIRONMENT_NAME=$(K8S_ENVIRONMENT_NAME) ENVIRONMENT_NAME_LC=$(call lc,$(K8S_ENVIRONMENT_NAME)) mustache ENV $(K8S_ENVIRONMENT_RESOURCES_DIR)/$@ > $@
