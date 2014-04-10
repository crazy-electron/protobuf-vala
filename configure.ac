AC_INIT(protobuf-vala, 0.1.0)
AM_INIT_AUTOMAKE([1.11 no-dist-gzip dist-xz foreign])
AM_SILENT_RULES([yes])
AM_MAINTAINER_MODE
GNOME_MAINTAINER_MODE_DEFINES

AM_PROG_VALAC([0.16.0])
AM_PROG_CC_C_O
LT_INIT

PKG_CHECK_MODULES(LIBPROTOBUF, [
  gobject-2.0
  glib-2.0
])

PKG_CHECK_MODULES(PROTOC_GEN_VALA, [
  gobject-2.0
  glib-2.0
])

AC_OUTPUT([
Makefile
src/Makefile
src/protobuf-vala.pc
])
