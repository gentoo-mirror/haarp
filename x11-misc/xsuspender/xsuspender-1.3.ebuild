# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Automatically suspend inactive X11 applications"
HOMEPAGE="https://kernc.github.io/xsuspender/"
SRC_URI="https://github.com/kernc/${PN}/archive/refs/tags/${PV}.tar.gz -> $P.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-libs/glib
	sys-process/procps
	x11-libs/libwnck
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "s:PROJECT_VERSION 1.1:PROJECT_VERSION $PV:" CMakeLists.txt
	sed -i -e 's:example_dir "share/doc/${PROJECT_NAME}/examples":example_dir "share/doc/${PROJECT_NAME}-${PROJECT_VERSION}/examples":' CMakeLists.txt
	eapply_user
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
	)
	cmake_src_configure
}
