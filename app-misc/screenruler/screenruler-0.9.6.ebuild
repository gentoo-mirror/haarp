# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Measure objects on your desktop using six different metrics"
HOMEPAGE="http://gnomecoder.wordpress.com/screenruler/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

RDEPEND="dev-lang/ruby
	dev-ruby/ruby-gettext
	dev-ruby/ruby-gtk2"

S="${WORKDIR}/screenruler"

src_prepare() {
	eapply_user

	sed -i -e "/\$LOAD_PATH << '.\/utils'/a\$LOAD_PATH << '.'" screenruler.rb
}

# There is no installation mechanism, so just put everything in the right place
src_install() {
	make_desktop_entry screenruler "Screen Ruler" screenruler "Utility;GTK;"

	cd "${S}"

	insinto /usr/share/${PN}
	doins *.rb
	doins *.glade
	doins *.png
	insinto /usr/share/${PN}/utils
	doins utils/*

	exeinto /usr/share/${PN}
	doexe screenruler.rb

	dosym /usr/share/${PN}/screenruler.rb /usr/bin/screenruler
	dosym /usr/share/${PN}/screenruler-icon-64x64.png /usr/share/pixmaps/screenruler.png
}
