# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2 meson vala

DESCRIPTION="A simple font management application for Gtk+ Desktop Environments"
HOMEPAGE="https://fontmanager.github.io"
SRC_URI="https://github.com/FontManager/font-manager/archive/${PV}.tar.gz -> ${P}.tar.gz"

VALA_MIN_API_VERSION=0.44
VALA_USE_DEPEND="vapigen"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gnome-search-provider google-fonts +manager nemo reproducible thunar +viewer +nls"

RDEPEND="gnome-base/gnome-common
	>=dev-db/sqlite-3.8
	>=dev-libs/json-glib-0.15
	>=dev-libs/libxml2-2.9
	>=media-libs/fontconfig-2.1
	>=media-libs/freetype-2.5
	>=x11-libs/gtk+-3.22
	>=x11-libs/pango-1.4
	google-fonts? (
		>=net-libs/libsoup-2.62
		>=net-libs/webkit-gtk-2.24
	)
	nemo? ( gnome-extra/nemo )
	thunar? ( xfce-base/thunar )
"

DEPEND="${RDEPEND}
	$(vala_depend)
	doc? (
		app-text/yelp-tools
		dev-util/gtk-doc
	)
"

src_prepare() {
	default
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# https://forums.gentoo.org/viewtopic-p-7080966.html
	export VALAC="$(type -P valac-0.56)"
	export VAPIGEN="$(type -P vapigen-0.56)"

	meson_src_configure \
		$(meson_use manager) \
		$(meson_use viewer) \
		$(meson_use reproducible) \
		$(meson_use nemo) \
		$(meson_use thunar) \
		$(meson_use gnome-search-provider search-provider) \
		$(meson_use google-fonts webkit) \
		$(meson_use nls enable-nls) \
		$(meson_use doc yelp-doc) \
		$(meson_use doc gtk-doc) \
		--buildtype=release
}
