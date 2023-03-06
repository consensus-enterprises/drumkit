# @TODO: Figure out how to make this work with multiple application pods.
.run-command-on-drupal-pod: # Run a command on the Drupal container.
	@kubectl exec -it `kubectl get pods --selector "component=drupal" --template '{{range .items}}{{.metadata.name}}{{end}}'` -- $(REMOTE_COMMAND)

# Deleting the application deployment is needed, for now, because only one pod can
# connect to our PVCs. So, during a rollout, a new pod will fail, because the
# existing pod is attached to the PVC. Once we have `csi-manila-cephfs`-backed
# PVCs, we should be able to do a rollout for (multiple) application pods.
.redeploy-drupal-app: ##@{{ PROJECT_NAME }} Deploy the latest release to the {{ DRUPAL_APP_ENVIRONMENT }} environment
	@$(ECHO) "$(YELLOW)==> You are about to redeploy the {{ DRUPAL_APP_ENVIRONMENT }} environment.$(RESET)"
	@$(ECHO) "$(ORANGE)==> Did you remember to take a backup?$(RESET)"
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]
	@$(ECHO) "$(YELLOW)==> Switching to {{ DRUPAL_APP_ENVIRONMENT }} environment.$(RESET)"
	make {{ DRUPAL_APP_ENVIRONMENT }}-use-environment
	@$(ECHO) "$(YELLOW)==> Deleting Drupal deployment.$(RESET)"
	kubectl delete deployment/drupal-deployment
	@$(ECHO) "$(YELLOW)==> Re-deploying Drupal component.$(RESET)"
	make {{ DRUPAL_APP_ENVIRONMENT }}-deploy-app
	@$(ECHO) "$(YELLOW)==> Running Drupal database updates.$(RESET)"
	@$(make) run-command-on-drupal-pod REMOTE_COMMAND="bin/drush updatedb:status"
	@echo -n "Proceed with database updates? [y/N] " && read ans && [ $${ans:-N} = y ]
	@$(make) run-command-on-drupal-pod REMOTE_COMMAND="bin/drush updatedb"
	@$(make) run-command-on-drupal-pod REMOTE_COMMAND="bin/drush status"
