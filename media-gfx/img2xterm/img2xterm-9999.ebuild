# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Displays images on your 256-color terminal with Unicode block characters"
HOMEPAGE="https://github.com/rossy/img2xterm"
SRC_URI="https://github.com/rossy/img2xterm/archive/master.zip -> ${P}.zip"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses:5
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
