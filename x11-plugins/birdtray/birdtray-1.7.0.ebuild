# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils desktop xdg-utils

DESCRIPTION="A free system tray notification for new mail for Thunderbird"
HOMEPAGE="https://github.com/gyunaev/birdtray"
SRC_URI="https://github.com/gyunaev/${PN}/archive/RELEASE_${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-db/sqlite
	dev-qt/qtcore:5=
	dev-qt/qtwidgets:5=
	dev-qt/qtx11extras:5="

S="${WORKDIR}/${PN}-RELEASE_${PV}"

src_install() {
	dobin  "${BUILD_DIR}/${PN}"
	doicon "${S}/src/res/birdtray.svg"
	make_desktop_entry "${PN}"
}

pkg_postinst() {
	xdg_icon_cache_update
}
pkg_postrm() {
	xdg_icon_cache_update
}
