# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop

DESCRIPTION="Super Simple WM Independent Touchpad Gesture Daemon for libinput (forked version with new features)"
HOMEPAGE="https://github.com/osleg/gebaar-libinput-fork"
SRC_URI="https://github.com/osleg/gebaar-libinput-fork/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-cpp/cpptoml
	dev-libs/cxxopts
	dev-libs/libinput"
DEPEND=${RDEPEND}

S="${WORKDIR}/gebaar-libinput-fork-${PV}"

src_prepare() {
	cmake_src_prepare
}

src_install() {
	dobin ${S}_build/gebaard
	dodoc README.md
	domenu assets/gebaar-libinput.desktop
}
