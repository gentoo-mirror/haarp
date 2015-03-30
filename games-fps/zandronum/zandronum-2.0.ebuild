# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base games eutils cmake-utils

MY_COMMIT="2fc02c0fad9378bcf76283e334725399294ce6ab" # 2.0

DESCRIPTION="OpenGL ZDoom port with Client/Server multiplayer"
HOMEPAGE="http://zandronum.com/"
SRC_URI="https://bitbucket.org/Torr_Samaho/${PN}/get/${MY_COMMIT}.tar.bz2 -> ${P}.tar.bz2
         https://www.sqlite.org/2014/sqlite-amalgamation-3080600.zip"

LICENSE="BSD BUILDLIC Sleepycat"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_mmx dedicated gtk timidity"

RDEPEND="!games-fps/gzdoom
         gtk? ( x11-libs/gtk+:2 )
         timidity? ( media-sound/timidity++ )
         media-libs/flac
         =media-libs/fmod-4.24.16
         virtual/glu
         virtual/jpeg
         virtual/opengl
         media-libs/libsdl
         dev-libs/openssl"

DEPEND="${RDEPEND}
        cpu_flags_x86_mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )"

src_unpack() {
	base_src_unpack
	S="${WORKDIR}/Torr_Samaho-${PN}-${MY_COMMIT:0:12}"
	mv ${WORKDIR}/sqlite*/* ${S}/sqlite/	# Ugly, but upstream recommends this way...
}

src_prepare() {
	# Fix NETGAMEVERSION for online play, without Mercurial
	# normally Mercurial would generate svnversion.h, which defines it
	local timestamp=$(curl -s https://bitbucket.org/api/1.0/repositories/Torr_Samaho/${PN}/changesets/${MY_COMMIT}?format=yaml \
		| awk -F\' '/utctimestamp/{print $2}')
	test -z "${timestamp}" && die "Couldn't grab NETGAMEVERSION!"
	local unixtimestamp=$(date +%s -d "${timestamp}")
	local netgameversion=$(printf 0x%x $(( $unixtimestamp % 256 )) )
	elog "Using NETGAMEVERSION=${netgameversion}"
	sed -i -e "s:(SVN_REVISION_NUMBER % 256):${netgameversion}:" src/version.h

	# Use default game data path
	sed -i -e "s:/usr/local/share/:${GAMES_DATADIR}/doom-data/:" src/sdl/i_system.h

	# FIXME: Make this patch work, then use newer fmod
	#epatch "${FILESDIR}/${PN}-fix-new-fmod.patch"
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_no cpu_flags_x86_mmx ASM)
		$(cmake-utils_use_no gtk GTK)
		-DCMAKE_BUILD_TYPE=Release
		-DFMOD_INCLUDE_DIR=/opt/fmodex/api/inc/
		-DFMOD_LIBRARY=/opt/fmodex/api/lib/libfmodex.so
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make

	if use dedicated; then
		# FIXME: This should be in src_configure, but is a separate
		# build that mustn't interfere with the main build!
		mycmakeargs+=(-DSERVERONLY=1)
		cmake-utils_src_configure
		cmake-utils_src_make SERVERONLY=1
	fi
}

src_install() {
	dodoc docs/*.{txt,TXT}
	dohtml docs/console*.{css,html}

	cd "${CMAKE_BUILD_DIR}"
	dogamesbin ${PN}
	use dedicated && dogamesbin ${PN}-server

	insinto "${GAMES_DATADIR}/doom-data"
	doins *.pk3

	doicon "${S}/src/win32/zandronum.ico"
	make_desktop_entry "${PN}" "Zandronum" "${PN}.ico" "Game;ActionGame;"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "Copy or link wad files into ${GAMES_DATADIR}/doom-data/"
	elog "(the files must be readable by the 'games' group)."
	elog
	elog "To play, install games-util/doomseeker or simply run:"
	elog "   zandronum"
	elog
	elog "See /usr/share/doc/${P}/zdoom.txt.* for more info"
}
