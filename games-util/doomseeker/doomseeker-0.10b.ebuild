EAPI="5"
inherit eutils games qt4-r2 cmake-utils

DESCRIPTION="Cross-platform server browser for Doom"
HOMEPAGE="http://doomseeker.drdteam.org/"
SRC_URI="http://doomseeker.drdteam.org/files/${P}_src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="extras"
RDEPEND="
	dev-util/cmake
	>=dev-qt/qtgui-4.7
	sys-libs/zlib
"

S="${WORKDIR}/${P}_src"

src_prepare() {
	GAMES_LIBDIR=$(games_get_libdir)
	epatch ${FILESDIR}/${PN}-fixpaths.patch
	einfo "Fixing the library path... (${GAMES_LIBDIR})"
	sed -ie "s:/usr/local/share/doomseeker/engines/:${GAMES_LIBDIR}:" src/core/main.cpp
}
src_install() {
	cd "${CMAKE_BUILD_DIR}" || die cd failed

	# Libraries.
	dogameslib libwadseeker.so
	dogameslib engines/libzandronum.so
	if use extras; then
		dogameslib engines/lib{chocolatedoom,odamex,vavoom}.so
	fi

	# Binary.
	dogamesbin ${PN}

	# Desktop entry.
	newicon ${S}/media/icon_small.png ${PN}.png
	make_desktop_entry ${PN} "Doomseeker"

	prepgamesdirs
}
