# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit linux-info

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
	cp "${KERNEL_DIR}/tools/power/x86/turbostat"/* "${S}/" || die "turbostat not found in kernel sources!"
	cd "${S}"
}

src_prepare() {
	ewarn "This ebuild grabs ${PN} from your active kernel's sources!"
	ewarn "In case of build failures (e.g. undeclared defines), try upgrading"
	ewarn "sys-kernel/linux-headers to more closely match your kernel version"
	sed -i -e 's:../../../../arch/x86/include/uapi/asm/msr-index.h:asm/msr-index.h:' Makefile
}
