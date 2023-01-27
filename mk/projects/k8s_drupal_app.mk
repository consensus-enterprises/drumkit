SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)k8s_drupal_app/drupal-apps.mk

K8S_DRUPAL_APP_RESOURCES_DIR =.mk/mk/projects/k8s_drupal_app
K8S_DRUPAL_APP_TEMPLATE_DIR  = $(K8S_DRUPAL_APP_RESOURCES_DIR)/$(K8S_DRUPAL_APP_DIR)/$(K8S_ENVIRONMENT_DEFAULT_NAME)
K8S_ENVIRONMENT_NAME := DEV
K8S_DRUPAL_APP_DIR = build/app

K8S_DRUPAL_APP_BASE_FILES = \
    $(K8S_DRUPAL_APP_DIR)/base/app-variables.yaml \
    $(K8S_DRUPAL_APP_DIR)/base/component-drupal.yaml \
    $(K8S_DRUPAL_APP_DIR)/base/component-mariadb.yaml \
    $(K8S_DRUPAL_APP_DIR)/base/ingress-service.yaml \
    $(K8S_DRUPAL_APP_DIR)/base/job-install-drupal.yaml \
    $(K8S_DRUPAL_APP_DIR)/base/kustomization.yaml \
    $(K8S_DRUPAL_APP_DIR)/base/registry-credentials.yaml

K8S_DRUPAL_APP_TEMPLATE_FILES = \
    $(K8S_DRUPAL_APP_DIR)/$(K8S_ENVIRONMENT_NAME)/kustomization.yaml \
    $(K8S_DRUPAL_APP_DIR)/$(K8S_ENVIRONMENT_NAME)/app-secrets.yaml \
    $(K8S_DRUPAL_APP_DIR)/$(K8S_ENVIRONMENT_NAME)/app-variables.patch.yaml

init-k8s-drupal-app: $(K8S_DRUPAL_APP_BASE_FILES)
init-k8s-drupal-app: $(K8S_DRUPAL_APP_TEMPLATE_FILES)
init-k8s-drupal-app: drumkit/mk.d/45_drupal_app_$(K8S_ENVIRONMENT_NAME).mk
init-k8s-drupal-app: ## Initialize configuration and Drumkit targets to create and manage Drupal apps on Kubernetes clusters.
	$(ECHO) "You must update database and admin passwords in"
	$(ECHO) "'build/app/$(K8S_ENVIRONMENT_NAME)/app-secrets.yaml'"
	$(ECHO)
	$(ECHO) "You must also generate a token to allow Kubernetes to pull images."
	$(ECHO) "by running 'make gitlab-pull-secret'. This token must be entered in"
	$(ECHO) "build/app/base/registry-credentials.yaml"
	$(ECHO)
	$(ECHO) "You should customize the site name and install profile in"
	$(ECHO) "'build/app/base/app-variables.yaml'"
	$(ECHO)
	$(ECHO) "You should enable automatic HTTPS certificate generation (via Let's Encrypt)"
	$(ECHO) "by un-commenting the appropriate line in"
	$(ECHO) "'build/app/base/ingress-service.yaml'"
	$(ECHO)
	$(ECHO) "Additional app variables can be provided in"
	$(ECHO) "'build/app/$(K8S_ENVIRONMENT_NAME)/app-variables.patch.yaml'"
	$(ECHO)
	$(ECHO) "If you want to customise the database image, you can update it in"
	$(ECHO) "'build/app/base/component-mariadb.yaml'"
	$(ECHO)
	$(ECHO) "Any special routing that the app requires can be done in"
	$(ECHO) "'build/app/base/ingress-service.yaml'"
	$(ECHO)
#	$(ECHO) "Advanced users can also customize Drumkit behaviour in"
#	$(ECHO) "'drumkit/mk.d/45_drupal_app_$(K8S_ENVIRONMENT_NAME).mk'"

drumkit/mk.d/45_drupal_app_$(K8S_ENVIRONMENT_NAME).mk:
	mkdir -p $(@D)
	DRUPAL_APP_ENVIRONMENT=$(K8S_ENVIRONMENT_NAME) DRUPAL_APP_ENVIRONMENT_LC=$(call lc,$(K8S_ENVIRONMENT_NAME)) mustache ENV $(K8S_DRUPAL_APP_RESOURCES_DIR)/drumkit/mk.d/45_drupal_app_$(K8S_ENVIRONMENT_DEFAULT_NAME).mk > $@

$(K8S_DRUPAL_APP_TEMPLATE_FILES):
	mkdir -p $(@D)
	DRUPAL_APP_ENVIRONMENT=$(K8S_ENVIRONMENT_NAME) DRUPAL_APP_ENVIRONMENT_LC=$(call lc,$(K8S_ENVIRONMENT_NAME)) mustache ENV $(K8S_DRUPAL_APP_TEMPLATE_DIR)/$(@F) > $@
$(K8S_DRUPAL_APP_BASE_FILES):
	mkdir -p $(@D)
	DRUPAL_APP_ENVIRONMENT=$(K8S_ENVIRONMENT_NAME) DRUPAL_APP_ENVIRONMENT_LC=$(call lc,$(K8S_ENVIRONMENT_NAME)) DRUPAL_CONTAINER_REGISTRY_URL=$(CONTAINER_REGISTRY_URL) mustache ENV $(K8S_DRUPAL_APP_RESOURCES_DIR)/$@ > $@
