# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# cargo breaks with FEATURES=network-sandbox, please keep it disabled.

EAPI=6

inherit eutils cargo git-r3

DESCRIPTION="GPU-accelerated terminal emulator, fork with scrollback support"
HOMEPAGE="https://github.com/jwilm/alacritty"
EGIT_REPO_URI="https://github.com/neon64/alacritty"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# =dev-lang/rust-1.15.0 triggers https://github.com/jwilm/alacritty/issues/788
# use a known good version (1.19.0) instead
RDEPEND="media-libs/fontconfig"
DEPEND="${RDEPEND}
	>=virtual/rust-1.19.0"

src_prepare() {
	epatch ${FILESDIR}/support-bitmap-fonts.patch
	eapply_user
}

src_install() {
	cargo_src_install
	domenu Alacritty.desktop
	dodoc README.md alacritty.yml
}
