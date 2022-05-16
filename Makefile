
ASCII_FILE := art/$(OS).txt

ifeq ($(NO_COLOR),)
ASCII_COLOR   := \e[36;1m
SPECIAL_COLOR := \e[36;1m
CLEAR_COLOR   := \e[0m
KEY_COLOR     := \e[0;36;2m
VALUE_COLOR   := \e[37;0m
endif

LINE_0 := user_at_host
LINE_1 := kernel
LINE_2 := host
LINE_3 := uptime
LINE_4 := none
LINE_5 := memory

KERNEL := $(shell uname -s)
ifeq ($(KERNEL), Linux)
INSTALL_BIN_DIR := $(INSTALL_DIR)$(if $(PREFIX),$(PREFIX),/usr)/bin
else
all: $(error kernel `$(KERNEL)` not supported)
endif

all: bin/ bin/psi

%/:
	mkdir -p $@

bin/psi:
	ruby Makefile.rb \
		ASCII_FILE='$(ASCII_FILE)' \
		ASCII_COLOR='$(ASCII_COLOR)' \
		SPECIAL_COLOR='$(SPECIAL_COLOR)' \
		CLEAR_COLOR='$(CLEAR_COLOR)' \
		KEY_COLOR='$(KEY_COLOR)' \
		VALUE_COLOR='$(VALUE_COLOR)' \
		LINE_0='$(LINE_0)' \
		LINE_1='$(LINE_1)' \
		LINE_2='$(LINE_2)' \
		LINE_3='$(LINE_3)' \
		LINE_4='$(LINE_4)' \
		LINE_5='$(LINE_5)'
	chmod +x bin/psi

install: all uninstall
	cp -r bin/psi $(INSTALL_BIN_DIR)/psi

uninstall:
	rm -r $(INSTALL_BIN_DIR)/psi

clean:
	rm -rf bin/
