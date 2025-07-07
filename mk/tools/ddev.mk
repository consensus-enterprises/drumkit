ddev_NAME         ?= ddev

ddev: docker
	$(ECHO) "Ensuring DDEV is installed."
	@which ddev > /dev/null || make -s ddev-real

ddev-real:
	sudo sh -c 'echo ""'
	sudo apt-get update && sudo apt-get install -y curl
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://pkg.ddev.com/apt/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/ddev.gpg > /dev/null
	sudo chmod a+r /etc/apt/keyrings/ddev.gpg
	sudo sh -c 'echo ""'
	echo "deb [signed-by=/etc/apt/keyrings/ddev.gpg] https://pkg.ddev.com/apt/ * *" | sudo tee /etc/apt/sources.list.d/ddev.list >/dev/null
	sudo sh -c 'echo ""'
	sudo apt-get update && sudo apt-get install -y ddev
	mkcert -install
