# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info toolchain-funcs

DESCRIPTION="Tool to acces the Embedded Controller"
HOMEPAGE="https://github.com/torvalds/linux/blob/master/tools/power/acpi/tools/ec/ec_access.c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/glibc"
DEPEND="${DEPEND}
	>=sys-kernel/gentoo-sources-3.16"

pkg_setup() {
	CONFIG_CHECK="~ACPI_EC_DEBUGFS"

	linux-info_pkg_setup
	if linux_config_exists; then
		check_extra_config
	fi
}

src_unpack() {
	mkdir -p "${S}"
	cp "${KERNEL_DIR}/tools/power/acpi/tools/ec"/* "${S}/" || die "ec_access not found in kernel sources!"
	cd "${S}"
}

src_prepare() {
	ewarn "This ebuild grabs ${PN} from your active kernel's sources!"
	default
}

src_compile() {
	echo "$(tc-getCC) ${CFLAGS} ${LDFLAGS} ec_access.c -o ec_access"
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} ec_access.c -o ec_access || die "compile failure!"
}

src_install() {
	dobin ec_access
}
