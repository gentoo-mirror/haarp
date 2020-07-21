# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_7,3_8} )

##inherit python-r1
inherit distutils-r1

DESCRIPTION="Modern, minimal GUI app for libinput-gestures"
HOMEPAGE="https://gitlab.com/cunidev/gestures"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
SRC_URI="https://gitlab.com/cunidev/gestures/-/archive/${PV}/${P}.tar.bz2"

RDEPEND="dev-python/pygobject
	x11-misc/libinput-gestures"
