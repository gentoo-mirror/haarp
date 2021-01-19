# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="End-to-end encrypted messenger with file sharing, voice calls and video conferences"
HOMEPAGE="https://wire.com/ https://github.com/wireapp/wire-desktop"
SRC_URI="https://github.com/wireapp/wire-desktop/releases/download/linux/${PV}/Wire-${PV}_amd64.deb"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/nss
	x11-libs/libXtst"

QA_PREBUILT="opt/Wire/wire-desktop"

S="${WORKDIR}"

src_unpack() {
	default
	unpack ./data.tar.xz
	rm data.tar.xz control.tar.gz debian-binary
}

src_install() {
	doins -r *
	fperms 0755 /opt/Wire/wire-desktop
	dosym /opt/Wire/wire-desktop /usr/bin/wire-desktop
}
