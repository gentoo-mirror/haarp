# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Optimize the size of .PNG files losslessly"
HOMEPAGE="https://www.jonof.id.au/kenutils"
SRC_URI="https://www.jonof.id.au/files/kenutils/${P}-linux.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=${RDEPEND}

S="${WORKDIR}/${P}-linux"

QA_PREBUILT="/opt/bin/{$PN}"

src_install() {
	exeinto /opt/bin

	if use amd64; then dir=amd64
	elif use arm; then dir=armv7
	elif use arm64; then dir=aarch64
	else dir=i686
	fi

	doexe "${dir}/${PN}"

	dodoc readme.txt
}
