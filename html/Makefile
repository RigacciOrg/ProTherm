PREFIX  = $(DESTDIR)/var/www
HTML    = $(PREFIX)/html
FONTDIR = $(HTML)/fonts
IMGDIR  = $(HTML)/img

PHP_FILES = changemode.php index.php prog_graph.php programs.php
FONT_FILES := $(shell cd fonts; echo *.ttf)

.PHONY: all
all: ;

.PHONY: install
install:
	install -m 644 -o root -g root -D -t $(HTML) $(PHP_FILES)
	install -m 644 -o root -g root -D -t $(FONTDIR) $(addprefix fonts/, $(FONT_FILES))
	install -m 644 -o root -g root -D -t $(IMGDIR) img/lcd_image.php
	ln -s /run/shm/protherm/rra/protherm-day.png $(IMGDIR)
	ln -s /run/shm/protherm/rra/protherm-week.png $(IMGDIR)
	ln -s /run/shm/protherm/rra/protherm-month.png $(IMGDIR)
