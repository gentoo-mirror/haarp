# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# cargo breaks with FEATURES=network-sandbox, please keep it disabled.

EAPI=6

inherit eutils cargo git-r3

DESCRIPTION="GPU-accelerated terminal emulator, fork with scrollback support"
HOMEPAGE="https://github.com/jwilm/alacritty"
EGIT_REPO_URI="https://github.com/neon64/alacritty"
EGIT_BRANCH="master"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# =dev-lang/rust-1.16.0 triggers https://github.com/jwilm/alacritty/issues/788
# use a known good version (1.19.0) instead.
# =dev-lang/rust-1.19.0 fails with "error: associated constants are experimental (see issue #29646)"
# use 1.20.0 instead.
RDEPEND="media-libs/fontconfig
	x11-misc/xclip"
DEPEND="media-libs/fontconfig
	>=dev-lang/rust-1.20.0"

src_prepare() {
##	epatch ${FILESDIR}/support-bitmap-fonts.patch
	epatch ${FILESDIR}/mouse-select-entire-char.patch
	epatch ${FILESDIR}/shift-click-text-select.patch
	eapply_user
}

src_install() {
	cargo_src_install
	domenu Alacritty.desktop
	dodoc README.md alacritty.yml
}
