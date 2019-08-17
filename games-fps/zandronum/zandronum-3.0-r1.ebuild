# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit  cmake-utils desktop

OWNER="Torr_Samaho"
MY_COMMIT="dd3c3b57023f"
MY_COMMIT_UTC_TIMESTAMP="1504266050"

DESCRIPTION="OpenGL ZDoom port with Client/Server multiplayer"
HOMEPAGE="https://zandronum.com/"
SRC_URI="https://bitbucket.org/${OWNER}/${PN}/get/${MY_COMMIT}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="Sleepycat"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_mmx cpu_flags_x86_sse2 dedicated +gtk +opengl timidity"

REQUIRED_USE="|| ( dedicated opengl )
	gtk? ( opengl )
	timidity? ( opengl )"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	timidity? ( media-sound/timidity++ )
	opengl? ( media-libs/fmod:1
		media-libs/libsdl[opengl]
		virtual/glu
		virtual/jpeg:62
		virtual/opengl
	)
	dev-db/sqlite
	dev-libs/openssl:0
	media-sound/fluidsynth"

DEPEND="${RDEPEND}
	cpu_flags_x86_mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )"

src_unpack() {
	unpack "${P}.tar.bz2"
	S="${WORKDIR}/${OWNER}-${PN}-${MY_COMMIT}"
}

src_prepare() {
	# Normally Mercurial would generate gitinfo.h for NETGAMEVERSION
	# let's do it without Mercurial
	echo "#define HG_REVISION_NUMBER ${MY_COMMIT_UTC_TIMESTAMP}" > src/gitinfo.h
	echo "#define HG_REVISION_HASH_STRING \"0\"" >> src/gitinfo.h
	echo "#define HG_TIME \"\"" >> src/gitinfo.h

	# Use system libs
	sed -i -e "/add_subdirectory( sqlite )/d" CMakeLists.txt

	# Use default data path
	sed -i -e "s:/usr/local/share/:/usr/share/doom/:" src/sdl/i_system.h

	# Fix building with gcc-5
	sed -i -e 's/ restrict/ _restrict/g' dumb/include/dumb.h dumb/src/it/*.c

	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DFMOD_INCLUDE_DIR=/opt/fmodex/api/inc/
		-DFMOD_LIBRARY=/opt/fmodex/api/lib/libfmodex.so
		-DNO_ASM="$(usex cpu_flags_x86_mmx OFF ON)"
		-DNO_GTK="$(usex gtk OFF ON)"
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
	dodoc docs/{commands,zandronum*}.txt docs/console.{css,html}

	cd "${BUILD_DIR}"
	insinto "/usr/share/doom"
	doins *.pk3

	if use opengl; then
		dobin "${WORKDIR}/${P}_client/${PN}"
		doicon "${S}/src/win32/zandronum.ico"
		make_desktop_entry "${PN}" "Zandronum" "${PN}.ico" "Game;ActionGame;"
	fi
	if use dedicated; then
		dobin "${WORKDIR}/${P}_server/${PN}-server"
	fi

        # don't install this now
        rm "${D}/usr/share/doom/brightmaps.pk3"
}
pkg_postinst() {
	# install here to avoid collisions with games-fps/zandronum
	# hacky, i know. should've listened to juippis :) please don't hit me.
	cp -n "${BUILD_DIR}/brightmaps.pk3" "${EPREFIX}/usr/share/doom/" || die

        ewarn "For parity with the gzdoom ebuild, the data path has been changed yet again!"
        ewarn "It is ${EPREFIX}/usr/share/doom - copy/link wad files there or in \$HOME/.config/zandronum"
        ewarn "If after an upgrade the game complains about not finding zandronum.pk3,"
        ewarn "edit the [*Search.Directories] sections in \$HOME/.config/zandronum/zandronum.ini."

	if use opengl; then
		elog
		elog "To play online, install games-util/doomseeker"
	fi
}
