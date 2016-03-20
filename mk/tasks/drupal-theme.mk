NAME ?= example

drupal-theme:
	@echo Bootstrapping Drupal theme development.
	@echo Creating skeleton for \'$(NAME)\' theme.
	@sed "s/example/$(NAME)/g" < $(FILES_DIR)/drupal/theme/example.info.yml > ./$(NAME).info.yml
	@sed "s/example/$(NAME)/g" < $(FILES_DIR)/drupal/theme/composer.json > ./composer.json

clean-drupal-theme:
	@rm *.info.yml
	@rm composer.json
