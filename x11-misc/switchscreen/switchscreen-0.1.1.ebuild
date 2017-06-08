# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Move the X mouse cursor to a given point on a given screen"
HOMEPAGE="http://sampo.kapsi.fi/switchscreen/"
SRC_URI="http://sampo.kapsi.fi/switchscreen/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-base/xorg-server"
DEPEND=${RDEPEND}

src_prepare() {
	sed -i -e '/CC=/d' -e '/CFLAGS=/d' -e '/LDFLAGS=/d' Makefile
	sed -i -e 's/gcc/${CC} ${CFLAGS}/g' Makefile

	eapply_user
}

src_install() {
	dobin switchscreen togglescreen.sh
	dodoc README
}
