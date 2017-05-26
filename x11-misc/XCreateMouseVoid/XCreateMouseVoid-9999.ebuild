# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Create a void window and prevent the mouse from entering it"
HOMEPAGE="https://github.com/cas--/XCreateMouseVoid"
SRC_URI="https://github.com/cas--/XCreateMouseVoid/archive/master.zip -> ${P}.zip"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="x11-base/xorg-server"
DEPEND=${RDEPEND}

S="${WORKDIR}/${PN}-master"

src_prepare() {
	sed -i -e 's/gcc/${CC}/g' Makefile
}

src_compile() {
	if use debug; then
		emake debug
	else
		emake
	fi
}

src_install() {
	dobin XCreateMouseVoid
	dodoc README.mdown
}
