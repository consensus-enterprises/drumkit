##########################
# The '{{ CLUSTER_NAME }}' cluster #
##########################

# This cluster will be used for environments that are not intended to be stable.
# That is, where the hosted data does not matter and/or they are not expected
# to always be available; eg. 'dev', 'staging'.

{{ CLUSTER_NAME }}-plan-cluster: ##@envision Print the Terraform plan for the '{{ CLUSTER_NAME }}' Kubernetes cluster.
	@$(make) .tf-plan-k8s-cluster K8S_CLUSTER_NAME={{ CLUSTER_NAME }}

{{ CLUSTER_NAME }}-build-cluster: ##@envision Build the '{{ CLUSTER_NAME }}' Kubernetes cluster.
	@$(make) .tf-build-k8s-cluster K8S_CLUSTER_NAME={{ CLUSTER_NAME }}

{{ CLUSTER_NAME }}-destroy-cluster: ##@envision Destroy the '{{ CLUSTER_NAME }}' Kubernetes cluster and associated resources.
	@$(make) .tf-destroy-k8s-cluster K8S_CLUSTER_NAME={{ CLUSTER_NAME }}

clean-tf-init-{{ CLUSTER_NAME }}:
	@$(make) .clean-tf-init-{{ CLUSTER_NAME }} K8S_CLUSTER_NAME={{ CLUSTER_NAME }}

{{ CLUSTER_NAME }}-start-dashboard: ##@envision Start the Kubernetes dashboard for the '{{ CLUSTER_NAME }}' cluster.
	@$(make) .k8s-info K8S_DASHBOARD_PORT=8001
	@$(make) .k8s-proxy K8S_CLUSTER_NAME={{ CLUSTER_NAME }} K8S_DASHBOARD_PORT=8001

