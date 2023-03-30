MP_SPDZ_PATH := $(CURDIR)/MP-SPDZ

all: patch deps
	$(MAKE) -C $(MP_SPDZ_PATH) all

patch:
	-git -C $(MP_SPDZ_PATH) apply $(CURDIR)/config.patch

deps: patch
	sudo apt install automake build-essential clang cmake git libntl-dev \
		libsodium-dev libssl-dev libtool m4 python3 texinfo yasm
	$(MAKE) -C $(MP_SPDZ_PATH) boost
	$(MAKE) -C $(MP_SPDZ_PATH) libote mpir

%.mpc: _phony
	python3 $(MP_SPDZ_PATH)/compile.py $@

%:
	$(MAKE) -C $(MP_SPDZ_PATH) $@

.PHONY: _phony
