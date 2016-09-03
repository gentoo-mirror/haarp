# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="Modern graphical system monitor for XFCE/MATE/LXDE, forked from GNOME multiload applet"
HOMEPAGE="https://udda.github.io/multiload-ng/"
SRC_URI="https://github.com/udda/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="indicator lxpanel mate standalone +xfce_plugins_multiload-ng"

RDEPEND=">=x11-libs/gtk+-2.14:2
	x11-libs/cairo
	>=gnome-base/libgtop-2.11.92
	lxpanel? ( lxde-base/lxpanel )
	mate? ( mate-base/mate-panel )
	xfce_plugins_multiload-ng? (
		>=xfce-base/libxfce4ui-4.10
		>=xfce-base/libxfce4util-4.10
		>=xfce-base/xfce4-panel-4.10
	)"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

REQUIRED_USE="|| ( mate lxpanel standalone xfce_plugins_multiload-ng )"

DOCS="AUTHORS README.md"

S=${WORKDIR}/${P}

src_prepare() {
	eautoreconf
}

src_configure() {
	# FIXME: currently configured for gtk2 only
	econf \
		--with-gtk=2.0 \
		$(use_with indicator) \
		$(use_with lxpanel) \
		$(use_with mate) \
		$(use_with standalone) \
		$(use_with xfce_plugins_multiload-ng xfce4)
}

src_install() {
	default
	prune_libtool_files --all
}
