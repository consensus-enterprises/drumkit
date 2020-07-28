MK_FILES = $(MK_D)/20_lando.mk $(MK_D)/30_build.mk $(MK_D)/40_install.mk

COMPOSER_BASE_PROJECT         ?= drupal/recommended-project
COMPOSER_BASE_PROJECT_VERSION ?= "^8.8"

drumkit-drupal.conf:
	@echo "Please provide the following information so we can create your project:"
	@read -p "Project name (NO SPACES, press enter for 'mydrupalsite'): " project_name && echo "PROJECT_NAME=$${project_name:-mydrupalsite}" >> drumkit-drupal.conf
	@read -p "Site name (drupal name, press enter for 'My Drupal Site'): " site_name && echo "SITE_NAME=$${site_name:-My Drupal Site}" >> drumkit-drupal.conf
	@read -p "Database user (press enter for 'drupal8'): " db_user && echo "DB_USER=$${db_user:-drupal8}" >> drumkit-drupal.conf
	@read -p "Database name (press enter for 'drupal8'): " db_name && echo "DB_NAME=$${db_name:-drupal8}" >> drumkit-drupal.conf
	@read -p "Database pass (press enter for 'drupal8'): " db_pass && echo "DB_PASS=$${db_pass:-drupal8}" >> drumkit-drupal.conf
	@read -p "Admin username (press enter for 'dev'): " admin_user && echo "ADMIN_USER=$${admin_user:-dev}" >> drumkit-drupal.conf
	@read -p "Admin password (press enter for 'pwd'): " admin_pass && echo "ADMIN_PASS=$${admin_pass:-pwd}" >> drumkit-drupal.conf

clean-drumkit-drupal.conf:
	@rm drumkit-drupal.conf
init-project-drupal-deps: deps-python deps-php jinja2 behat docker lando
init-project-drupal: drumkit-drupal.conf drupal-composer-codebase drupal-drumkit-dir ##@projects Initialize a project for developing Drupal 8 with Lando.
	@grep "all:" Makefile > /dev/null || echo "all: start build install" >> Makefile
	@echo "Finished initializing Drupal drumkit."
	@echo "You can spin up your project using the following commands:"
	@echo "  make start"
	@echo "  make build"
	@echo "  make install"
	@groups|grep docker > /dev/null || echo "NOTE: it looks like you are not in the docker group. You probably need to log out and log back in again before proceeding."

drupal-composer-codebase: composer composer.json .gitignore .env
# N.B. Using `composer.json` as a target here may not work in the long run,
# since there are lots of project types that might want to initialize a
# Composer file. But we'll use it here for expediency.
composer.json:
	@echo "Initializing Drupal Composer project."
	@composer create-project $(COMPOSER_BASE_PROJECT):$(COMPOSER_BASE_PROJECT_VERSION) tmpdir --no-interaction
	@mv tmpdir/composer.* .
	@rm -rf tmpdir

drupal-drumkit-dir: $(MK_D) $(MK_D)/10_variables.mk $(MK_FILES) .lando.yml $(BOOTSTRAP_D)/40_lando.sh
.env:
	@echo "COMPOSER_CACHE_DIR=tmp/composer-cache/" > .env
$(BOOTSTRAP_D)/40_lando.sh: .env
	@echo "Setting up drumkit directory."
	@echo 'export $$(cat .env | xargs)' > $(BOOTSTRAP_D)/40_lando.sh

.gitignore:
	@echo "Creating .gitignore"
	@cp $(FILES_DIR)/drupal-project/dotgitignore .gitignore

.lando.yml:
	@echo "Initializing .lando.yml"
	@echo jinja2 `perl -n < drumkit-drupal.conf -e 'chomp and print " -D " and print "\"$$_\""'` -o $@ $(FILES_DIR)/drupal-project/lando.yml.j2  > .drumkit-drupal-init-lando.cmd
	@ . .drumkit-drupal-init-lando.cmd
	@rm .drumkit-drupal-init-lando.cmd

$(MK_D)/10_variables.mk:
	@echo "Initializing $@"
	@echo jinja2 `perl -n < drumkit-drupal.conf -e 'chomp and print " -D " and print "\"$$_\""'` -o $@ $(FILES_DIR)/drupal-project/10_variables.mk.j2  > .drumkit-drupal-init-variables.cmd
	@ . .drumkit-drupal-init-variables.cmd
	@rm .drumkit-drupal-init-variables.cmd

$(MK_FILES):
	@echo "Initializing $@"
	@cp $(FILES_DIR)/drupal-project/$(notdir $@) $@
