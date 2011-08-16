# http://www.phys.ethz.ch/~franklin/Projects/dphys-config/Makefile
# author/generator Neil Franklin using makesourcepackage script,
#   last modification/generation 2005.09.15
# This Makefile is copyright ETH Zuerich Physics Departement,
#   use under either modified/non-advertising BSD or GPL license

# --- various site dependant user config variables

# for creating an <program>[-<version>].tar.gz archive
DIR = dphys-config


# --- no user configurable stuff below here

PREFIX  = $(DESTDIR)/usr
BINDIR  = $(PREFIX)/bin
LIBDIR  = $(PREFIX)/lib/dphys-config
SBINDIR = $(PREFIX)/sbin
MAN1DIR = $(PREFIX)/share/man/man1
MAN7DIR = $(PREFIX)/share/man/man7
MAN8DIR = $(PREFIX)/share/man/man8
DOCDIR  = $(PREFIX)/share/doc/dphys-config
EXADIR  = $(DOCDIR)/examples


# --- code for acting out the various  make  targets

all:
	@# man pages need making and deleting of compressed versions
	@/bin/gzip -9 -c dphys-config.1 > dphys-config.1.gz

clean:
	@/bin/rm -f dphys-config.1.gz

distclean: clean

install:
	@# programs and man pages need installing to and deleting from system
	@/bin/mkdir -p $(BINDIR)
	@/bin/cp -p dphys-config          $(BINDIR)

	@/bin/mkdir -p $(MAN1DIR)
	@/bin/cp -p dphys-config.1.gz     $(MAN1DIR)

	@/bin/mkdir -p $(EXADIR)
	@/bin/cp -p  dphys-config.example  $(EXADIR)
	@/bin/cp -pr site.example          $(EXADIR)
	@/bin/cp -p  cron.d.example        $(EXADIR)
	@/bin/cp -p  init.d.example        $(EXADIR)

uninstall:
	@/bin/rm -f  $(EXADIR)/init.d.example
	@/bin/rm -f  $(EXADIR)/cron.d.example
	@/bin/rm -rf $(EXADIR)/site.example
	@/bin/rm -f  $(EXADIR)/dphys-config.example
	@/bin/rmdir $(EXADIR)

	@/bin/rm -f $(MAN1DIR)/dphys-config.1.gz

	@/bin/rm -f $(BINDIR)/dphys-config


# --- project management stuff

.PHONY: tar
tar:

	@# package this project into an .tar.gz for one nice download
	@/bin/echo packaging source and doc files into an .tar.gz ...
	@(cd ..; /bin/tar zcf $(DIR).tar.gz \
	  $(DIR)/FAQ $(DIR)/INSTALL $(DIR)/Logfile $(DIR)/Makefile \
	  $(DIR)/README $(DIR)/cron.d.example $(DIR)/dphys-config \
	  $(DIR)/dphys-config.1 $(DIR)/dphys-config.example \
	  $(DIR)/index.html.de $(DIR)/index.html.en \
	  $(DIR)/init.d.example $(DIR)/site.example )
