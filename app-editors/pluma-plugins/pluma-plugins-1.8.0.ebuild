# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# FIXME: python plugins missing

EAPI=5

inherit gnome2

DESCRIPTION="Additional plugins for Pluma"
HOMEPAGE="https://github.com/yselkowitz/pluma-plugins"
SRC_URI="https://github.com/yselkowitz/pluma-plugins/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-editors/pluma"
DEPEND=${RDEPEND}

# shitty but works
src_configure() {
	./autogen.sh
}
