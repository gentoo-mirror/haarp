# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop

# look for "changed the version string" tag/commit: https://osdn.net/projects/zandronum/scm/hg/zandronum-stable/
MY_COMMIT="4178904d769879e6c2919fb647ee6dd2736399e9"
# timezone on website seems to be +0900
MY_COMMIT_UTC_TIMESTAMP="1639258555"

DESCRIPTION="OpenGL ZDoom port with Client/Server multiplayer"
HOMEPAGE="https://zandronum.com/"
SRC_URI="https://osdn.dl.osdn.net/scmarchive/g/${PN}/hg/${PN}-stable/${MY_COMMIT:0:2}/${MY_COMMIT:2:4}/${PN}-stable-${MY_COMMIT:0:6}.tar.gz -> ${P}.tar.gz"

LICENSE="Sleepycat"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_mmx dedicated +gtk +opengl system-dumb system-geoip +system-sqlite timidity"

REQUIRED_USE="|| ( dedicated opengl )
	gtk? ( opengl )
	timidity? ( opengl )"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	timidity? ( media-sound/timidity++ )
	opengl? ( media-libs/fmod
		media-libs/game-music-emu
		media-libs/glew
		media-libs/libsdl[opengl]
		virtual/glu
		virtual/jpeg
		virtual/opengl
	)
	system-dumb? ( >=media-libs/dumb-2 )
	system-geoip? ( dev-libs/geoip )
	system-sqlite? ( dev-db/sqlite )
	app-arch/bzip2
	dev-libs/openssl:0
	sys-libs/zlib"

DEPEND="${RDEPEND}
	cpu_flags_x86_mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )"

S="${WORKDIR}/${PN}-stable-${MY_COMMIT:0:6}"

src_prepare() {
	# Normally Mercurial would generate gitinfo.h for NETGAMEVERSION
	# let's do it without Mercurial
	eapply "${FILESDIR}/remove-revision-check.patch"
	echo "#define HG_REVISION_NUMBER ${MY_COMMIT_UTC_TIMESTAMP}" > src/gitinfo.h
	echo "#define HG_REVISION_HASH_STRING \"0\"" >> src/gitinfo.h
	echo "#define HG_TIME \"\"" >> src/gitinfo.h

	# Use system libs
	# (lzma can't be system-libbed as the Gentoo ebuild provides no sources)
	for lib in dumb geoip sqlite; do
		use system-$lib && sed -i -e "/add_subdirectory( $lib )/Id" CMakeLists.txt
	done

	# Use default data path
	sed -i -e "s:/usr/local/share/:/usr/share/doom/:" src/sdl/i_system.h || die

	# Fix building with gcc-5
	use system-dumb || sed -i -e 's/ restrict/ _restrict/g' dumb/include/dumb.h dumb/src/it/*.c || die

	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DFORCE_INTERNAL_GME="OFF"
		-DNO_ASM="$(usex cpu_flags_x86_mmx OFF ON)"
		-DNO_GTK="$(usex gtk OFF ON)"
		-DBUILD_SHARED_LIBS=OFF
	)

	# Can't build both client and server at once... so separate them
	if use opengl; then
		BUILD_DIR="${WORKDIR}/${P}_client"
		cmake_src_configure
	fi
	if use dedicated; then
		BUILD_DIR="${WORKDIR}/${P}_server"
		mycmakeargs+=(-DSERVERONLY=1)
		cmake_src_configure
	fi
}

src_compile() {
	if use opengl; then
		BUILD_DIR="${WORKDIR}/${P}_client"
		cmake_build
	fi
	if use dedicated; then
		BUILD_DIR="${WORKDIR}/${P}_server"
		cmake_build
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
	# install here to avoid collisions with games-fps/gzdoom
	# hacky, i know. should've listened to juippis :) please don't hit me.
	# note: brightmaps.pk3 NEEDS TO KEEP ITS NAME to not break online play
	# on servers that mistakenly add it as a required pwad.
	cp -n "${BUILD_DIR}/brightmaps.pk3" "${EPREFIX}/usr/share/doom/"

        ewarn "For parity with the gzdoom ebuild, the data path has been changed yet again!"
        ewarn "It is ${EPREFIX}/usr/share/doom - copy/link wad files there or in \$HOME/.config/zandronum"
        ewarn "If after an upgrade the game complains about not finding zandronum.pk3,"
        ewarn "edit the [*Search.Directories] sections in \$HOME/.config/zandronum/zandronum.ini."

	if use opengl; then
		elog
		elog "To play online, install games-util/doomseeker"
	fi
}
