TARGET  = protherm
PREFIX  = $(DESTDIR)/usr/local
SBINDIR = $(PREFIX)/sbin
ICONDIR = $(PREFIX)/share/icons
FONTDIR = $(PREFIX)/share/fonts
LIBDIR  = $(PREFIX)/lib/$(TARGET)
CFGFILE = $(TARGET).cfg

ICON_FILES := $(shell cd icons; echo *.ppm)
FONT_FILES := $(shell cd fonts; echo *.ttf)
PROG_FILES = PROG1.txt PROG2.txt PROG3.txt
UTILS_BIN  = protherm-sighup protherm-sigusr1

.PHONY: all
all: ;

.PHONY: install
install: install-bin install-files install-config

.PHONY: install-bin
install-bin:
	install -m 755 -o root -g root -D $(TARGET) $(SBINDIR)/$(TARGET)
	install -m 755 -o root -g root -D -t $(SBINDIR) $(addprefix misc/, $(UTILS_BIN))

.PHONY: install-files
install-files:
	install -m 644 -o root -g root -D -t $(ICONDIR) $(addprefix icons/, $(ICON_FILES))
	install -m 644 -o root -g root -D -t $(FONTDIR) $(addprefix fonts/, $(FONT_FILES))
	install -m 644 -o root -g root -D -t $(LIBDIR) $(addprefix progs/, $(PROG_FILES))

.PHONY: install-config
install-config:
	install -m 640 -o root -g root -D $(CFGFILE) /etc/$(CFGFILE)

.PHONY: install-sysvinit
install-sysvinit:
	install -m 755 -o root -g root -D rc-script.sh /etc/init.d/$(TARGET)

.PHONY: install-systemd
install-systemd:
	install -m 644 -o root -g root -D systemd-unit /etc/systemd/system/$(TARGET).service
	install -m 644 -o root -g root -D udev-rule /etc/udev/rules.d/$(TARGET)-spidev.rules
	systemctl daemon-reload

.PHONY: uninstall
uninstall:
	-rm $(SBINDIR)/$(TARGET)
	-rm /etc/init.d/$(TARGET)
	-rm /etc/systemd/system/$(TARGET).service
	-rm /etc/udev/rules.d/$(TARGET)-spidev.rules
	-rm /etc/$(CFGFILE)
	-rm -f $(addprefix $(ICONDIR)/, $(ICON_FILES))
	-rm -f $(addprefix $(FONTDIR)/, $(FONT_FILES))
	-rm -f $(addprefix $(LIBDIR)/, $(PROG_FILES))
	-rm -f $(addprefix $(SBINDIR)/, $(UTILS_BIN))
