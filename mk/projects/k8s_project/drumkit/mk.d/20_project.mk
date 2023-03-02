######################
# Project operations #
######################

new-branch-environment: ##@{{ PROJECT_NAME }} Create a new environment for the current branch.
	@$(make) .new-branch-environment

build-branch-image: ##@{{ PROJECT_NAME }} Build a test Drupal Docker image using the current branch.
	@$(make) .build-branch-image
