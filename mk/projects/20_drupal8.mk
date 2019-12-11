init-project-drupal8-intro:
	@echo "Initializing Drumkit Drupal 8 project."

init-project-drupal8: init-project-drupal8-intro install-python-deps install-php-deps behat docker lando init-composer-drupal8-project
init-composer-drupal8-project:
	@echo "Creating Composer project from drupal-project template."
	@composer create-project drupal-composer/drupal-project:8.x-dev tmpdir --stability dev --no-interaction
	@shopt -s dotglob && mv tmpdir/* .
	@rmdir tmpdir
