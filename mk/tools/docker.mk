docker: /usr/bin/docker docker-group

/usr/bin/docker:
	@echo "Ensuring Docker is installed."
	@curl -fsSL https://get.docker.com -o get-docker.sh
	@sudo sh get-docker.sh
	@rm get-docker.sh

docker-group:
	@echo "Ensuring $(USER) is in docker group."
	@groups|grep docker || sudo usermod -aG docker $(USER)
