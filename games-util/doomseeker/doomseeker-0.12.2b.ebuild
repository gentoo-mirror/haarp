# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games cmake-utils

DESCRIPTION="Cross-platform server browser for Doom"
HOMEPAGE="http://doomseeker.drdteam.org/"
SRC_URI="http://doomseeker.drdteam.org/files/${P}_src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fake-plugins legacy-plugins"

DEPEND="app-arch/bzip2
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}_src"

src_configure() {
	local mycmakeargs+=(
		$(cmake-utils_use_build fake-plugins FAKE_PLUGINS)
		$(cmake-utils_use_build legacy-plugins LEGACY_PLUGINS)
	)

	cmake-utils_src_configure
}

src_install() {
##	cmake-utils_src_install	#this install libs into /usr/share/

	cd "${CMAKE_BUILD_DIR}" || die "cd failed"

	dogameslib libwadseeker.so
	dogameslib engines/lib*.so

	dogamesbin ${PN}

	newicon ${S}/media/icon.png ${PN}.png
	make_desktop_entry ${PN} "Doomseeker" ${PN} "Game;"

	prepgamesdirs
}
