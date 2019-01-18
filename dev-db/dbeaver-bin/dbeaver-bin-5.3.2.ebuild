# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
DESCRIPTION="Free universal database tool and SQL client"
HOMEPAGE="http://dbeaver.io/"
SRC_URI="http://dbeaver.io/files/${PV}/dbeaver-ce-${PV}-linux.gtk.x86_64.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND=">=virtual/jre-1.7:* >=x11-libs/gtk+-2:2"
RDEPEND="${DEPEND}"
S="${WORKDIR}/dbeaver"

src_install() {
	sed -i "s:/usr/share/dbeaver/:/opt/${P}/:" dbeaver.desktop
	insinto "/opt/${P}"
	exeinto "/opt/${P}"
	doins -r \
		"configuration" \
		"dbeaver.desktop" \
		"dbeaver.ini" \
		"dbeaver.png" \
		"features" \
		"icon.xpm" \
		"licenses" \
		"p2" \
		"plugins" \
		"readme.txt"
	doexe "dbeaver"
	dosym "/opt/${P}/dbeaver" "/usr/bin/dbeaver"
	dosym "/opt/${P}/dbeaver.desktop" "/usr/share/applications/dbeaver.desktop"
}
