# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

BASE=apcupsd-3.14.8

DESCRIPTION="Linux GUI monitor for APCUPSD"
HOMEPAGE="http://gapcmon.sourceforge.net/"
SRC_URI="mirror://sourceforge/apcupsd/$BASE.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6
         >=dev-libs/glib-2.8
         >=gnome-base/gconf-2.10
         !sys-power/apcupsd[gnome]"

S="$WORKDIR/$BASE"

src_configure() {
	econf --enable-gapcmon
}

src_compile() {
	S="$WORKDIR/$BASE/src/gapcmon"
	emake
}

src_install() {
	S="$WORKDIR/$BASE/src/gapcmon"
	emake DESTDIR="${D}" install-gapcmon
	dodoc ChangeLog README
}
