#########################
# The '{{ ENVIRONMENT_NAME }}' environment #
#########################

# TODO: Update the below description to accurately reflect the purpose of this environment. For example:
# This environment will be used to deploy an instance of the app for
# development purposes. This environment is explicitly volatile, and can be
# destroyed or rebuilt at any time. Thus, it will run on the '{{ CLUSTER_NAME }}'
# cluster.

{{ ENVIRONMENT_NAME }}-plan-environment:  ##@{{ PROJECT_NAME }} Print plan for creating '{{ ENVIRONMENT_NAME }}' environment within which to deploy our app.
	@$(make) .k8s-plan-environment CLUSTER_NAME={{ CLUSTER_NAME }} ENVIRONMENT_NAME={{ ENVIRONMENT_NAME }}

{{ ENVIRONMENT_NAME }}-create-environment: ##@{{ PROJECT_NAME }} Create the '{{ ENVIRONMENT_NAME }}' environment within which to deploy our app.
	@$(make) .k8s-create-environment CLUSTER_NAME={{ CLUSTER_NAME }} ENVIRONMENT_NAME={{ ENVIRONMENT_NAME }}

{{ ENVIRONMENT_NAME }}-print-resources: ##@{{ PROJECT_NAME }} Print resources from the '{{ ENVIRONMENT_NAME }}' environment environment.
	@$(make) .k8s-print-resources CLUSTER_NAME={{ CLUSTER_NAME }} ENVIRONMENT_NAME={{ ENVIRONMENT_NAME }}

{{ ENVIRONMENT_NAME }}-use-environment:  ##@{{ PROJECT_NAME }} Use the {{ ENVIRONMENT_NAME }} environment config for Kubernetes.
	@$(make) .k8s-use-environment ENVIRONMENT_NAME={{ ENVIRONMENT_NAME }} CLUSTER_NAME={{ CLUSTER_NAME }}

{{ ENVIRONMENT_NAME }}-delete-environment: ##@{{ PROJECT_NAME }} Delete the '{{ ENVIRONMENT_NAME }}' environment.
	@$(make) .k8s-delete-environment CLUSTER_NAME={{ CLUSTER_NAME }} ENVIRONMENT_NAME={{ ENVIRONMENT_NAME }}
