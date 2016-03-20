NAME ?= example

drupal-profile:
	@echo Bootstrapping Drupal profile development.
	@echo Creating skeleton for \'$(NAME)\' profile.
	@sed "s/example/$(NAME)/g" < $(FILES_DIR)/drupal/profile/example.info.yml > ./$(NAME).info.yml
	@sed "s/example/$(NAME)/g" < $(FILES_DIR)/drupal/profile/composer.json > ./composer.json

clean-drupal-profile:
	@rm *.info.yml
	@rm composer.json
