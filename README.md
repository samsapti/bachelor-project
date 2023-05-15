# Bachelor Project

- **Title:** Privately Matching Patients to Therapists using MPC
- **Programme:** B.Sc. in Software Development
- **University:** IT-University of Copenhagen

## Overview

This is the repository for the code accompanying my bachelor project. The
source code is located in the `src/` directory. The version of MP-SPDZ used is
v0.3.6.

The `ansible/` directory contains an Ansible playbook that provisions three
servers ready to use with MP-SPDZ. It also contains a `Vagrantfile` that can be
used to provision three virtual machines using VirtualBox.

## How to run computation locally

This guide assumes an Ubuntu 22.04 environment and is only tested with such
system. Make sure to have GNU Make installed.

1. Clone this repository and run `git submodule update --init` to clone MP-SDPZ
   as a submodule.
2. Navigate to `src/`.
3. Run `make -j$(nproc)` to install dependencies and compile MP-SPDZ.
4. Run `make gale_shapley.mpc` to compile the program.
5. Run `./gen_data.sh 50` to randomly generate data for the computation.
6. Run `./run.sh` to run the computation with three MPC parties locally in the
   background. The computation will print output to `src/out-p${n}.txt` (`n =
   #party`, `./run.sh -k` to kill computation).

### Summary

```sh
git submodule update --init
cd src/
make -j$(nproc)
make gale_shapley.mpc
./gen_data.sh 50
./run.sh
```

If you want to change the size of the dataset, you need to change the
`MATCHING_SIZE` constant in `gale_shapley.mpc` as well.

## License

This project is licensed under the BSD 3-Clause license.

MP-SPDZ is licensed under the BSD 3-Clause license. It is linked to this Git
repository as a submodule.
