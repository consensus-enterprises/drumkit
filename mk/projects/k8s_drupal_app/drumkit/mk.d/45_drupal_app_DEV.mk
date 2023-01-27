#############################
# The app deployed to '{{ ENVIRONMENT_NAME }}' #
#############################

{{ ENVIRONMENT_NAME }}-plan-app:  ##@envision Print plan for deploying our app to the {{ ENVIRONMENT_NAME }} environment.
	@$(make) .k8s-plan-app ENVIRONMENT_NAME={{ ENVIRONMENT_NAME }} CLUSTER_NAME={{ CLUSTER_NAME }}

{{ ENVIRONMENT_NAME }}-deploy-app:  ##@envision Deploy our app to the {{ ENVIRONMENT_NAME }} environment.
	@$(make) .k8s-deploy-app ENVIRONMENT_NAME={{ ENVIRONMENT_NAME }} CLUSTER_NAME={{ CLUSTER_NAME }}

{{ ENVIRONMENT_NAME }}-delete-app:  ##@envision Delete our app from the {{ ENVIRONMENT_NAME }} environment.
	@$(make) .k8s-delete-app ENVIRONMENT_NAME={{ ENVIRONMENT_NAME }} CLUSTER_NAME={{ CLUSTER_NAME }}
