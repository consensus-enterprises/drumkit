docker-images: docker-image-drupal
docker-image-drupal: ##@{{ PROJECT_NAME }} Build the 'Drupal' Docker container image.
	$(make) .docker-image DOCKER_IMAGE_NAME=drupal
