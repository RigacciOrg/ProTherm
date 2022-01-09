TARGET  = protherm-tbot
PREFIX  = $(DESTDIR)/usr/local
SBINDIR = $(PREFIX)/sbin
LIBDIR  = $(PREFIX)/lib/$(TARGET)
CFGFILE = $(TARGET).cfg

.PHONY: all
all: ;

.PHONY: install
install: install-bin install-config

.PHONY: install-bin
install-bin:
	install -m 755 -o root -g root -D $(TARGET) $(SBINDIR)/$(TARGET)

.PHONY: install-config
install-config:
	install -m 755 -o root -g root -D rc-script.sh /etc/init.d/$(TARGET)
	install -m 640 -o root -g root -D $(CFGFILE) /etc/$(CFGFILE)

.PHONY: install-systemd
install-systemd:
	install -m 644 -o root -g root -D systemd-unit /etc/systemd/system/$(TARGET).service
	systemctl daemon-reload

.PHONY: uninstall
uninstall:
	-rm $(SBINDIR)/$(TARGET)
	-rm /etc/init.d/$(TARGET)
	-rm /etc/systemd/system/$(TARGET).service
	-rm /etc/$(CFGFILE)
