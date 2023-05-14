MP_SPDZ_PATH := $(CURDIR)/MP-SPDZ

all: config deps ssl
	$(MAKE) -C $(MP_SPDZ_PATH) semi2k-party.x

config:
	cp -f $(CURDIR)/CONFIG.mine $(MP_SPDZ_PATH)/CONFIG.mine

deps: config
	sudo apt install -y automake build-essential clang cmake git libgmp-dev \
	    libntl-dev libsodium-dev libssl-dev libtool m4 openssl python3 texinfo yasm
	$(MAKE) -C $(MP_SPDZ_PATH) boost
	$(MAKE) -C $(MP_SPDZ_PATH) libote

ssl:
	cd $(MP_SPDZ_PATH) && Scripts/setup-ssl.sh 3

%.mpc: _phony
	cd $(MP_SPDZ_PATH) && python3 compile.py -R 64 -O ../$@

%:
	$(MAKE) -C $(MP_SPDZ_PATH) $@

.PHONY: _phony
