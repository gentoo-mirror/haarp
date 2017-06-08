# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="libsass command line driver"
HOMEPAGE="https://github.com/sass/sassc"
SRC_URI="https://github.com/sass/sassc/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libsass"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}
