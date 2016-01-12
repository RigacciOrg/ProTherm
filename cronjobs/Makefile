TARGET    = protherm
PREFIX    = $(DESTDIR)/usr/local
BINDIR    = $(PREFIX)/bin
BIN_FILES = protherm-rrd protherm-rrd-graph protherm-rrd-store protherm-snmp

.PHONY: all
all: ;

.PHONY: install
install: install-bin install-crontab

.PHONY: install-bin
install-bin:
	install -m 755 -o root -g root -D -t $(BINDIR) $(BIN_FILES)

.PHONY: install-crontab
install-crontab:
	install -m 644 -o root -g root -D protherm-crontab /etc/cron.d/$(TARGET)
