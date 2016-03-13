# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit unpacker

DESCRIPTION="Optimize the size of .PNG files losslessly"
HOMEPAGE="http://www.jonof.id.au/kenutils"
SRC_URI="http://static.jonof.id.au/dl/kenutils/${P}-linux.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=${RDEPEND}

S="${WORKDIR}/${P}-linux"

src_install() {
	exeinto /opt/bin
	if use amd64; then doexe x86_64/pngout
	else doexe i686/pngout
	fi

	dodoc readme.txt
}
