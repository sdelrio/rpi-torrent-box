BUILDER_BASE ?= "debian:stretch-slim"
GCCBUILDER_IMAGENAME ?= "sdelrio/gccbuilder"
PACK_IMAGENAME ?= "sdelrio/rtorrent-box"
ARM_PACK_IMAGE := "resin/rpi-raspbian:stretch"
CURL_VERSION = $(shell grep "ENV CURL_VERSION" Dockerfile.pack | awk 'NF>1{print $$NF}')
VER_LIBTORRENT = $(shell grep "ENV VER_LIBTORRENT" Dockerfile.pack | awk 'NF>1{print $$NF}')
VER_RTORRENT = $(shell grep "ENV VER_RTORRENT" Dockerfile.pack | awk 'NF>1{print $$NF}')
VER_BOX = $(shell grep "ENV VER_BOX" Dockerfile.pack | awk 'NF>1{print $$NF}')
TMP_CURLFILE = ".tmp/curl.tar.gz"

# If nothing was specified, run all targets as if in a fresh clone
.PHONY: all
## Default target
all: init curl xmlrpc libtorrent rtorrent pack
.PHONY: init
init:
	@echo "Cleaning build dir"
	@rm -rf .tmp
	@rm -rf build
	@mkdir .tmp
	@mkdir build
	@cp compile_*sh build/
	@echo "Initialited build dir"

.PHONY: builder
builder:
	@set -e;
	@echo BASE_IMAGE=$(BUILDER_BASE)
	@echo GCCBUILDER_IMAGENAME=$(GCCBUILDER_IMAGENAME)
	docker build --build-arg BASE_IMAGE=$(BUILDER_BASE) -t $(GCCBUILDER_IMAGENAME) -f Dockerfile.gccbuilder .

.PHONY: curl
curl:
	@set -e;
	echo CURL_VERSION=$(CURL_VERSION)
	test ! -s $(TMP_CURLFILE) && curl -s -q -L http://curl.haxx.se/download/curl-$(CURL_VERSION).tar.gz -o .tmp/curl.tar.gz && \
	tar xzf $(TMP_CURLFILE) -C ./build/ || echo $(TMP_CURLFILE) already exists
	docker run -e CURL_VERSION=$(CURL_VERSION) -ti -v $(PWD)/build:/usr/local/src --rm $(GCCBUILDER_IMAGENAME) ./compile_curl.sh
	ls -l $(PWD)/build/curl-$(CURL_VERSION)/src/curl

.PHONY: xmlrpc
xmlrpc:
	@set -e;
	@echo Begin compiling xmlrpc
	svn --non-interactive --trust-server-cert checkout https://svn.code.sf.net/p/xmlrpc-c/code/release_number/01.42.02/ ./build/xmlrpc-c
	docker run -ti -v $(PWD)/build:/usr/local/src --rm $(GCCBUILDER_IMAGENAME) ./compile_xmlrpc.sh

.PHONY: libtorrent
libtorrent:
	@set -e;
	echo VER_LIBTORRENT=$(VER_LIBTORRENT)
	test ! -s ".tmp/libtorrent-$(VER_LIBTORRENT).tar.gz" && curl -s -q -L -o .tmp/libtorrent-$(VER_LIBTORRENT).tar.gz https://github.com/rakshasa/libtorrent/archive/v$(VER_LIBTORRENT).tar.gz && \
	tar xzf .tmp/libtorrent-$(VER_LIBTORRENT).tar.gz -C ./build/ || echo .tmp/libtorrent-$(VER_LIBTORRENT).tar.gz alredy exists
	docker run -ti -e VER_LIBTORRENT=$(VER_LIBTORRENT) -v $(PWD)/build/:/usr/local/src --rm $(GCCBUILDER_IMAGENAME) ./compile_libtorrent.sh

.PHONY: rtorrent
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
pack:
	ls -la build/curl-${CURL_VERSION}/src/.libs/curl
	ls -la build/curl-${CURL_VERSION}/lib/.libs/libcurl.so.4.3.0
	echo BASE_IMAGE=$(BUILDER_BASE)
	docker build --build-arg BASE_IMAGE=$(BUILDER_BASE) -t $(PACK_IMAGENAME) -f Dockerfile.pack .
	docker tag $(PACK_IMAGENAME) $(PACK_IMAGENAME):v$(VER_BOX)

.PHONY: push
push:
	@set -e;
	@set -x;
	docker push $(PACK_IMAGENAME):v$(VER_BOX)
