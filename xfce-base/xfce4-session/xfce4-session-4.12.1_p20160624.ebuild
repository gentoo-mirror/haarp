# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EAUTORECONF=1
inherit git-2 xfconf

DESCRIPTION="A session manager for the Xfce desktop environment"
HOMEPAGE="http://docs.xfce.org/xfce/xfce4-session/start"
SRC_URI=""
EGIT_REPO_URI="git://git.xfce.org/xfce/xfce4-session"
EGIT_COMMIT="16dd17c2e2903d2b2f46a38701deb55c8a89340c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug nls policykit systemd +xscreensaver"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.100:=
	x11-apps/iceauth
	x11-libs/libSM:=
	>=x11-libs/libwnck-3.10
	x11-libs/libX11:=
	>=xfce-base/libxfce4util-4.12:=
	>=xfce-base/libxfce4ui-4.12.1:=
	>=xfce-base/xfconf-4.12:=
	!xfce-base/xfce-utils
	!=xfce-base/libxfce4ui-4.12.0
	>=x11-libs/gtk+-3.10:3=
	policykit? ( >=sys-auth/polkit-0.102:= )"
RDEPEND="${COMMON_DEPEND}
	x11-apps/xrdb
	nls? ( x11-misc/xdg-user-dirs )
	xscreensaver? ( || (
		>=x11-misc/xscreensaver-5.26
		x11-misc/light-locker
		>=x11-misc/xlockmore-5.43
		x11-misc/slock
		x11-misc/alock[pam]
		) )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

REQUIRED_USE="systemd? ( policykit )"

pkg_setup() {
	PATCHES=(
			"${FILESDIR}"/${PN}-4.10.1-alock_support_to_xflock4.patch
		)

	# maintainer-mode is necessary for engines/mice/preview.h to get built (??)
	XFCONF=(
		--enable-maintainer-mode
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable policykit polkit)
		--with-xsession-prefix="${EPREFIX}"/usr
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS BUGS NEWS README TODO )
}

src_install() {
	xfconf_src_install

	local sessiondir=/etc/X11/Sessions
	echo startxfce4 > "${T}"/Xfce4
	exeinto ${sessiondir}
	doexe "${T}"/Xfce4
	dosym Xfce4 ${sessiondir}/Xfce
}
