# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop git-r3 xdg

DESCRIPTION="Measure objects on your desktop using six different metrics"
HOMEPAGE="https://salsa.debian.org/georgesk/screenruler"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
EGIT_REPO_URI="https://salsa.debian.org/georgesk/screenruler.git"

RDEPEND="dev-ruby/ruby-gettext
	dev-ruby/ruby-gtk3"

pkg_postinst() {
	xdg_desktop_database_update

	elog "If the app starts to a blank window,"
	elog "right-click on it and play around with the DPI settings"
}
pkg_postrm() {
	xdg_desktop_database_update
}
