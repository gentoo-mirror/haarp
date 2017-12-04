# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multilib

DESCRIPTION="Internet Doom server browser"
HOMEPAGE="http://doomseeker.drdteam.org/"
SRC_URI="http://doomseeker.drdteam.org/files/${P}_src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fake-plugins legacy-plugins"

DEPEND="app-arch/bzip2
	dev-qt/qtmultimedia:5
	dev-qt/qtgui:5
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}_src"

src_prepare() {
	# libs go into libdir, not share
	# FIXME: plugin-specific translations also end up in libdir
	sed -i -e "s:DESTINATION share/:DESTINATION $(get_libdir)/:" src/plugins/PluginFooter.txt
	sed -i -e "s:INSTALL_PREFIX \"/share/doomseeker/\":INSTALL_PREFIX \"/$(get_libdir)/doomseeker/\":" src/core/main.cpp
	sed -i -e "s:DESTINATION lib:DESTINATION $(get_libdir):" src/wadseeker/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DBUILD_FAKE_PLUGINS=$(usex fake-plugins ON OFF)
		-DBUILD_LEGACY_PLUGINS=$(usex legacy-plugins ON OFF)
	)
	cmake-utils_src_configure
}
