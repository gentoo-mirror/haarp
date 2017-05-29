# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="Modern graphical system monitor for XFCE/MATE/LXDE (GNOME applet fork)"
HOMEPAGE="https://udda.github.io/multiload-ng/"
SRC_URI="https://github.com/udda/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="autostart awn debug gtk2 +gtk3 indicator lxde mate +standalone systray xfce"

LANGS="de es fr it lt ru zh_CN"
for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

RDEPEND="
	gtk2? ( >=x11-libs/gtk+-2.20:2 )
	gtk3? ( x11-libs/gtk+:3 )
	x11-libs/cairo:=
	awn? (
		>=gnome-extra/avant-window-navigator-0.3.9
		>=dev-cpp/glibmm-2.16.0:2
		>=dev-cpp/gtkmm-2.20:2.4
	)
	indicator? (
		gtk2? ( >=dev-libs/libappindicator-0.4.92:2 )
		gtk3? ( >=dev-libs/libappindicator-0.4.92:3 )
	)
	lxde? (
		>=lxde-base/lxpanel-0.5.8
	)
	mate? (
		gtk2? ( >=mate-base/mate-panel-1.7.0 )
		gtk3? ( >=mate-base/mate-panel-1.7.0[gtk3(-)] )
	)
	xfce? (
		gtk2? (
			>=xfce-base/libxfce4util-4.6.0
			>=xfce-base/xfce4-panel-4.6.0
		)
		gtk3? (
			>=xfce-base/libxfce4util-4.12.0
			>=xfce-base/xfce4-panel-4.12.0
		)
	)"

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

REQUIRED_USE="
	^^ ( gtk2 gtk3 )
	|| ( awn indicator lxde mate standalone systray xfce )
	awn? ( gtk2 )"

DOCS=( AUTHORS Changelog.md CONTRIBUTING.md README.md )

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	if use gtk2; then
		GTK_CONF="--with-gtk=2.0"
	else
		GTK_CONF="--with-gtk=3.0 --disable-deprecations"
	fi
	econf \
		$(use_enable debug) \
		$(use_enable autostart) \
		$GTK_CONF \
		$(use_with standalone) \
		$(use_with awn) \
		$(use_with indicator) \
		$(use_with lxde lxpanel) \
		$(use_with mate) \
		$(use_with systray) \
		$(use_with xfce xfce4)
}
