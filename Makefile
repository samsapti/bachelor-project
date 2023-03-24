default: all

deps:
	sudo apt install automake build-essential clang cmake git libntl-dev \
		libsodium-dev libssl-dev libtool m4 python3 texinfo yasm
	make -C src/MP_SPDZ -j$$(nproc) boost
	make -C src/MP_SPDZ -j$$(nproc) libote mpir

%:
	make -C src/MP_SPDZ -j$$(nproc) $@
