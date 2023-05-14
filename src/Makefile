MP_SPDZ_PATH := $(CURDIR)/MP-SPDZ

all: config deps ssl
	$(MAKE) -C $(MP_SPDZ_PATH) semi2k-party.x

config:
	cp -f $(CURDIR)/CONFIG.mine $(MP_SPDZ_PATH)/CONFIG.mine

deps: patch
	sudo apt install automake build-essential clang cmake git libntl-dev \
		libsodium-dev libssl-dev libtool m4 python3 texinfo yasm
	$(MAKE) -C $(MP_SPDZ_PATH) boost
	$(MAKE) -C $(MP_SPDZ_PATH) libote mpir

ssl:
	cd $(MP_SPDZ_PATH) && Scripts/setup-ssl.sh 3

%.mpc: _phony
	python3 $(MP_SPDZ_PATH)/compile.py -R 64 -O $@

%:
	$(MAKE) -C $(MP_SPDZ_PATH) $@

.PHONY: _phony
