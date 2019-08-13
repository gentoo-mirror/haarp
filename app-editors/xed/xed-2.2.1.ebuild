# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python3_{5,6} )

inherit eutils gnome2 meson multilib python-single-r1

DESCRIPTION="X-Apps [Text] Editor (Cross-DE, backward-compatible, GTK3, traditional UI)"
HOMEPAGE="https://github.com/linuxmint/xed"
SRC_URI="https://github.com/linuxmint/xed/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"

IUSE="doc +python spell test"
# python-single-r1 would request disabling PYTHON_TARGETS on libpeas
# we need to fix that
REQUIRED_USE="python? ( ^^ ( $(python_gen_useflags '*') ) )"

KEYWORDS="~amd64 ~x86"

# X libs are not needed for OSX (aqua)
COMMON_DEPEND="
	>=dev-libs/libxml2-2.5.0:2
	>=dev-libs/glib-2.44:2[dbus]
	>=x11-libs/gtk+-3.16:3[introspection]
	>=x11-libs/gtksourceview-3.18:3.0[introspection]
	>=dev-libs/libpeas-1.14.1[gtk]

	gnome-base/gsettings-desktop-schemas
	gnome-base/gvfs

	>=x11-libs/xapps-1.2.2
	x11-libs/libX11
	net-libs/libsoup:2.4

	python? (
		${PYTHON_DEPS}
		dev-python/pycairo[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}]
		dev-libs/libpeas[${PYTHON_USEDEP}] )

	spell? (
		app-text/gspell )
"

RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"

DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools
	dev-libs/libxml2:2
	>=dev-util/gtk-doc-am-1
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

# yelp-tools, gnome-common needed to eautoreconf

pkg_setup() {
	use python && [[ ${MERGE_TYPE} != binary ]] && python_setup
}

src_prepare() {
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS HACKING NEWS.GEDIT NEWS.PLUMA README debian/changelog"

	local emesonargs=(
		-Denable_gvfs_metadata=true
		$(meson_use doc docs)
		$(meson_use spell enable_spell)
	)

	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_test() {
	meson_src_test
}

src_install() {
	meson_src_install
}