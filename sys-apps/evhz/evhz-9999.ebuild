# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 toolchain-funcs

DESCRIPTION="Show mouse refresh rate under evdev"
HOMEPAGE="https://git.sr.ht/~iank/evhz"
EGIT_REPO_URI="https://git.sr.ht/~iank/evhz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_compile() {
	"$(tc-getCC)" ${CFLAGS} ${LDFLAGS} -o evhz evhz.c || die "gcc failed"
}

src_install() {
	einstalldocs
	dobin evhz
}
