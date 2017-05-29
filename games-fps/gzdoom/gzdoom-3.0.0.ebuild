# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="A 3D-accelerated Doom source port based on ZDoom code"
HOMEPAGE="https://gzdoom.drdteam.org/"
SRC_URI="https://zdoom.org/files/gzdoom/src/${PN}-g${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fluidsynth +gtk3 timidity"

RDEPEND="fluidsynth? ( media-sound/fluidsynth )
	gtk3? ( x11-libs/gtk+:3 )
	timidity? ( media-sound/timidity++ )
	media-libs/libsdl2
	virtual/glu
	virtual/jpeg:62
	virtual/opengl"

DEPEND="${RDEPEND}
	|| ( dev-lang/nasm dev-lang/yasm )"

S="${WORKDIR}/${PN}-g${PV}"

src_prepare() {
	# Use default data path
	sed -i -e "s:/usr/local/share/:/usr/share/doom-data/:" src/posix/i_system.h
	sed -i -e '/SetValueForKey ("Path", "\/usr\/share\/games\/doom", true);/ a \\t\tSetValueForKey ("Path", "/usr/share/doom-data", true);' \
		src/gameconfigfile.cpp
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_no gtk3 GTK)
	)

	cmake-utils_src_configure
}

src_install() {
	dodoc docs/*.txt
	dohtml docs/console*.{css,html}

	newicon "src/win32/icon1.ico" "${PN}.ico"
	make_desktop_entry "${PN}" "GZDoom" "${PN}.ico" "Game;ActionGame;"

	cd "${BUILD_DIR}"

	insinto "/usr/share/doom-data"
	doins *.pk3

	dobin "${PN}"
}

pkg_postinst() {
	elog "Copy or link wad files into /usr/share/doom-data/"
	elog "ATTENTION: The path has changed! It used to be /usr/share/games/doom-data/"
	elog
	elog "To play, simply run:"
	elog "   gzdoom"
	elog
}