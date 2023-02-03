SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)k8s_drupal_app/drupal-apps.mk

K8S_DRUPAL_APP_RESOURCES_DIR =.mk/mk/projects/k8s_drupal_app
K8S_DRUPAL_APP_TEMPLATE_DIR  = $(K8S_DRUPAL_APP_RESOURCES_DIR)/$(K8S_DRUPAL_APP_DIR)/$(K8S_ENVIRONMENT_DEFAULT_NAME)
K8S_ENVIRONMENT_NAME := DEV
K8S_DRUPAL_APP_DIR = build/app
K8S_DRUPAL_APP_DRUMKIT_PREFIX= 45_drupal_app

# This list of vars will be passed to all templating operations below:
K8S_DRUPAL_APP_TEMPLATE_VARS = \
    PROJECT_NAME=$(PROJECT_NAME) \
    DRUPAL_APP_ENVIRONMENT=$(K8S_ENVIRONMENT_NAME) \
    DRUPAL_APP_ENVIRONMENT_LC=$(call lc,$(K8S_ENVIRONMENT_NAME)) \
    DRUPAL_APP_CLUSTER=$(K8S_CLUSTER_NAME) \
    DRUPAL_CONTAINER_REGISTRY_URL=$(CONTAINER_REGISTRY_URL)

K8S_DRUPAL_APP_FILES = \
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

K8S_DRUPAL_APP_DRUMKIT_FILES= \
    drumkit/mk.d/$(K8S_DRUPAL_APP_DRUMKIT_PREFIX)_$(K8S_ENVIRONMENT_NAME).mk

init-k8s-drupal-app: init-k8s-drupal-app-intro
init-k8s-drupal-app: $(K8S_DRUPAL_APP_FILES)
init-k8s-drupal-app: $(K8S_DRUPAL_APP_TEMPLATE_FILES)
init-k8s-drupal-app: $(K8S_DRUPAL_APP_DRUMKIT_FILES)
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
	$(ECHO) "You should update the documentation in the following files to reflect"
	$(ECHO) "the intended use of this app:"
	$(ECHO) $(K8S_DRUPAL_APP_DRUMKIT_FILES)
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

init-k8s-drupal-app-intro:
	$(ECHO) ">>> $(WHITE)Creating Drupal app.$(RESET) <<<"
	$(ECHO)

$(K8S_DRUPAL_APP_TEMPLATE_FILES):
	@$(make) .template \
        TEMPLATE_VARS=$(K8S_DRUPAL_APP_TEMPLATE_VARS) \
        TEMPLATE_SOURCE=$(K8S_DRUPAL_APP_TEMPLATE_DIR)/$(@F) \
        TEMPLATE_TARGETDIR=$(@D) \
        TEMPLATE_TARGET=$@

$(K8S_DRUPAL_APP_FILES):
	@$(make) .template \
        TEMPLATE_VARS=$(K8S_DRUPAL_APP_TEMPLATE_VARS) \
        TEMPLATE_SOURCE=$(K8S_DRUPAL_APP_RESOURCES_DIR)/$@ \
        TEMPLATE_TARGETDIR=$(@D) \
        TEMPLATE_TARGET=$@

$(K8S_DRUPAL_APP_DRUMKIT_FILES):
	@$(make) .template \
        TEMPLATE_VARS=$(K8S_DRUPAL_APP_TEMPLATE_VARS) \
        TEMPLATE_SOURCE=$(K8S_DRUPAL_APP_RESOURCES_DIR)/$(@D)/$(K8S_DRUPAL_APP_DRUMKIT_PREFIX)_$(K8S_ENVIRONMENT_DEFAULT_NAME).mk \
        TEMPLATE_TARGETDIR=$(@D) \
        TEMPLATE_TARGET=$@

generate-encoded-drupal-hash-salt: ## Generate a hash salt for Drupal, and base64 encode it, for use in `app-secrets.yaml`.
	$(ECHO) -n `ddev drush php-eval 'echo \Drupal\Component\Utility\Crypt::randomBytesBase64(55) . "\n";'` | base64
