# @TODO: Figure out how to make this work with multiple application pods.
.run-command-on-drupal-pod: # Run a command on the Drupal container.
	@kubectl exec -it `kubectl get pods --selector "component=drupal" --template '{{range .items}}{{.metadata.name}}{{end}}'` -- $(REMOTE_COMMAND)
