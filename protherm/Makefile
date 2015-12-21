TARGET  = protherm
PREFIX  = $(DESTDIR)/usr/local
SBINDIR = $(PREFIX)/sbin
CFGFILE = $(TARGET).cfg

install:
	install -m 755 -D $(TARGET) $(SBINDIR)/$(TARGET)
	install -m 755 -D rc-script.sh /etc/init.d/$(TARGET)
	install -m 644 -D $(CFGFILE) /etc/$(CFGFILE)

uninstall:
	-rm $(SBINDIR)/$(TARGET)
	-rm /etc/init.d/$(TARGET)
	-rm /etc/$(CFGFILE)
