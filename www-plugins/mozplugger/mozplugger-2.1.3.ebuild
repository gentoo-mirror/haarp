# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WANT_AUTOMAKE=none
inherit eutils multilib toolchain-funcs flag-o-matic autotools

DESCRIPTION="Configurable browser plugin to launch streaming media players."
SRC_URI="http://mozplugger.mozdev.org/files/${P}.tar.gz"
HOMEPAGE="http://mozplugger.mozdev.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="xembed"

DEPEND="x11-libs/libX11
	sys-devel/m4"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.1.3-build-system.patch"
	epatch "${FILESDIR}/${PN}-2.1.3-rd_chld_fd.patch"
	eautoconf
}

src_configure() {
	append-flags -Wa,--noexecstack
	append-ldflags -Wl,-z,noexecstack

	econf $(use_enable xembed always-xembed)
}

src_compile() {
	emake all || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README || die "dodoc failed"
}
