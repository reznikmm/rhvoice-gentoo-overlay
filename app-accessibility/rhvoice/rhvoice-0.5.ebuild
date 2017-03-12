# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit vcs-snapshot scons-utils eutils multilib toolchain-funcs

DESCRIPTION="a Russian speech synthesizer"
HOMEPAGE="https://github.com/Olga-Yakovleva/RHVoice"
SRC_URI="https://github.com/Olga-Yakovleva/RHVoice/archive/0.5.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-cpp/glibmm
		media-libs/libao"
# Should work with any of these instead of libao, but I haven't tried
#media-sound/pulseaudio
#media-libs/portaudio

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.5-custom-cc.patch
}

src_configure() {
	myesconsargs=(
		CC=$(tc-getCC)
		CXX=$(tc-getCXX)
		prefix="${EPREFIX}"/usr
		libdir="${EPREFIX}"/usr/"$(get_libdir)"
		sysconfdir="${EPREFIX}"/etc
		enable_shared=yes
		CCFLAGS=" ${CFLAGS}"
		CXXFLAGS="${CXXFLAGS} -std=c++11"
		LINKFLAGS="${LDFLAGS}"
		debug=no
	)
}

src_compile() {
	escons
}

src_install() {
	# fails with parallel install
	escons -j1 DESTDIR="${D}" install
	dodoc README INSTALL
}
