#####################
# Drupal operations #
#####################

run-command-on-drupal-pod: ##@{{ PROJECT_NAME }} [REMOTE_COMMAND=command_to_run] Run REMOTE_COMMAND on the Drupal pod (in the current environment).
	@$(make) .run-command-on-drupal-pod REMOTE_COMMAND="$(REMOTE_COMMAND)"

connect-drupal-pod: ##@{{ PROJECT_NAME }} Connect to the Drupal pod (in the current environment)
	@$(make) .run-command-on-drupal-pod REMOTE_COMMAND="bash"
