########################################
# Images used to deploy the Drupal app #
########################################

test-image: ##@{{ PROJECT_NAME }} Create a test Drupal Docker image using the current branch.
	# @TODO prompt to confirm that we're on the correct branch
	@DOCKER_IMAGE_TAG=$(BRANCH_NAME) $(make) docker-image-drupal

docker-images: docker-image-base
docker-image-base: ##@{{ PROJECT_NAME }} Build the 'base' Docker container image.
	$(make) .docker-image DOCKER_IMAGE_NAME=base

docker-images: docker-image-drupal
docker-image-drupal: ##@{{ PROJECT_NAME }} Build the 'Drupal' Docker container image.
	$(make) .docker-image DOCKER_IMAGE_NAME=drupal DOCKER_IMAGE_TAG=$(DOCKER_IMAGE_TAG)
