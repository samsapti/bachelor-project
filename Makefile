MP_SPDZ_PATH := src/MP-SPDZ

all: patch deps
	$(MAKE) -C $(MP_SPDZ_PATH) all

patch:
	-git -C $(MP_SPDZ_PATH) apply ../../config.patch

deps: patch
	sudo apt install automake build-essential clang cmake git libntl-dev \
		libsodium-dev libssl-dev libtool m4 python3 texinfo yasm
	$(MAKE) -C $(MP_SPDZ_PATH) boost
	$(MAKE) -C $(MP_SPDZ_PATH) libote mpir

%.mpc:
	cd $(MP_SPDZ_PATH) && ./compile.py ../$@

%:
	$(MAKE) -C $(MP_SPDZ_PATH) $@
