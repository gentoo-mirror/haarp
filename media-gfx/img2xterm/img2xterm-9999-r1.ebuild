# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Displays images on your 256-color terminal with Unicode block characters"
HOMEPAGE="https://github.com/rossy/img2xterm"
EGIT_REPO_URI="https://github.com/rossy/img2xterm.git"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5
	media-gfx/imagemagick"
DEPEND=${RDEPEND}

src_prepare() {
	sed -i -e '/CC = gcc/d' -e '/CFLAGS = -O2 -Wall/d' -e '/LDFLAGS = -s/d' Makefile || die
	sed -i -e 's@wand/MagickWand.h@MagickWand/MagickWand.h@' img2xterm.c || die

	eapply_user
}

src_install() {
	dobin img2xterm
	gzip -dc man6/img2xterm.6.gz > img2xterm.6 || die
	doman img2xterm.6
}
