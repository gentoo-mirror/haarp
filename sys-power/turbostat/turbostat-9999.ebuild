# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Report processor frequency and idle statistics"
HOMEPAGE="http://lwn.net/Articles/433002/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/glibc"
DEPEND="${DEPEND}
	>=sys-kernel/gentoo-sources-2.6.36"

src_unpack() {
	mkdir -p "${S}"
	cp /usr/src/linux/tools/power/x86/turbostat/* "${S}/" || die "turbostat not found in kernel sources!"
	cd "${S}"
}

src_prepare() {
	sed -i -e 's:../../../../arch/x86/include/uapi/asm/msr-index.h:asm/msr-index.h:' Makefile
}
