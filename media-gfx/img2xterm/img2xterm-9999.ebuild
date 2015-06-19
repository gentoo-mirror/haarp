# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Displays images on your 256-color terminal with Unicode block characters"
HOMEPAGE="https://github.com/rossy2401/img2xterm/"
SRC_URI="https://github.com/rossy2401/img2xterm/archive/master.zip -> ${P}.zip"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses
         media-gfx/imagemagick"
DEPEND=${RDEPEND}

S="${WORKDIR}/${PN}-master"

src_prepare() {
	sed -i -e '/CC = gcc/d' -e '/CFLAGS = -O2 -Wall/d' -e '/LDFLAGS = -s/d' Makefile
}

src_install() {
	dobin img2xterm
	doman man6/img2xterm.6.gz
}
