lib_LTLIBRARIES = libprotobuf-vala.la
libprotobuf_vala_includedir = $(includedir)/protobuf-vala
libprotobuf_vala_include_DATA = protobuf-vala.h
libprotobuf_vala_vapidir = $(datadir)/vala/vapi
libprotobuf_vala_vapi_DATA = protobuf-vala.vapi
libprotobuf_vala_pkgconfigdir = $(libdir)/pkgconfig
libprotobuf_vala_pkgconfig_DATA = protobuf-vala.pc

protobuf-vala_vala.stamp: $(srcdir)/protobuf-vala.vala
	$(VALAC) -C --vapi protobuf-vala.vapi -h protobuf-vala.h $(srcdir)/protobuf-vala.vala
	touch protobuf-vala_vala.stamp
protobuf-vala.c: protobuf-vala_vala.stamp

nodist_libprotobuf_vala_la_SOURCES = \
	protobuf-vala.c

libprotobuf_vala_la_CFLAGS = \
	$(LIBPROTOBUF_CFLAGS)

libprotobuf_vala_la_LIBADD = \
	$(LIBPROTOBUF_LIBS)

bin_PROGRAMS = protoc-gen-vala
noinst_PROGRAMS = test-encode test-decode

TESTS = test-encode test-decode

test.pb.vala: protoc-gen-vala $(srcdir)/test.proto
	protoc --plugin=protoc-gen-vala --vala_out=. --proto_path=$(srcdir) $(srcdir)/test.proto

protoc-gen_vala.stamp: protobuf-vala.vapi $(srcdir)/protoc-gen-vala.vala $(srcdir)/descriptor.pb.vala $(srcdir)/plugin.pb.vala
	$(VALAC) -C --pkg posix --vapidir . --pkg protobuf-vala $(srcdir)/protoc-gen-vala.vala $(srcdir)/descriptor.pb.vala $(srcdir)/plugin.pb.vala
	touch protoc-gen_vala.stamp
protoc-gen-vala.c descriptor.pb.c plugin.pb.c: protoc-gen_vala.stamp    

nodist_protoc_gen_vala_SOURCES = \
	protoc-gen-vala.c \
	descriptor.pb.c \
	plugin.pb.c

protoc_gen_vala_CFLAGS = \
	-DVERSION=\"$(VERSION)\" \
	$(PROTOC_GEN_VALA_CFLAGS)

protoc_gen_vala_LDADD = \
	libprotobuf-vala.la \
	$(PROTOC_GEN_VALA_LIBS)

test-encode_vala.stamp: protobuf-vala.vapi $(srcdir)/test-encode.vala test.pb.vala
	$(VALAC) -C --pkg posix --vapidir . --pkg protobuf-vala $(srcdir)/test-encode.vala test.pb.vala
	touch test-encode_vala.stamp
test-encode.c test.pb.c: test-encode_vala.stamp

nodist_test_encode_SOURCES = \
	test-encode.c \
	test.pb.c

test_encode_CFLAGS = \
	$(PROTOC_GEN_VALA_CFLAGS)

test_encode_LDADD = \
	libprotobuf-vala.la \
	$(PROTOC_GEN_VALA_LIBS)

test-decode_vala.stamp: protobuf-vala.vapi $(srcdir)/test-decode.vala test.pb.vala
	$(VALAC) -C --pkg posix --vapidir . --pkg protobuf-vala $(srcdir)/test-decode.vala test.pb.vala
	touch test-decode_vala.stamp
test-decode.c test.pb.c: test-decode_vala.stamp

nodist_test_decode_SOURCES = \
	test-decode.c \
	test.pb.c

test_decode_CFLAGS = \
	$(PROTOC_GEN_VALA_CFLAGS)

test_decode_LDADD = \
	libprotobuf-vala.la \
	$(PROTOC_GEN_VALA_LIBS)

CLEANFILES = \
	*.c \
	*_vala.stamp \
	protobuf-vala.h \
	protobuf-vala.vapi \
	test.pb.vala

EXTRA_DIST = \
	descriptor.pb.vala \
	plugin.pb.vala \
	protobuf-vala.vala \
	protoc-gen-vala.vala \
	test-decode.vala \
	test-encode.vala \
	test.proto

DISTCLEANFILES = Makefile.in
