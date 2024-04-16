# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop git-r3

DESCRIPTION="A challenging 2D construction game"
HOMEPAGE="https://bielebridge.net/"
EGIT_REPO_URI="https://gitlab.digitalcourage.de/georg/bielebridge.git"

EGIT_COMMIT="78427b6b"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="amd64"

IUSE=""

RDEPEND="
	dev-lang/lua
	media-libs/libsdl2
	media-libs/sdl2-gfx
	media-libs/sdl2-image
	media-libs/sdl2-ttf
"

DEPEND="${RDEPEND}"

DOCS=( AUTHORS Changelog README )

src_configure() {
	eautoreconf
	default
}

src_install() {
	default
	make_desktop_entry "${PN}" "Bielebridge"
}
