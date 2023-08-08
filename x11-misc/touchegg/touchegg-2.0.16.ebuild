# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Linux multi-touch gesture recognizer"
HOMEPAGE="https://github.com/JoseExposito/touchegg"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/JoseExposito/touchegg.git"
else
	SRC_URI="https://github.com/JoseExposito/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gtk systemd"

RDEPEND="
	dev-libs/libinput
	dev-libs/pugixml
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXrandr
	x11-libs/libXi
	dev-libs/glib:2
	gtk? ( x11-libs/gtk+:3 )
	virtual/libudev
	systemd? ( sys-apps/systemd )
"

DEPEND="${RDEPEND}"

DOCS=( "README.md" )

src_configure() {
	local mycmakeargs=(
		-DAUTO_COLORS="$(usex gtk)"
		# https://github.com/JoseExposito/touchegg/issues/481
		-DUSE_SYSTEMD="$(usex systemd)"
	)

	cmake_src_configure
}

src_install() {
	default

	cmake_src_install

	use systemd && newinitd "${FILESDIR}"/touchegg.initd touchegg
}

pkg_postinst() {
	if use systemd; then
		elog "On update run: 'systemctl daemon-reload && systemctl restart touchegg'"
	else
		elog "Not using systemd; in addition to 'touchegg', you have to manually"
		elog "run 'touchegg --daemon' as root or an user in the 'input' group"
	fi
	elog "See https://github.com/JoseExposito/touchegg#configuration for config information"
}
