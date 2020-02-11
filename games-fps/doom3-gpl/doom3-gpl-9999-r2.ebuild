# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# FIXME: Patch neo/SConstruct to Python3
PYTHON_COMPAT=( python2_7 )
inherit desktop git-r3 python-any-r1 scons-utils toolchain-funcs

DESCRIPTION="3rd installment of the classic iD 3D first-person shooter"
HOMEPAGE="https://github.com/TTimo/doom3.gpl"
EGIT_REPO_URI="https://github.com/TTimo/doom3.gpl.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dedicated opengl"

REQUIRED_USE="|| ( dedicated opengl )"

RDEPEND="sys-libs/glibc
	amd64? ( sys-libs/glibc[multilib] )
	opengl? ( >=virtual/opengl-7.0-r1[abi_x86_32(-)]
		  >=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		  >=x11-libs/libXext-1.3.2[abi_x86_32(-)]
		  >=media-libs/alsa-lib-1.0.27.2[abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	sys-devel/m4"

src_prepare() {
	# do we really need Wall spam?
	sed -i -e "/BASECPPFLAGS.append( '-Wall' )/d" neo/SConstruct

	# we supply our own CFLAGS instead of what the release build uses:
	# -O3 -ffast-math -fno-unsafe-math-optimizations -fomit-frame-pointer
	sed -i -e "/OPTCPPFLAGS = \[ '-O3'/d" neo/SConstruct
	sed -i -e "s/BASEFLAGS = ''/BASEFLAGS = \[ '${CXXFLAGS//[${IFS}]/', '}' \]/" neo/SConstruct
	sed -i -e "s/BASELINKFLAGS = \[ \]/BASELINKFLAGS = \[ '${LDFLAGS//[${IFS}]/', '}' \]/" neo/SConstruct

	# fix compilation errors on modern systems
	sed -i -e "s/m_speed - PRIMARYFREQ/(double)(m_speed - PRIMARYFREQ)/" neo/sys/linux/sound.cpp
	sed -i -e "s/HUGE/100000000/" neo/tools/compilers/roqvq/codec.cpp

	eapply "${FILESDIR}/d3_carmacksreverse.patch"
	eapply "${FILESDIR}/d3_nokeycheck.patch"

	eapply_user
}

src_configure() {
	S="${WORKDIR}/${P}/neo"

	# FIXME: disabled curl due to needing 32-bit libz.a
	MYSCONS=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		BUILD="$(usex debug debug release)"
		NOCURL="1"
	)

	if use dedicated; then
		if use opengl; then
			MYSCONS+=( DEDICATED="2" )
		else
			MYSCONS+=( DEDICATED="1" )
		fi
	else
		MYSCONS+=( DEDICATED="0" )
	fi
}

src_compile() {
	escons "${MYSCONS[@]}"
}

src_install() {
	exeinto "/usr/share/doom3"
	newexe gamex86-base.so gamex86.so
	doexe gamex86-d3xp.so

	if use opengl; then
		doexe doom.x86
		doexe sys/linux/setup/image/openurl.sh
		dosym /usr/share/doom3/doom.x86 /usr/bin/doom3
		doicon sys/linux/setup/image/doom3.png
		make_desktop_entry doom3 "Doom III" "doom3" "Game;ActionGame"
	fi

	if use dedicated; then
		doexe doomded.x86
		dosym /usr/share/doom3/doomded.x86 /usr/bin/doom3-dedicated
	fi

	dodoc ../README.txt sys/linux/setup/image/README
}

pkg_postinst() {
	elog "You need to copy the 'base' directory of a fully patched game to"
	elog "/usr/share/doom3/ before running the game."
}
