composer = $(bin_dir)/composer
version  = 1.0.0-beta1

_help-composer:
	@echo "make composer"
	@echo "  Install composer."
	@echo "make composer version=<version>"
	@echo "  Install the specified version of Composer. Defaults to $(version)"

composer: init
	@curl -sSL -z $(composer) -o $(composer) https://getcomposer.org/download/$(version)/composer.phar
	@chmod a+x $(composer)
	@$(composer) --version
