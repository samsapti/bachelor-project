all: patch deps
	$(MAKE) -C src/MP_SPDZ all

patch:
	-git -C src/MP_SPDZ apply ../../config.patch

deps: patch
	sudo apt install automake build-essential clang cmake git libntl-dev \
		libsodium-dev libssl-dev libtool m4 python3 texinfo yasm
	$(MAKE) -C src/MP_SPDZ boost
	$(MAKE) -C src/MP_SPDZ libote mpir

%:
	$(MAKE) -C src/MP_SPDZ $@
