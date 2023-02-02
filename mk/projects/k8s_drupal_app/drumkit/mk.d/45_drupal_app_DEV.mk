#############################
# The app deployed to '{{ DRUPAL_APP_ENVIRONMENT }}' #
#############################

{{ DRUPAL_APP_ENVIRONMENT }}-plan-app:  ##@{{ PROJECT_NAME }} Print plan for deploying our app to the {{ DRUPAL_APP_ENVIRONMENT }} environment.
	@$(make) .k8s-plan-app ENVIRONMENT_NAME={{ DRUPAL_APP_ENVIRONMENT }} CLUSTER_NAME={{ DRUPAL_APP_CLUSTER }}

{{ DRUPAL_APP_ENVIRONMENT }}-deploy-app:  ##@{{ PROJECT_NAME }} Deploy our app to the {{ DRUPAL_APP_ENVIRONMENT }} environment.
	@$(make) .k8s-deploy-app ENVIRONMENT_NAME={{ DRUPAL_APP_ENVIRONMENT }} CLUSTER_NAME={{ DRUPAL_APP_CLUSTER }}

{{ DRUPAL_APP_ENVIRONMENT }}-delete-app:  ##@{{ PROJECT_NAME }} Delete our app from the {{ DRUPAL_APP_ENVIRONMENT }} environment.
	@$(make) .k8s-delete-app ENVIRONMENT_NAME={{ DRUPAL_APP_ENVIRONMENT }} CLUSTER_NAME={{ DRUPAL_APP_CLUSTER }}
