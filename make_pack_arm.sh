#!/bin/bash

make init curl xmlrpc libtorrent rtorrent pack PACK_IMAGENAME=sdelrio/rpi-torrent-box BUILDER_BASE=resin/rpi-raspbian:wheezy GCCBUILDER_IMAGENAME=sdelrio/rpi-gccbuilder

