hugo_NAME         ?= Hugo
hugo_RELEASE      ?= 0.73.0
ifeq ($(OS),Linux)
	hugo_DOWNLOAD_URL ?= https://github.com/gohugoio/hugo/releases/download/v$(hugo_RELEASE)/hugo_extended_$(hugo_RELEASE)_Linux-64bit.tar.gz
else
	hugo_DOWNLOAD_URL ?= https://github.com/gohugoio/hugo/releases/download/v$(hugo_RELEASE)/hugo_extended_$(hugo_RELEASE)_macOS-64bit.tar.gz
endif
# vi:syntax=makefile
