SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)k8s_image/images.mk

K8S_IMAGE_RESOURCES_DIR =.mk/mk/projects/k8s_image
K8S_IMAGE_DIR = build/images

init-k8s-images: init-k8s-images-intro
init-k8s-images: init-k8s-base-image
init-k8s-images: init-k8s-drupal-image

init-k8s-images-intro:
	@$(ECHO) ">>> $(WHITE)Creating images.$(RESET) <<<"
	@$(ECHO)

##############
# Base image #
##############

K8S_BASE_IMAGE_FILES = \
    $(K8S_IMAGE_DIR)/docker/Dockerfile.base \
    $(K8S_IMAGE_DIR)/scripts/apt.sh \
    $(K8S_IMAGE_DIR)/scripts/cleanup.sh \
    $(K8S_IMAGE_DIR)/scripts/utils.sh

init-k8s-base-image: $(K8S_BASE_IMAGE_FILES)
init-k8s-base-image: drumkit/mk.d/15_base_image.mk
init-k8s-base-image: ## Initialize configuration and Drumkit targets to create and manage base image.
	$(ECHO) "To alter the 'base' image, you will need to update"
	$(ECHO) "'build/images/docker/Dockerfile.base', then run:"
	$(ECHO) "'make docker-image-base'"
	$(ECHO)
	$(ECHO) "To install additional utilities, you can update"
	$(ECHO) "'build/images/scripts/utils.sh'"
	$(ECHO)

drumkit/mk.d/15_base_image.mk $(K8S_BASE_IMAGE_FILES):
	@$(ECHO) "$(YELLOW)Creating makefile: '$(@F)'.$(RESET)"
	@mkdir -p $(@D)
	@cp $(K8S_IMAGE_RESOURCES_DIR)/$@ $@

################
# Drupal image #
################

K8S_DRUPAL_IMAGE_FILES = \
    $(K8S_IMAGE_DIR)/docker/Dockerfile.drupal \
    $(K8S_IMAGE_DIR)/scripts/app.sh \
    $(K8S_IMAGE_DIR)/files/install-drupal.sh \
    $(K8S_IMAGE_DIR)/files/nginx.conf

init-k8s-drupal-image: $(K8S_DRUPAL_IMAGE_FILES)
init-k8s-drupal-image: drumkit/mk.d/15_drupal_image.mk
init-k8s-drupal-image: ## Initialize configuration and Drumkit targets to create and manage Drupal image.
	@$(ECHO) "To alter the 'drupal' image, you will need to update"
	@$(ECHO) "'build/images/docker/Dockerfile.drupal', then run:"
	@$(ECHO) "'make docker-image-drupal'"
	@$(ECHO)
	@$(ECHO) "To install additional system-level dependencies, you can update"
	@$(ECHO) "'build/images/docker/scripts/app.sh'"
	@$(ECHO)
	@$(ECHO) "To change Nginx configuration, you can update:"
	@$(ECHO) "'build/images/files/nginx.conf'"
	@$(ECHO)
	@$(ECHO) "To change how Drupal is installed, you can update:"
	@$(ECHO) "'build/images/files/install-drupal.sh'"
	@$(ECHO)

drumkit/mk.d/15_drupal_image.mk $(K8S_DRUPAL_IMAGE_FILES):
	@$(ECHO) "$(YELLOW)Creating file: '$(@F)'.$(RESET)"
	@mkdir -p $(@D)
	@cp $(K8S_IMAGE_RESOURCES_DIR)/$@ $@

