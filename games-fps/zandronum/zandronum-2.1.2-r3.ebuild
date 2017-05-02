# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils

OWNER="Torr_Samaho"
MY_COMMIT="ZA_2.1.2" #tags work too

DESCRIPTION="OpenGL ZDoom port with Client/Server multiplayer"
HOMEPAGE="http://zandronum.com/"
SRC_URI="https://bitbucket.org/${OWNER}/${PN}-stable/get/${MY_COMMIT}.tar.bz2 -> ${P}.tar.bz2
	https://bitbucket.org/api/1.0/repositories/${OWNER}/${PN}-stable/changesets/${MY_COMMIT}?format=yaml -> ${P}.metadata
"

LICENSE="Sleepycat"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_mmx cpu_flags_x86_sse2 dedicated +gtk opengl timidity"

REQUIRED_USE="|| ( dedicated opengl )
	gtk? ( opengl )
	timidity? ( opengl )"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	timidity? ( media-sound/timidity++ )
	opengl? ( media-libs/fmod:1
		media-libs/libsdl
		virtual/glu
		virtual/jpeg:62
		virtual/opengl
	)
	dev-db/sqlite
	dev-libs/openssl:0"

DEPEND="${RDEPEND}
	cpu_flags_x86_mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )"

src_unpack() {
	default
	S="$(ls -d "${WORKDIR}/${OWNER}-${PN}"-*)"
}

src_prepare() {
	# Normally Mercurial would generate gitinfo.h for NETGAMEVERSION
	# let's do it without Mercurial
	local timestamp=$(awk -F\' '/utctimestamp/{print $2}' "${DISTDIR}/${P}.metadata")
	local unixtimestamp=$(date +%s -d "${timestamp}")
	echo "#define SVN_REVISION_NUMBER ${unixtimestamp}" > src/gitinfo.h
	echo "#define SVN_REVISION_STRING \"0\"" >> src/gitinfo.h
	echo "#define HG_REVISION_HASH_STRING \"0\"" >> src/gitinfo.h

	# Use the system sqlite
	sed -i -e "/add_subdirectory( sqlite )/d" CMakeLists.txt

	# Use default data path
	sed -i -e "s:/usr/local/share/:/usr/share/doom-data/:" src/sdl/i_system.h

	# Make compatible with newer fmod
	epatch "${FILESDIR}/${PN}-fix-new-fmod.patch"
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_no cpu_flags_x86_mmx ASM)
		$(cmake-utils_use cpu_flags_x86_sse2 SSE)
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
	insinto "/usr/share/doom-data"
	doins *.pk3

	if use opengl; then
		dobin "${WORKDIR}/${P}_client/${PN}"
		doicon "${S}/src/win32/zandronum.ico"
		make_desktop_entry "${PN}" "Zandronum" "${PN}.ico" "Game;ActionGame;"
	fi
	if use dedicated; then
		dobin "${WORKDIR}/${P}_server/${PN}-server"
	fi
}

pkg_postinst() {
	elog "Copy or link wad files into /usr/share/doom-data/"
	elog "ATTENTION: The path has changed! It used to be /usr/share/games/doom-data/"
	elog
	if use opengl; then
		elog "To play, install games-util/doomseeker or simply run:"
		elog "   zandronum"
		elog
	fi
	elog "See /usr/share/doc/${P}/zdoom.txt.* for more info"
}
