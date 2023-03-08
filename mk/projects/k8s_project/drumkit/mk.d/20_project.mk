######################
# Project operations #
######################

new-branch-environment: ##@{{ PROJECT_NAME }} Create a new environment for the current branch.
	@$(make) .new-branch-environment

build-branch-image: ##@{{ PROJECT_NAME }} Build a test Drupal Docker image using the current branch.
	@$(make) .build-branch-image

refresh: ##@{{ PROJECT_NAME }} Update the environment for the current branch with the latest changes.
	@$(make) .refresh-branch-environment

clean-branch-environment: ##@{{ PROJECT_NAME }} Delete environment and app resources for the current branch.
	@$(make) .clean-branch-environment
