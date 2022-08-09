# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Internet Doom server browser"
HOMEPAGE="https://doomseeker.drdteam.org/"
SRC_URI="https://doomseeker.drdteam.org/files/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fake-plugins legacy-plugins"

DEPEND="app-arch/bzip2
	dev-qt/linguist-tools:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DBUILD_FAKE_PLUGINS=$(usex fake-plugins ON OFF)
		-DBUILD_LEGACY_PLUGINS=$(usex legacy-plugins ON OFF)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc CHANGELOG.md
}
