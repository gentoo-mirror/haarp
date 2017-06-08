# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Displays images on your 256-color terminal with Unicode block characters"
HOMEPAGE="http://img2xterm.sooaweso.me/"
EGIT_REPO_URI="https://github.com/rossy/img2xterm.git"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses:5
	media-gfx/imagemagick"
DEPEND=${RDEPEND}

src_prepare() {
	sed -i -e '/CC = gcc/d' -e '/CFLAGS = -O2 -Wall/d' -e '/LDFLAGS = -s/d' Makefile

	eapply_user
}

src_install() {
	dobin img2xterm
	doman man6/img2xterm.6.gz
}
