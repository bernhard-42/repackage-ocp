# Build System for OCP

## Recipe

The github action can be found in [.github/workflows/build-ocp.yml](.github/workflows/build-ocp.yml)

## Wheels

The action creates two different types of delocated wheels:

1. `cadquery_ocp` which is build against pypi's VTK 9.2.6
2. `cadquery_ocp_novtk` which comes without VTK support

## Supported Operation Systems
The wheels are created for

- **Windows (Intel)**
- **MacOS (Intel)**: running from macOS 11.11 or newer
- **MacOS (arm64)**: running from macOS 11.11 or newer
- **Linux (Intel)**: running Ubuntu 20.04 or newer (GLIBC_2.29 and GLIBCXX_3.4.26)

## Supported Python Versions

- The **vtk** version can only be built for Python 3.11 and older, since this is the limitation of pypi VTK 9.2.6.
- The **novtk** version can be built for Python3.10 and newer, up to 3.13. However, currently only 3.11 is built.

## Tests

- The **vtk** wheels are tested against `build123d` and `cadquery``
- The **novtk** wheels are tested against a patched version of `build123d` only (vtk support removed)

## Known issues

- For macOS (Intel), `nlopt` 2.9 is not on pypi. The test installes `nlopt` from conda.
- For Windows, `casadi` and `nlopt` create a segmentation fault on exit (even when OCP and VTK are not installed). The test installed `nlopt` and `casadi` from conda.

