# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python3_{4,5} )

inherit autotools eutils gnome2 multilib python-single-r1

DESCRIPTION="X-Apps [Text] Editor (Cross-DE, backward-compatible, GTK3, traditional UI)"
HOMEPAGE="https://github.com/linuxmint/xed"
SRC_URI="https://github.com/linuxmint/xed/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"

IUSE="+python spell test"
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

	x11-libs/xapps
	x11-libs/libX11
	net-libs/libsoup:2.4

	python? (
		${PYTHON_DEPS}
		dev-python/pycairo[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}]
		dev-libs/libpeas[${PYTHON_USEDEP}] )
	spell? (
		>=app-text/enchant-1.2:=
		>=app-text/iso-codes-0.35 )
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
eautoreconf
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	gnome2_src_configure \
		--enable-gvfs-metadata \
		$(use_enable spell)
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die
	GSETTINGS_SCHEMA_DIR="${S}/data" Xemake check
}

src_install() {
	gnome2_src_install
}
