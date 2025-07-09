FDCLONE_VERSION = 3.01j
FDCLONE_SOURCE = FD-$(FDCLONE_VERSION).tar.gz
FDCLONE_SITE = http://unixusers.net/authors/VA012337/soft/fd
FDCLONE_LICENSE = GPL-2.0+
FDCLONE_LICENSE_FILES = ankh.cpy

define FDCLONE_CONVERT_TO_UTF8
	(cd $(@D); \
		find . -type f \( -name "*.c" -o -name "*.h" -o -name "*.doc" -o -name "_fdrc" \) | \
		while read file; do \
			iconv -f SHIFT-JIS -t UTF-8 "$$file" -o "$$file.utf8" && mv "$$file.utf8" "$$file"; \
		done \
	)
endef


FDCLONE_POST_PATCH_HOOKS += FDCLONE_CONVERT_TO_UTF8

define FDCLONE_CONFIGURE_CMDS
	(cd $(@D); ./Configur --prefix=/usr --without-x)
endef

define FDCLONE_BUILD_CMDS
	$(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" \
		HOSTCC="$(HOSTCC)"
endef


define FDCLONE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/fd $(TARGET_DIR)/usr/bin/fd
	$(INSTALL) -D -m 0644 $(@D)/_fdrc $(TARGET_DIR)/etc/fd2rc
endef

$(eval $(generic-package))

