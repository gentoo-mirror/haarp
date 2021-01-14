# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit desktop git-r3

DESCRIPTION="Graphical manager for setting libinput-gestures touchpad gestures"
HOMEPAGE="https://github.com/RitwickVerma/Gesture-Manager-X"
EGIT_REPO_URI="https://github.com/RitwickVerma/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-3.18
	x11-misc/libinput-gestures"

src_prepare(){
	mv gesture-manager-x.desktop{.in,}

	eapply_user
}

src_install() {
	exeinto /usr/share/gesture-manager-x
	doexe main.py
	insinto /usr/share/gesture-manager-x
	doins *Helper.py *.glade icon.svg
	dodoc README.md
	domenu gesture-manager-x.desktop
	dosym /usr/share/gesture-manager-x/main.py /usr/bin/gesture-manager-x
}
