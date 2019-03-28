# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Simple application to manage Xfce panel layouts"
HOMEPAGE="https://launchpad.net/xfpanel-switch"
SRC_URI="https://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/python
	dev-python/pygobject"
DEPEND="${DEPEND}
	dev-util/intltool"

src_configure() {
	./configure --prefix=/usr
}
