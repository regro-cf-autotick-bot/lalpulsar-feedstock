#!/bin/bash
#
# Configure, built, test, and install the Python language bindings
# for a LALSuite subpackage.
#

set -e

# build python in a sub-directory using a copy of the C build
_builddir="_build${PY_VER}"
cp -r _build ${_builddir}
cd ${_builddir}

# only link libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"
export CFITSIO_LIBS="-L${PREFIX}/lib -lcfitsio"

# configure only python bindings and pure-python extras
${SRC_DIR}/configure \
	--disable-doxygen \
	--disable-gcc-flags \
	--disable-swig-iface \
	--enable-python \
	--enable-swig-python \
	--prefix=$PREFIX \
;

# build
make -j ${CPU_COUNT} V=1 VERBOSE=1 -C swig
make -j ${CPU_COUNT} V=1 VERBOSE=1 -C python

# install
make -j ${CPU_COUNT} V=1 VERBOSE=1 -C swig install-exec  # swig bindings
make -j ${CPU_COUNT} V=1 VERBOSE=1 -C python install  # pure-python extras
