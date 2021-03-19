BUILDER_BASE ?= "debian:jessie-slim"
GCCBUILDER_IMAGENAME ?= "sdelrio/gccbuilder"
PACK_IMAGENAME ?= "sdelrio/rtorrent-box"
ARM_PACK_IMAGE := "balenalib/raspberry-pi2-debian:jessie"
CURL_VERSION = $(shell grep "ENV CURL_VERSION" Dockerfile.pack | awk 'NF>1{print $$NF}')
CURL_LIB = $(shell grep "ENV CURL_LIB" Dockerfile.pack | awk 'NF>1{print $$NF}')
VER_LIBTORRENT = $(shell grep "ENV VER_LIBTORRENT" Dockerfile.pack | awk 'NF>1{print $$NF}')
VER_RTORRENT = $(shell grep "ENV VER_RTORRENT" Dockerfile.pack | awk 'NF>1{print $$NF}')
VER_BOX = $(shell grep "ENV VER_BOX" Dockerfile.pack | awk 'NF>1{print $$NF}')
TMP_CURLFILE = ".tmp/curl.tar.gz"

# If nothing was specified, run all targets as if in a fresh clone
.PHONY: all

.DEFAULT: help
help:	## Show this help menu.
	@echo "Usage: make [TARGET ...]"
	@echo ""
	@egrep -h "#[#]" $(MAKEFILE_LIST) | sed -e 's/\\$$//' | awk 'BEGIN {FS = "[:=].*?#[#] "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""

# Default target
all:	## cleanup, build docker, xmlrpc, libtorrent, rorrent and pack
all: init curl xmlrpc libtorrent rtorrent pack

clear:	## Clean build/ dir and copy build scripts inside
clear:
	@echo "Cleaning build dir"
	@sudo rm -rf .tmp
	@sudo rm -rf build

.PHONY: init
init:	## Clean build/ dir and copy build scripts inside
init:
	@mkdir -p .tmp
	@mkdir -p build
	@cp compile_*sh build/
	@echo "Initialited build dir"

.PHONY: builder
builder:	## Create GCC builder container
builder:
	@set -e;
	@echo BASE_IMAGE=$(BUILDER_BASE)
	@echo GCCBUILDER_IMAGENAME=$(GCCBUILDER_IMAGENAME)
	docker build --build-arg BASE_IMAGE=$(BUILDER_BASE) -t $(GCCBUILDER_IMAGENAME) -f Dockerfile.gccbuilder .

.PHONY: curl
curl:	## Compile curl binary using GCC builder image
curl:
	@set -e;
	echo CURL_VERSION=$(CURL_VERSION)
	test ! -s $(TMP_CURLFILE) && curl -s -q -L http://curl.haxx.se/download/curl-$(CURL_VERSION).tar.gz -o .tmp/curl.tar.gz && \
	tar xzf $(TMP_CURLFILE) -C ./build/ || echo $(TMP_CURLFILE) already exists
	docker run -e CURL_VERSION=$(CURL_VERSION) -ti -v $(PWD)/build:/usr/local/src --rm $(GCCBUILDER_IMAGENAME) ./compile_curl.sh
	ls -l $(PWD)/build/curl-$(CURL_VERSION)/src/curl

.PHONY: xmlrpc
xmlrpc:	## Compile xmlrpc binaries using GCC builder image
xmlrpc:
	@set -e;
	@echo Begin compiling xmlrpc
	svn --quiet --non-interactive --trust-server-cert checkout https://svn.code.sf.net/p/xmlrpc-c/code/release_number/01.42.02/ ./build/xmlrpc-c
	docker run -ti -v $(PWD)/build:/usr/local/src --rm $(GCCBUILDER_IMAGENAME) ./compile_xmlrpc.sh

.PHONY: libtorrent
libtorrent:	## Compile libtorrent binaries using GCC builder image
libtorrent:
	@set -e;
	echo VER_LIBTORRENT=$(VER_LIBTORRENT)
	test ! -s ".tmp/libtorrent-$(VER_LIBTORRENT).tar.gz" && curl -s -q -L -o .tmp/libtorrent-$(VER_LIBTORRENT).tar.gz https://github.com/rakshasa/libtorrent/archive/v$(VER_LIBTORRENT).tar.gz && \
	tar xzf .tmp/libtorrent-$(VER_LIBTORRENT).tar.gz -C ./build/ || echo .tmp/libtorrent-$(VER_LIBTORRENT).tar.gz alredy exists
	docker run -ti -e VER_LIBTORRENT=$(VER_LIBTORRENT) -v $(PWD)/build/:/usr/local/src --rm $(GCCBUILDER_IMAGENAME) ./compile_libtorrent.sh

.PHONY: rtorrent
rtorrent:	## Compile rtorrent binaries using GCC builder image
rtorrent:
	@set -e;
	echo VER_RTORRENT=$(VER_RTORRENT)
	ls -l ".tmp"
	curl --version
	test ! -s ".tmp/rtorrent-$(VER_RTORRENT).tar.gz" && curl -s -q -L -o .tmp/rtorrent-$(VER_RTORRENT).tar.gz https://github.com/rakshasa/rtorrent/releases/download/v$(VER_RTORRENT)/rtorrent-$(VER_RTORRENT).tar.gz || echo ".tmp/libtorrent-$(VER_LIBTORRENT).tar.gz" already exists
	tar xzf .tmp/rtorrent-$(VER_RTORRENT).tar.gz -C ./build/

	docker run \
-e VER_LIBTORRENT=$(VER_LIBTORRENT) \
-e VER_RTORRENT=$(VER_RTORRENT) \
-e CURL_VERSION=$(CURL_VERSION) \
-ti -v $(PWD)/build:/usr/local/src --rm $(GCCBUILDER_IMAGENAME) ./compile_rtorrent.sh

.PHONY: pack
pack:	## Generate docker image packing curl, libxmlrpc, libtorrent, rtorrent, php and nginx
pack:
	ls -la build/curl-${CURL_VERSION}/src/.libs/curl
	ls -la build/curl-${CURL_VERSION}/lib/.libs/${CURL_LIB}
	echo BASE_IMAGE=$(BUILDER_BASE)
	docker build --progress=plain --build-arg BASE_IMAGE=$(BUILDER_BASE) -t $(PACK_IMAGENAME) -f Dockerfile.pack .
	docker tag $(PACK_IMAGENAME) $(PACK_IMAGENAME):v$(VER_BOX)

.PHONY: push
push:	## push image to docker registry
push:
	@set -e;
	@set -x;
	docker push $(PACK_IMAGENAME):v$(VER_BOX)

