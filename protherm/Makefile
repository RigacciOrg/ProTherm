TARGET  = protherm
PREFIX  = $(DESTDIR)/usr/local
SBINDIR = $(PREFIX)/sbin
ICONDIR = $(PREFIX)/share/icons
FONTDIR = $(PREFIX)/share/fonts
CFGFILE = $(TARGET).cfg

icon_files:=$(shell cd icons; echo *.ppm)
font_files:=$(shell cd fonts; echo *.ttf)

.PHONY: install
install:
	install -m 755 -D $(TARGET) $(SBINDIR)/$(TARGET)
	install -m 755 -D rc-script.sh /etc/init.d/$(TARGET)
	install -m 644 -D $(CFGFILE) /etc/$(CFGFILE)
	install -m 644 -D -t $(ICONDIR) $(addprefix icons/, $(icon_files))
	install -m 644 -D -t $(FONTDIR) $(addprefix fonts/, $(font_files))

.PHONY: uninstall
uninstall:
	-rm $(SBINDIR)/$(TARGET)
	-rm /etc/init.d/$(TARGET)
	-rm /etc/$(CFGFILE)
	-rm -f $(addprefix $(ICONDIR)/, $(icon_files))
	-rm -f $(addprefix $(FONTDIR)/, $(font_files))
