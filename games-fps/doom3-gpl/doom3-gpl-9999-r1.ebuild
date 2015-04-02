# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit scons-utils toolchain-funcs games git-2

DESCRIPTION="3rd installment of the classic iD 3D first-person shooter"
HOMEPAGE="https://github.com/TTimo/doom3.gpl"
EGIT_REPO_URI="git://github.com/TTimo/doom3.gpl.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug dedicated opengl"

REQUIRED_USE="|| ( dedicated opengl )"

RDEPEND="sys-libs/glibc
        amd64? ( sys-libs/glibc[multilib] )
        opengl? ( || (
                (
                        >=virtual/opengl-7.0-r1[abi_x86_32(-)]
                        >=x11-libs/libX11-1.6.2[abi_x86_32(-)]
                        >=x11-libs/libXext-1.3.2[abi_x86_32(-)]
                        >=media-libs/alsa-lib-1.0.27.2[abi_x86_32(-)]
                )
                (
                        app-emulation/emul-linux-x86-xlibs[-abi_x86_32(-)]
                        app-emulation/emul-linux-x86-opengl[-abi_x86_32(-)]
                        app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)]
                )
        ) )"
DEPEND="${RDEPEND}
        sys-devel/m4"

dir=$(games_get_libdir)/${PN}

src_prepare() {
	# do we really need Wall spam?
	sed -i -e "/BASECPPFLAGS.append( '-Wall' )/d" neo/SConstruct

	# use our own CFLAGS in release builds
	sed -i -e "/OPTCPPFLAGS = \[ '-O3'/d" neo/SConstruct

        epatch "${FILESDIR}/d3_nokeycheck.patch"
        epatch "${FILESDIR}/d3_carmacksreverse.patch"
}

src_configure() {
	S+="/neo"

	myesconsargs+=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		# FIXME: build fails with JOBS=3
		#JOBS="$(echo -j1 ${MAKEOPTS} | sed -r "s/.*(-j\s*|--jobs=)([0-9]+).*/\2/")"
	)

	if use debug; then
		myesconsargs+=( BUILD="debug-all" )
	else
		myesconsargs+=(
			BUILD="release"
			OPTCPPFLAGS="${CXXFLAGS}"
		)
	fi

	if use dedicated; then
		if use opengl; then
			myesconsargs+=( DEDICATED="2" )
		else
			myesconsargs+=( DEDICATED="1" )
		fi
	else
		myesconsargs+=( DEDICATED="0" )
	fi

	# FIXME: needs 32-bit libz.a
	myesconsargs+=( NOCURL="1" )
}

src_compile() {
	escons
}

src_install() {
	exeinto "${dir}"
	doexe gamex86-base.so
	doexe gamex86-d3xp.so

	if use dedicated; then
		doexe doomded.x86
	fi

	if use opengl; then
		doexe doom.x86
		doexe sys/linux/setup/image/openurl.sh
		games_make_wrapper ${PN} ./doom.x86 "${dir}" "${dir}"
		newicon sys/linux/setup/image/doom3.png ${PN}.png
		make_desktop_entry ${PN} "Doom III"
	fi

	prepgamesdirs

	dodoc sys/linux/setup/image/README
}

pkg_postinst() {
	games_pkg_postinst

	elog "You need to copy 'base' directory"
	elog "from either your installation media or your hard drive to"
	elog "${dir}/ before running the game."
	echo
	elog "To play the game, run:"
	elog " ${PN}"
	echo
}
