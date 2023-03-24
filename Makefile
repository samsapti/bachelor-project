all:
	make -C src/MP_SPDZ -j$$(nproc) boost
	make -C src/MP_SPDZ -j$$(nproc) libote mpir
	make -C src/MP_SPDZ -j$$(nproc)

%:
	make -C src/MP_SPDZ -j$$(nproc) $@
