# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Side-scrolling platformer written by StudioPixel"
HOMEPAGE="http://www.cavestory.org"
#SRC_URI="http://www.scibotic.com/uploads/2008/04/linuxdoukutsu-${PV}.tar.bz2"
SRC_URI="http://www.archive.org/download/CavestorydoukutsuForLinuxV1.01/linuxdoukutsu-1.01.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="strip"

RDEPEND="media-libs/libsdl[X]"

S=${WORKDIR}/linuxDoukutsu-${PV}

src_install() {
	insinto /usr/share/${PN}
	doins -r data DoConfig.exe
	dodoc doc/*

	exeinto /usr/share/${PN}
	doexe doukutsu.bin
	echo "cd /usr/share/${PN} && ./doukutsu.bin" > doukutsu || die "couldn't create wrapper?!"
	dobin doukutsu

	mv Config.dat doukutsu_Config.dat
	touch doukutsu_Profile.dat || die "couldn't create empty Profile.dat?"
	insinto /var/lib
	insopts -m 666
	doins doukutsu_Config.dat doukutsu_Profile.dat
	dosym /var/lib/doukutsu_Config.dat /usr/share/${PN}/Config.dat
	dosym /var/lib/doukutsu_Profile.dat /usr/share/${PN}/Profile.dat
}

pkg_postinst() {
	elog "This port does not provide a configuration tool for Config.dat."
	elog "The original DoConfig.exe is provided (if you can use wine),"
	elog "or help for configuring it manually is provided in:"
	elog "/usr/share/doc/${P}/configfileformat.txt"
	elog ""
	elog "If you need to back up your save file for any reason,"
	elog "it is located at /var/lib/doukutsu_Profile.dat"
}
