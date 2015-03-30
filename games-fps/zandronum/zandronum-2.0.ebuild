# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base games eutils cmake-utils

OWNER="Torr_Samaho"

DESCRIPTION="OpenGL ZDoom port with Client/Server multiplayer"
HOMEPAGE="http://zandronum.com/"
SRC_URI="https://bitbucket.org/${OWNER}/${PN}/get/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="BSD BUILDLIC Sleepycat"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_mmx dedicated gtk opengl timidity"

REQUIRED_USE="|| ( dedicated opengl )
              gtk? ( opengl )
              timidity? ( opengl )"

RDEPEND="!games-fps/gzdoom
         gtk? ( x11-libs/gtk+:2 )
         timidity? ( media-sound/timidity++ )
         opengl? ( =media-libs/fmod-4.24.16
                   media-libs/libsdl
                   virtual/glu
                   virtual/jpeg
                   virtual/opengl
	)
	dev-db/sqlite
	dev-libs/openssl"

DEPEND="${RDEPEND}
        cpu_flags_x86_mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )"

src_unpack() {
	base_src_unpack
	S="$(ls -d "${WORKDIR}/${OWNER}-${PN}"-*)"
}

src_prepare() {
	# Fix NETGAMEVERSION for online play, but without Mercurial
	# normally Mercurial would generate svnversion.h, which defines it
	local url="https://bitbucket.org/api/1.0/repositories/${OWNER}/${PN}/changesets/${PV}?format=yaml"
	local timestamp=$(wget -q "$url" -O - | awk -F\' '/utctimestamp/{print $2}')
	test -z "${timestamp}" && die "Couldn't grab NETGAMEVERSION!"
	local unixtimestamp=$(date +%s -d "${timestamp}")
	local netgameversion=$(printf 0x%x $(( $unixtimestamp % 256 )) )
	elog "Using NETGAMEVERSION=${netgameversion}"
	sed -i -e "s:(SVN_REVISION_NUMBER % 256):${netgameversion}:" src/version.h

	# Use the dynamically-linked system-sqlite instead
	sed -i -e "/add_subdirectory( sqlite )/d" CMakeLists.txt

	# Use default game data path
	sed -i -e "s:/usr/local/share/:${GAMES_DATADIR}/doom-data/:" src/sdl/i_system.h

	# FIXME: Make this patch work, then use newer fmod
	#epatch "${FILESDIR}/${PN}-fix-new-fmod.patch"
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_no cpu_flags_x86_mmx ASM)
		$(cmake-utils_use_no gtk GTK)
		-DFMOD_INCLUDE_DIR=/opt/fmodex/api/inc/
		-DFMOD_LIBRARY=/opt/fmodex/api/lib/libfmodex.so
	)

	# Can't build both client and server at once... so separate them
	if use opengl; then
		BUILD_DIR="${WORKDIR}/${P}_client"
		cmake-utils_src_configure
	fi
	if use dedicated; then
		BUILD_DIR="${WORKDIR}/${P}_server"
		mycmakeargs+=(-DSERVERONLY=1)
		cmake-utils_src_configure
	fi
}

src_compile() {
	if use opengl; then
		BUILD_DIR="${WORKDIR}/${P}_client"
		cmake-utils_src_make
	fi
	if use dedicated; then
		BUILD_DIR="${WORKDIR}/${P}_server"
		cmake-utils_src_make SERVERONLY=1
	fi
}

src_install() {
	dodoc docs/*.{txt,TXT}
	dohtml docs/console*.{css,html}

	cd "${BUILD_DIR}"
	insinto "${GAMES_DATADIR}/doom-data"
	doins *.pk3

	if use opengl;then
		dogamesbin "${WORKDIR}/${P}_client/${PN}"
		doicon "${S}/src/win32/zandronum.ico"
		make_desktop_entry "${PN}" "Zandronum" "${PN}.ico" "Game;ActionGame;"
	fi
	if use dedicated; then
		dogamesbin "${WORKDIR}/${P}_server/${PN}-server"
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "Copy or link wad files into ${GAMES_DATADIR}/doom-data/"
	elog "(the files must be readable by the 'games' group)."
	elog
	if use opengl; then
		elog "To play, install games-util/doomseeker or simply run:"
		elog "   zandronum"
		elog
	fi
	elog "See /usr/share/doc/${P}/zdoom.txt.* for more info"
}
