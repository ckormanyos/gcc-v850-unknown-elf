ckormanyos/gcc-v850-unknown-elf
==================

<p align="center">
    <a href="https://github.com/ckormanyos/gcc-v850-unknown-elf/actions">
        <img src="https://github.com/ckormanyos/gcc-v850-unknown-elf/actions/workflows/build-ubuntu.yml/badge.svg" alt="build-ubuntu"></a>
    <a href="https://github.com/ckormanyos/gcc-v850-unknown-elf/actions">
        <img src="https://github.com/ckormanyos/gcc-v850-unknown-elf/actions/workflows/build-msys64.yml/badge.svg" alt="build-msys64"></a>
    <a href="https://github.com/ckormanyos/gcc-v850-unknown-elf/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc">
        <img src="https://custom-icon-badges.herokuapp.com/github/issues-raw/ckormanyos/gcc-v850-unknown-elf?logo=github" alt="Issues" /></a>
    <a href="https://github.com/ckormanyos/gcc-v850-unknown-elf/blob/main/UNLICENSE">
        <img src="https://img.shields.io/badge/license-The Unlicense-blue.svg" alt="The Unlicense"></a>
</p>

`ckormanyos/gcc-v850-unknown-elf` provides shell and YAML scripts to build a modern `gcc-v850-unknown-elf`.

Design goals:
  - Use shell and YAML scripts to build modern `gcc-v850-unknown-elf` on-the-fly.
  - Build `gcc-v850-unknown-elf` from up-to-date [gcc-releases](https://ftp.gnu.org/gnu/gcc).
  - Provide a non-trivial test of the newly-built toolchain(s) based on a real-world project.
  - Publish the build artifacts directly from the GHA Workflow-Run(s).
  - Occasionally create and publish versioned releases.

## Releases and Build Artifacts

Using released or CI-built artifacts can be convenient when you
do not actually want to nor need to manually build
`gcc-v850-unknown-elf` toolchain.

Releases and build artifacts consisting of the
fully-built `gcc-v850-unknown-elf` toolchain are occasionally created
and published for `x86_64-linux-gnu` (Linux) and
`x86_64-w64-mingw32` (Windows). These can be readily found
on the repo front page and in CI workflow-run download-areas
for immediate client use. The releases are permanent, whereby
the built artifacts are limited to three days after the
Workflow-Run(s).

## Workflow-Run

Workflow:
  - Use the shell script [avr-gcc-100.sh](./avr-gcc-100.sh) consistently in each of the Workflow-Run(s).
  - The Workflow-Run [build-ubuntu.yml](./.github/workflows/build-ubuntu.yml) builds `avr-gcc` for the _host_ `x86_64-linux-gnu`. The script is executed on a GHA `ubuntu-latest` runner.
  - The Workflow-Run [build-msys64.yml](./.github/workflows/build-msys64.yml) builds `avr-gcc` for the _host_ `x86_64-w64-mingw32`. The script is executed on a GHA `windows-latest` runner using `msys64`.
  - When building for `x86_64-w64-mingw32` on `msys64`, use a pre-built, dependency-free, statically linked `mingw` and host-compiler (see notes below). This separate `mingw` package is unpacked in a directory parallel to the runner workspace and its `bin` directory is added to the `PATH` variable.
  - GCC prerequisites including [GMP](https://gmplib.org), [MPFR](https://www.mpfr.org), [MPC](https://www.multiprecision.org), etc. are built on-the-fly in the Workflow-Run.
  - Build [`binutils`](https://www.gnu.org/software/binutils) and partially verify the build artifacts.
  - Then build `gcc-v850-unknown-elf` and partially verify the build artifacts. Use [newlib](https://sourceware.org/newlib) and the `--with-newlib` configuration flag.
  - Test the complete, newly built `gcc-v850-unknown-elf` toolchain with a non-trivial compiler test. In the compiler test, we build `ref_app` (the reference application) from [`ckormanyos/real-time-cpp`](https://github.com/ckormanyos). Verify the creation of key build results from `ref_app` including ELF-file, HEX-file, map files, etc.

## Additional Notes

Notes:
  - This project is distributed under [The Unlicense](./UNLICENSE).
  - This work is similar to the related project [`ckormanyos/avr-gcc-build`](https://github.com/ckormanyos/avr-gcc-build).
  - The pre-built, dependency-free, statically linked `mingw` and host-compiler system originate from Steven T. Lavavej's [`MinGW Distro`](https://nuwen.net/mingw.html).
