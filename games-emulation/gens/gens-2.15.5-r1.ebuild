# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

#TODO:
#	fix lib paths ( https://forums.gentoo.org/viewtopic-t-956496-start-0.html )
#	proper 32bit multi(single)lib?
#	replace with gens-gs?
EAPI=2
inherit eutils flag-o-matic games

DESCRIPTION="A Sega Genesis/CD/32X emulator"
HOMEPAGE="http://sourceforge.net/projects/gens/"
SRC_URI="mirror://sourceforge/gens/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

RDEPEND="virtual/opengl
	>=media-libs/libsdl-1.2[joystick,video]
	x11-libs/gtk+:2
	amd64? ( app-emulation/emul-linux-x86-sdl
		 app-emulation/emul-linux-x86-gtklibs )"
DEPEND="${RDEPEND}
	>=dev-lang/nasm-0.98"

src_prepare() {
	epatch "${FILESDIR}"/${P}-romsdir.patch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-ovflfix.patch
	sed -i -e '1i#define OF(x) x' src/gens/util/file/unzip.h || die
	append-ldflags -Wl,-z,noexecstack
}

src_configure() {
	use amd64 && CFLAGS="$CFLAGS -m32"

	base_src_configure
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS README gens.txt history.txt
	prepgamesdirs
	make_desktop_entry "${PN}" "Gens" "/usr/share/games/gens/Gens2.ico" "Game;Emulator;"
}
