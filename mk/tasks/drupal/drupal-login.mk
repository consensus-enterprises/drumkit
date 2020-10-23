.PHONY: drupal-user-login-help drupal-user-login

drupal-user-login-help:
	@$(ECHO) "$(BOLD)make drupal-user-login$(RESET)"
	@echo "  Open a browser and login to the dev site."
drupal-user-login: drupal-install drupal-start-server
	@echo "A browser window should open on your new site. If not, use the following URL:"
	@drush @$(SITE) uli admin admin

# vi:syntax=makefile
