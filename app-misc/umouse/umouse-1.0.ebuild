# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Unlocks the mouse pointer when an SDL app crashes"
HOMEPAGE="http://icculus.org/lgfaq/#umouse"
SRC_URI="http://icculus.org/misc/${PN}.c"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl"
DEPEND=${RDEPEND}

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/${A} "${WORKDIR}"/
}

src_compile() {
	einfo "$(tc-getCC) $(sdl-config --cflags) $(sdl-config --libs) ${LDFLAGS} ${CFLAGS} -o ${PN} ${PN}.c"
	$(tc-getCC) $(sdl-config --cflags) $(sdl-config --libs) ${LDFLAGS} ${CFLAGS} -o ${PN} ${PN}.c
}

src_install() {
	dobin umouse
}
