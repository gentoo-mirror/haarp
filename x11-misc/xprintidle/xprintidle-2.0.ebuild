# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Prints user's X server idle time in milliseconds"
HOMEPAGE="https://github.com/lucianposton/xprintidle"
EGIT_REPO_URI="https://github.com/lucianposton/xprintidle.git"
EGIT_COMMIT="v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXScrnSaver
	"
RDEPEND="${DEPEND}"
