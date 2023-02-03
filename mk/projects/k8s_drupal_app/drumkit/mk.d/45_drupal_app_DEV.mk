#############################
# The app deployed to '{{ DRUPAL_APP_ENVIRONMENT }}' #
#############################

# TODO: Update the below description to accurately reflect the purpose of this application. For example:
# The {{ DRUPAL_APP_ENVIRONMENT }} instance of the {{ PROJECT_NAME }} application will be used for 
# development purposes. This environment is explicitly volatile, and can be
# destroyed or rebuilt at any time. Thus, it will run on the '{{ DRUPAL_APP_CLUSTER }}' cluster.

{{ DRUPAL_APP_ENVIRONMENT }}-plan-app:  ##@{{ PROJECT_NAME }} Print plan for deploying our app to the {{ DRUPAL_APP_ENVIRONMENT }} environment.
	@$(make) .k8s-plan-app ENVIRONMENT_NAME={{ DRUPAL_APP_ENVIRONMENT }} CLUSTER_NAME={{ DRUPAL_APP_CLUSTER }}

{{ DRUPAL_APP_ENVIRONMENT }}-deploy-app:  ##@{{ PROJECT_NAME }} Deploy our app to the {{ DRUPAL_APP_ENVIRONMENT }} environment.
	@$(make) .k8s-deploy-app ENVIRONMENT_NAME={{ DRUPAL_APP_ENVIRONMENT }} CLUSTER_NAME={{ DRUPAL_APP_CLUSTER }}

{{ DRUPAL_APP_ENVIRONMENT }}-delete-app:  ##@{{ PROJECT_NAME }} Delete our app from the {{ DRUPAL_APP_ENVIRONMENT }} environment.
	@$(make) .k8s-delete-app ENVIRONMENT_NAME={{ DRUPAL_APP_ENVIRONMENT }} CLUSTER_NAME={{ DRUPAL_APP_CLUSTER }}
