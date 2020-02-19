# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib git-r3

DESCRIPTION="Hack to disable GTK+-3 client-side decorations"
HOMEPAGE="https://github.com/PCMan/gtk3-nocsd"

EGIT_REPO_URI="https://github.com/PCMan/gtk3-nocsd.git"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""
LICENSE="GPL-2"

DEPEND="x11-libs/gtk+:3"
RDEPEND="${DEPEND}"

src_install() {
	# maybe also consider /debian/extra from Ubuntu pkg like the Unity overlay ebuild?

	emake prefix="${D}/usr" libdir="${D}/usr/$(get_libdir)" install

	einfo "Add to your ~/.profile and re-login:"
	einfo "    export GTK_CSD=0"
	einfo "    export LD_PRELOAD=\"${EROOT%/}/usr/$(get_libdir)/libgtk3-nocsd.so.0 \$LD_PRELOAD\""
	einfo "Or prefix your commands with:"
	einfo "    gtk3-nocsd"
}
