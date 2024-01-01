ckormanyos/gcc-v850-unknown-elf
==================

<p align="center">
    <a href="https://github.com/ckormanyos/gcc-v850-unknown-elf/actions">
        <img src="https://github.com/ckormanyos/gcc-v850-unknown-elf/actions/workflows/gcc-v850-unknown-elf-build-msys2.yml/badge.svg" alt="build-msys2"></a>
    <a href="https://github.com/ckormanyos/gcc-v850-unknown-elf/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc">
        <img src="https://custom-icon-badges.herokuapp.com/github/issues-raw/ckormanyos/gcc-v850-unknown-elf?logo=github" alt="Issues" /></a>
    <a href="https://github.com/ckormanyos/gcc-v850-unknown-elf/blob/main/UNLICENSE">
        <img src="https://img.shields.io/badge/license-The Unlicense-blue.svg" alt="The Unlicense"></a>
</p>

`ckormanyos/gcc-v850-unknown-elf` provides shell and YAML scripts to build a modern `gcc-v850-unknown-elf`
on GHA native runner(s). Built toolchains are distributed as ZIP-archive(s)
directly from the Workflow-Run(s) on GHA.

Design goals:
  - Use shell and YAML scripts to build modern `gcc-v850-unknown-elf` on-the-fly.
  - Build `gcc-v850-unknown-elf` from up-to-date releases such as 13.2.0.
  - Provide a non-trivial test of the newly-built toolchain(s) based on a real-world project.
  - Support cyclic monthly build of modern, evolving GCC branch(es) and trunk.
  - Publish the build artifacts directly from the Workflow-Run(s) on GHA.

## Workflow-Run

Workflow:
  - The Workflow-Run [gcc-v850-unknown-elf-build-msys2.yml](./.github/workflows/gcc-v850-unknown-elf-build-msys2.yml) and its associated shell script [gcc-v850-unknown-elf-100-my_ver_x86_64-w64-mingw32.sh](./gcc-v850-unknown-elf-100-my_ver_x86_64-w64-mingw32.sh) build `gcc-v850-unknown-elf` for the _host_ `x86_64-w64-mingw32`. These run on a GHA `windows-latest` runner using `msys2`.
  - When building for `x86_64-w64-mingw32` on `msys2`, use a pre-built, dependency-free, statically linked `mingw` and host-compiler (see notes below). This separate `mingw` package is unpacked in a directory parallel to the runner workspace and its `bin` directory is added to the `PATH` variable.
  - GCC prerequisites including [GMP](https://gmplib.org), [MPFR](https://www.mpfr.org), [MPC](https://www.multiprecision.org), etc. are built on-the-fly in the Workflow-Run.
  - Build [`binutils`](https://www.gnu.org/software/binutils) and partially verify the build artifacts.
  - Then build `gcc-v850-unknown-elf` (use [newlib](https://sourceware.org/newlib) and the `--with-newlib` configuration flag) and partially verify the build artifacts.
  - Test the complete, newly built `gcc-v850-unknown-elf` toolchain with a non-trivial compiler test. In the compiler test, we build `ref_app` (the reference application) from [`ckormanyos/real-time-cpp`](https://github.com/ckormanyos). Verify the creation of key build results from `ref_app` including ELF-file, HEX-file, map files, etc.

## Distribution

Build artifacts are compressed and stored as ZIP-archive(s)
directly from the Workflow-Run on GHA.
The [`actions/upload-artifact`](https://github.com/actions/upload-artifact) action
is used for archiving build artifacts.

## Additional Notes

Notes:
  - This project is distributed under [The Unlicense](./UNLICENSE).
  - This work is similar to the related project [`ckormanyos/avr-gcc-build`](https://github.com/ckormanyos/avr-gcc-build).
  - The pre-built, dependency-free, statically linked `mingw` and host-compiler system originate from Steven T. Lavavej's [`MinGW Distro`](https://nuwen.net/mingw.html).
