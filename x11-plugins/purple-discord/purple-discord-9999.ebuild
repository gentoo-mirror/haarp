# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Pidgin/Purple Protocol Plugin for Discord"
HOMEPAGE="https://github.com/EionRobb/purple-discord"
EGIT_REPO_URI="https://github.com/EionRobb/purple-discord.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-gfx/imagemagick[jpeg,png,svg,xml]
	net-im/pidgin
	dev-libs/json-glib"

RDEPEND="${DEPEND}"
