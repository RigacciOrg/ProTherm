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

.PHONY: all
all: ;

.PHONY: install
install: install-bin install-files install-config

.PHONY: install-bin
install-bin:
	install -m 755 -o root -g root -D $(TARGET) $(SBINDIR)/$(TARGET)

.PHONY: install-files
install-files:
	install -m 644 -o root -g root -D -t $(ICONDIR) $(addprefix icons/, $(ICON_FILES))
	install -m 644 -o root -g root -D -t $(FONTDIR) $(addprefix fonts/, $(FONT_FILES))
	install -m 644 -o root -g root -D -t $(LIBDIR) $(addprefix progs/, $(PROG_FILES))

.PHONY: install-config
install-config:
	install -m 755 -o root -g root -D rc-script.sh /etc/init.d/$(TARGET)
	install -m 644 -o root -g root -D $(CFGFILE) /etc/$(CFGFILE)

.PHONY: uninstall
uninstall:
	-rm $(SBINDIR)/$(TARGET)
	-rm /etc/init.d/$(TARGET)
	-rm /etc/$(CFGFILE)
	-rm -f $(addprefix $(ICONDIR)/, $(ICON_FILES))
	-rm -f $(addprefix $(FONTDIR)/, $(FONT_FILES))
	-rm -f $(addprefix $(LIBDIR)/, $(PROG_FILES))
