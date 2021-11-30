# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Pidgin libpurple bridge to signald"
HOMEPAGE="https://github.com/hoehermann/libpurple-signald"
EGIT_REPO_URI="https://github.com/hoehermann/libpurple-signald.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-im/pidgin
	dev-libs/json-glib"

RDEPEND="${DEPEND}"
