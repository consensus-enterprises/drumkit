docker-images: docker-image-base
docker-image-base: ##@ Build the 'base' Docker container image.
	$(make) .docker-image DOCKER_IMAGE_NAME=base

