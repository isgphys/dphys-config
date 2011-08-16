# http://www.phys.ethz.ch/~franklin/Projects/dphys-config/Makefile
# author/generator Neil Franklin using makesourcepackage script,
#   last modification/generation 2005.10.12
# This Makefile is copyright ETH Zuerich Physics Departement,
#   use under either modified/non-advertising BSD or GPL license

# --- various site dependant user config variables

# for creating an <program>[-<version>].tar.gz archive
DIR = dphys-config


# --- no user configurable stuff below here

# /usr/local added for FreeBSD, because their ports end up in there
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

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
	@gzip -9 -c dphys-config.1 > dphys-config.1.gz

clean:
	@rm -f dphys-config.1.gz

distclean: clean

install:
	@# programs and man pages need installing to and deleting from system
	@mkdir -p $(BINDIR)
	@cp -p dphys-config          $(BINDIR)

	@mkdir -p $(MAN1DIR)
	@cp -p dphys-config.1.gz     $(MAN1DIR)

	@mkdir -p $(EXADIR)
	@cp -p  dphys-config.example  $(EXADIR)
	@cp -pr site.example          $(EXADIR)
	@cp -p  cron.d.example        $(EXADIR)
	@cp -p  init.d.example        $(EXADIR)

uninstall:
	@rm -f  $(EXADIR)/init.d.example
	@rm -f  $(EXADIR)/cron.d.example
	@rm -rf $(EXADIR)/site.example
	@rm -f  $(EXADIR)/dphys-config.example
	@rmdir $(EXADIR)

	@rm -f $(MAN1DIR)/dphys-config.1.gz

	@rm -f $(BINDIR)/dphys-config


# --- project management stuff

.PHONY: tar
tar:

	@# package this project into an .tar.gz for one nice download
	@echo packaging source and doc files into an .tar.gz ...
	@(cd ..; tar zcf $(DIR).tar.gz \
	  $(DIR)/FAQ $(DIR)/INSTALL $(DIR)/Logfile $(DIR)/Makefile \
	  $(DIR)/README $(DIR)/cron.d.example $(DIR)/dphys-config \
	  $(DIR)/dphys-config.1 $(DIR)/dphys-config.example \
	  $(DIR)/index.html.de $(DIR)/index.html.en \
	  $(DIR)/init.d.example $(DIR)/site.example )
