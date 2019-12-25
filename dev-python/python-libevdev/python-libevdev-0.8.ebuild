# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )

inherit distutils-r1 git-r3

DESCRIPTION="Python wrappers for the libevdev library"
HOMEPAGE="https://python-libevdev.readthedocs.org/"
EGIT_REPO_URI="https://gitlab.freedesktop.org/libevdev/python-libevdev.git"
EGIT_COMMIT="0.8"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libevdev"
