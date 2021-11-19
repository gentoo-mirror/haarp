# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit desktop

DESCRIPTION="Side-scrolling platformer written by StudioPixel, aka Cava Story"
HOMEPAGE="http://www.cavestory.org"
#SRC_URI="http://www.scibotic.com/uploads/2008/04/linuxdoukutsu-${PV}.tar.bz2"
SRC_URI="http://www.archive.org/download/CavestorydoukutsuForLinuxV1.01/linuxdoukutsu-1.01.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

QA_PREBUILT="*"

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

	dosym /var/lib/doukutsu_Config.dat /usr/share/${PN}/Config.dat
	dosym /var/lib/doukutsu_Profile.dat /usr/share/${PN}/Profile.dat

	make_desktop_entry doukutsu "Cave Story"
}

pkg_postinst() {
	# do this here so un/reinstalling won't destroy your config/save
	[[ -f /var/lib/doukutsu_Config.dat ]] || {
		cp "${S}"/Config.dat /var/lib/doukutsu_Config.dat
		chmod 666 /var/lib/doukutsu_Config.dat
	}
	[[ -f /var/lib/doukutsu_Profile.dat ]] || {
		touch /var/lib/doukutsu_Profile.dat
		chmod 666 /var/lib/doukutsu_Profile.dat
	}

	elog "This port does not provide a configuration tool for Config.dat."
	elog "For Wine users, /usr/share/${PN}/DoConfig.exe should do the job."
	elog "otherwise, /usr/share/doc/${P}/configfileformat.txt may help."
	elog ""
	elog "If you need to back up your config/save file for any reason,"
	elog "it is located at /var/lib/doukutsu_{Config,Profile}.dat"
	elog "Please be aware that every user can read/write these files."
}
