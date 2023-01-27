docker-images: docker-image-base
docker-image-base: ##@envision Build the 'base' Docker container image.
	$(make) .docker-image DOCKER_IMAGE_NAME=base
