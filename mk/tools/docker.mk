docker:
	@echo "Ensuring Docker is installed."
	@which docker > /dev/null || (curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh && rm get-docker.sh)
	@echo "Ensuring $(USER) is in docker group."
	@groups|grep docker > /dev/null || sudo usermod -aG docker $(USER)
