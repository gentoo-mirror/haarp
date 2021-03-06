# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils desktop xdg

DESCRIPTION="A modder-friendly OpenGL source port based on the DOOM engine"
HOMEPAGE="https://zdoom.org"
SRC_URI="https://github.com/coelckers/${PN}/archive/g${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD BZIP2 DUMB-0.9.3 GPL-3 LGPL-3 MIT
	nonfree? ( Activision ChexQuest3 DOOM-COLLECTORS-EDITION freedist )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk gtk2 +nonfree openmp"

DEPEND="media-libs/libsdl2[opengl]
	media-libs/libsndfile
	media-libs/openal
	media-sound/fluidsynth:=
	media-sound/mpg123
	sys-libs/zlib
	virtual/jpeg:0
	gtk? (
		gtk2? ( x11-libs/gtk+:2 )
		!gtk2? ( x11-libs/gtk+:3 )
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-g${PV}"
PATCHES=(
##	"${FILESDIR}/fluidsynth2.patch"
	"${FILESDIR}/install_soundfonts.patch"
	"${FILESDIR}/Introduce-the-BUILD_NONFREE-option.patch"
)

src_prepare() {
	rm -rf docs/licenses || die
	if ! use nonfree ; then
		rm -rf wadsrc_bm wadsrc_extra || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_DOCS_PATH="${EPREFIX}/usr/share/doc/${PF}"
		-DINSTALL_PK3_PATH="${EPREFIX}/usr/share/doom"
		-DINSTALL_SOUNDFONT_PATH="${EPREFIX}/usr/share/doom"
		-DDYN_FLUIDSYNTH=OFF
		-DDYN_OPENAL=OFF
		-DDYN_SNDFILE=OFF
		-DDYN_MPG123=OFF
		-DNO_GTK="$(usex !gtk)"
		-DNO_OPENAL=OFF
		-DNO_OPENMP="$(usex !openmp)"
		-DBUILD_NONFREE="$(usex nonfree)"
	)
	cmake-utils_src_configure
}

src_install() {
	newicon src/posix/zdoom.xpm "${PN}.xpm"
	make_desktop_entry "${PN}" "GZDoom" "${PN}" "Game;ActionGame"
	cmake-utils_src_install

	# don't install this now
	if use nonfree ; then
		rm "${D}/usr/share/doom/brightmaps.pk3"
	fi
}

pkg_postinst() {
	# install here to avoid collisions with games-fps/zandronum
	# hacky, i know. should've listened to juippis :) please don't hit me.
	if use nonfree ; then
		cp -n "${BUILD_DIR}/brightmaps.pk3" "${EPREFIX}/usr/share/doom/" || die
	fi

	xdg_pkg_postinst

	ewarn "For parity with the Gentoo ebuild, the data path has been changed yet again!"
	ewarn "It is ${EPREFIX}/usr/share/doom - copy/link wad files there or in \$HOME/.config/gzdoom"
	ewarn "If after an upgrade the game complains about not finding gzdoom.pk3,"
	ewarn "edit the [*Search.Directories] sections in \$HOME/.config/gzdoom/gzdoom.ini."
	elog
	elog "Starting with GZDoom 3.3.0, TiMidity++ is an internal MIDI player."
	elog "Unfortunately, it does not support system soundfonts directly."
	elog "To make them selectable, add /usr/share/timidity/<foo>/* to a zip archive and"
	elog "place it into ${EPREFIX}/usr/share/doom/soundfonts/ or \$HOME/.config/gzdoom/soundfonts/"
	if ! use nonfree ; then
		ewarn
		ewarn "GZDoom installed without nonfree components."
		ewarn "Note: The nonfree game_support.pk3 file is needed to play"
		ewarn "      games natively supported by GZDoom."
		ewarn "A list of games natively supported by GZDoom may be found"
		ewarn "on the ZDoom wiki: https://zdoom.org/wiki/IWAD"
		ewarn
	fi
}
