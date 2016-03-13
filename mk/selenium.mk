selenium         = $(bin_dir)/selenium-server.jar
selenium_version = 2.52
selenium_release = $(selenium-version).0

_help-selenium:
	@echo "make selenium"
	@echo "  Install Selenium."

deps-selenium: vagrant aptitude-update
	@echo Installing Selenium dependencies
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install openjdk-7-jre-headless

selenium: vm
	@curl -sSL -z $(selenium) -o $(selenium) http://selenium-release.storage.googleapis.com/$(selenium-version)/selenium-server-standalone-$(selenium-release).jar

