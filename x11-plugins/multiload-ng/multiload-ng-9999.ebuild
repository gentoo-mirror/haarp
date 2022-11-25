# Copyright 1999-2022 Gentoo authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools git-r3

DESCRIPTION="Modern graphical system monitor for any panel"
HOMEPAGE="https://udda.github.io/multiload-ng/"
EGIT_REPO_URI="https://github.com/udda/multiload-ng.git"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="autostart awn debug indicator lxde mate +standalone systray xfce"

LANGS="de es fr it lt ru zh_CN"
IUSE="${IUSE} ${LANGS// / linguas_}"

RDEPEND="
	x11-libs/gtk+:3
	x11-libs/cairo:=
	indicator? ( >=dev-libs/libappindicator-0.4.92:3 )
	lxde? ( >=lxde-base/lxpanel-0.5.8 )
	mate? ( >=mate-base/mate-panel-1.7.0 )
	xfce? (
		>=xfce-base/libxfce4util-4.12.0
		>=xfce-base/xfce4-panel-4.12.0
	)"

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

REQUIRED_USE="|| ( indicator lxde mate standalone systray xfce )"

DOCS=( AUTHORS Changelog.md CONTRIBUTING.md README.md )

src_prepare() {
	eapply "${FILESDIR}/fix-sysfs-nvme-dm.patch"
	eapply_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable autostart) \
		$GTK_CONF \
		$(use_with standalone) \
		$(use_with indicator) \
		$(use_with lxde lxpanel) \
		$(use_with mate) \
		$(use_with systray) \
		$(use_with xfce xfce4)\
		--with-gtk=3.0 --disable-deprecations
}
