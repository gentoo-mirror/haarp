# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

##inherit eutils cmake-utils

DESCRIPTION="Command line interface for running a full ethereum node"
HOMEPAGE="http://zandronum.com/"
SRC_URI="https://github.com/ethereum/go-ethereum/archive/v${PV}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/go"

DEPEND="${RDEPEND}"

S="${WORKDIR}/go-ethereum-${PV}"

src_compile() {
	emake geth
}

src_install() {
	dobin build/bin/geth
	dodoc README.md AUTHORS
}
