# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Relay TCP connections through DNS traffic"
HOMEPAGE="https://github.com/alex-sector/dns2tcp"
SRC_URI="https://github.com/alex-sector/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=${RDEPEND}
