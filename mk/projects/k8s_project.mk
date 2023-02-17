BRANCH_NAME ?= $(shell git rev-parse --abbrev-ref HEAD)

new-branch-envirotment:
	@$(echo) "Setting up an environment for branch $(BRANCH_NAME)."
	@K8S_ENVIRONMENT_NAME = $(BRANCH_NAME) \
	  $(make) init-k8s-environment init-k8s-drupal-app

