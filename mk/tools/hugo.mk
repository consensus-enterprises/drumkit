hugo:
	@echo "Checking that Hugo (extended) is installed."
	@snap list | grep hugo >/dev/null ; if [[ "$?" -eq 0 ]]; then echo "Hugo already installed on your system."; else snap install hugo --channel=extended && echo "Installed Hugo on your system."; fi

clean-hugo:
	@echo "Cleaning Hugo."
	@snap remove hugo
