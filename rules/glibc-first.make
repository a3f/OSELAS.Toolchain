# -*-makefile-*-
#
# Copyright (C) 2006 by Robert Schwebel
#		2007, 2008 by Marc Kleine-Budde
#               2013 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GLIBC_FIRST) += glibc-first

#
# Paths and names
#
GLIBC_FIRST_VERSION	:= $(call remove_quotes,$(PTXCONF_GLIBC_VERSION))
GLIBC_FIRST_MD5		:= $(call remove_quotes,$(PTXCONF_GLIBC_MD5))
GLIBC_FIRST		:= glibc-$(GLIBC_FIRST_VERSION)
GLIBC_FIRST_SUFFIX	:= tar.bz2
GLIBC_FIRST_SOURCE	:= $(SRCDIR)/$(GLIBC_FIRST).$(GLIBC_FIRST_SUFFIX)
GLIBC_FIRST_DIR		:= $(BUILDDIR)/glibc-first-$(GLIBC_FIRST_VERSION)
GLIBC_FIRST_BUILDDIR	:= $(GLIBC_FIRST_DIR)-build
GLIBC_FIRST_URL		 = $(GLIBC_URL)
GLIBC_FIRST_BUILD_OOT	:= YES
GLIBC_FIRST_LICENSE	:= ignore

GLIBC_PORTS_VERSION	:= $(call remove_quotes,$(PTXCONF_GLIBC_PORTS_VERSION))
GLIBC_PORTS_MD5		:= $(call remove_quotes,$(PTXCONF_GLIBC_PORTS_MD5))
GLIBC_PORTS		:= glibc-ports-$(GLIBC_PORTS_VERSION)
GLIBC_PORTS_SOURCE	:= $(SRCDIR)/$(GLIBC_PORTS).$(GLIBC_SUFFIX)
$(GLIBC_PORTS_SOURCE)	:= GLIBC_PORTS
GLIBC_PORTS_DIR		:= $(BUILDDIR)/$(GLIBC)/ports
GLIBC_PORTS_URL		:= \
	$(call ptx/mirror, GNU, glibc/$(GLIBC_PORTS).$(GLIBC_SUFFIX)) \
	ftp://sources.redhat.com/pub/glibc/snapshots/$(GLIBC_PORTS).$(GLIBC_SUFFIX) \
	http://www.pengutronix.de/software/ptxdist/temporary-src/glibc/$(GLIBC_PORTS).$(GLIBC_SUFFIX)

ifdef PTXCONF_GLIBC_PORTS
GLIBC_SOURCES		+= $(GLIBC_PORTS_SOURCE)
endif

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

GLIBC_FIRST_PATH := PATH=$(CROSS_PATH)
GLIBC_FIRST_ENV := \
	CC="$(CROSS_CC) -fuse-ld=bfd" \
	CXX=false \
	BUILD_CC=$(HOSTCC) \
	$(GLIBC_FLAGS_ENV) \
	\
	libc_cv_c_cleanup=yes \
	libc_cv_forced_unwind=yes \
	libc_cv_fpie=yes \
	libc_cv_slibdir='/lib' \
	libc_cv_ssp=yes \
	libc_cv_visibility_attribute=yes \
	libc_cv_broken_visibility_attribute=no \
	libc_cv_z_relro=yes \
	\
	ac_cv_sizeof_long_double=$(PTXCONF_SIZEOF_LONG_DOUBLE)

GLIBC_FIRST_CONF_TOOL	:= autoconf
GLIBC_FIRST_CONF_OPT	 = \
	$(GLIBC_AUTOCONF_COMMON) \
	$(PTXCONF_GLIBC_CONFIG_EXTRA_CROSS) \
	--disable-profile \

GLIBC_FIRST_MAKE_OPT	:= \
	AUTOCONF=no \
	build-programs=no

GLIBC_FIRST_INSTALL_OPT	:= \
	AUTOCONF=no \
	install_root=$(SYSROOT) \
	install-lib-all \
	install-headers

# vim: syntax=make

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------
@@ $(STATEDIR)/glibc.extract:
	@$(call targetinfo)
	@$(call clean, $(GLIBC_DIR))
	@$(call extract, GLIBC, $(BUILDDIR_DEBUG))
ifdef PTXCONF_GLIBC_PORTS
	@$(call extract, GLIBC_PORTS, $(BUILDDIR_DEBUG))
endif
	@$(call patchin, GLIBC, $(GLIBC_DIR))
	@$(call touch)
