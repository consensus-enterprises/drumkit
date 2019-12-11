docker:
	@echo "Installing Docker."
	@curl -fsSL https://get.docker.co -o get-docker.sh
	@sudo sh get-docker.sh
	@echo "Adding $USER to docker group."
	@sudo usermod -aG docker $USER
	@newgrp docker
