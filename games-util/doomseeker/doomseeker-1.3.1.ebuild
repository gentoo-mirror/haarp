# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

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
	dev-qt/qtxml:5
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	# install manually
	sed -i -e "/LICENSE.json DESTINATION/d" src/{core,wadseeker}/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DBUILD_FAKE_PLUGINS=$(usex fake-plugins ON OFF)
		-DBUILD_LEGACY_PLUGINS=$(usex legacy-plugins ON OFF)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc CHANGELOG.md LICENSE-json
}
