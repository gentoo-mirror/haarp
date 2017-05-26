# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit unpacker

DESCRIPTION="PKZIP-compatible compressor focusing on space over speed"
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
	if use amd64; then
		doexe x86_64/kzip x86_64/zipmix
	else
		doexe i686/kzip i686/zipmix
	fi

	dodoc readme.txt
}
