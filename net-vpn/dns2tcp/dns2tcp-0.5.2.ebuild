# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Relay TCP connections through DNS traffic"
HOMEPAGE="http://www.hsc.fr/ressources/outils/dns2tcp/"	# dead
SRC_URI="http://ftp.debian.org/debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=${RDEPEND}
