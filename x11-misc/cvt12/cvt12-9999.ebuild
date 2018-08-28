# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="CVT (Coordinated Video Timings) modeline calculator with CVT v1.2 timings"
HOMEPAGE="https://github.com/kevinlekiller/cvt_modeline_calculator_12"
EGIT_REPO_URI="https://github.com/kevinlekiller/cvt_modeline_calculator_12.git"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=${RDEPEND}

src_compile() {
	echo "$(tc-getCC) ${LDFLAGS} ${CFLAGS} -Wall -o cvt12 cvt12.c -lm"
	$(tc-getCC) ${LDFLAGS} ${CFLAGS} -Wall -o cvt12 cvt12.c -lm || die "compile failed"
}

src_install() {
	dobin cvt12
}
