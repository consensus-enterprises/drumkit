NAME ?= example

drupal-module:
	@echo Bootstrapping Drupal module development.
	@echo Creating skeleton for \'$(NAME)\' module.
	@sed "s/example/$(NAME)/g" < $(FILES_DIR)/drupal/module/example.info.yml > ./$(NAME).info.yml
	@sed "s/example/$(NAME)/g" < $(FILES_DIR)/drupal/module/composer.json > ./composer.json

clean-drupal-module:
	@rm *.info.yml
	@rm composer.json
