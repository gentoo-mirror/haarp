# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4
VALA_MIN_API_VERSION="0.14"

inherit autotools git-r3 vala

DESCRIPTION="An application which allows any application to be docked into the system notification area"
HOMEPAGE="http://alltray.trausch.us/"
EGIT_REPO_URI="https://github.com/mbt/alltray.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	gnome-base/libgtop:2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libwnck:1"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog HACKING NEWS README )

src_prepare() {
	sed -i -e 's:-DG.*DISABLE_DEPRECATED::' src/Makefile.am || die #391101

	sed -i \
		-e '/Encoding/d' \
		-e '/Categories/s:Application;::' \
		-e '/Icon/s:.png::' \
		data/alltray.desktop.in || die

	vala_src_prepare
	sed -i -e '/AC_PATH_PROG/s:valac:${VALAC}:g' configure.ac || die

	epatch "$FILESDIR/clarify_glib_gtk_ambiguity.patch"

	eautoreconf
}
