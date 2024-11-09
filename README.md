# Versions

```bash
VTK=9.2.6
OCP=7.7.2
PYTHON=3.11
```


# VTK

## Clean the environment

```bash
cd VTK

rm -fr vtk.py vtkmodules build dist wheel cadquery_vtk.egg-info/ vtk.pybak __pycache__
```

## Create the VTK environment

```bash
micromamba create -n vtk python=$PYTHON -y
micromamba activate vtk
micromamba install -c conda-forge ocp=$OCP -y
micromamba install delocate build -y
```

## Copy the VTK artifacts

```bash
cp $CONDA_PREFIX/lib/python$PYTHON/site-packages/vtk.py .
cp -r $CONDA_PREFIX/lib/python$PYTHON/site-packages/vtkmodules .
mkdir libs

# copy symlinks with name of the symlink
for l in $CONDA_PREFIX/lib/libvtk*9.2.1.dylib; do cp -L $l ./libs; done
```

## Remove FFMPEG support to avoid _iconv error

```bash
rm vtkmodules/vtkIOFFMPEG.so
sed -i 'bak' 's/from vtkmodules.vtkIOFFMPEG/# from vtkmodules.vtkIOFFMPEG/' vtk.py
```

## Create the cadquery_vtk wheel

```bash
python -m build -n -w
```

## Delocate the libraries

The order in `DYLD_LIBRARY_PATH` is important to get the 9.2.1 libs

```bash
env MACOSX_DEPLOYMENT_TARGET=11.1 \
    DYLD_LIBRARY_PATH=./libs:$CONDA_PREFIX/lib \
    python -m delocate.cmd.delocate_wheel \
    --wheel-dir=wheel \
    dist/*.whl
```

## Leave vtk environment

```bash
micromamba deactivate
cd ..
```

# OCP

## Clean the environment

```bash
cd OCP

rm -fr OCP.cpython-311-darwin.so build dist wheel cadquery_ocp cadquery_ocp.egg-info __pycache__
```


## Create the OCP environment 1

```bash
micromamba create -n ocp1 python=$PYTHON -y
micromamba activate ocp1
micromamba install -c conda-forge ocp==7.7.2 -y
```

## Copy the OCP artifacts 

```bash
mkdir cadquery_ocp
mkdir -p cadquery_ocp/include
touch cadquery_ocp/__init__.py

cp $CONDA_PREFIX/lib/python$PYTHON/site-packages/OCP.cpython-*-darwin.so .
cp $CONDA_PREFIX/include/opencascade/* cadquery_ocp/include

```

## Leave environment 1

```bash
micromamba deactivate
```

## Create the OCP environment 2

```bash
micromamba create -n ocp python=$PYTHON -y
micromamba activate ocp
micromamba install delocate build -y
```

## Install and verify the VTK wheel

```bash
pip install ../VTK/wheel/*.whl

python -c "import vtk"
```

# Patch the vtkmodules path into the OCP library

```bash
install_name_tool -add_rpath @loader_path/vtkmodules/.dylibs OCP.*.so
# install_name_tool -add_rpath @loader_path/cadquery_ocp/lib OCP.*.so
codesign --force --sign - OCP.*.so
```

## Create the cadquery_ocp wheel

```bash
python -m build -w -n
```

## Delocate the libraries

The order in `DYLD_LIBRARY_PATH` is important

```bash
env MACOSX_DEPLOYMENT_TARGET=11.1 \
    DYLD_LIBRARY_PATH=$CONDA_PREFIX/lib:$CONDA_PREFIX/../vtk/lib \
    python -m delocate.cmd.delocate_wheel \
    -e libvtk \
    --wheel-dir=wheel \
    dist/*.whl

```

## Leave environment 2

```bash
micromamba deactivate
cd ..
```

# Test with cadquery

## Create the test environment

```bash
micromamba create -n test python=$PYTHON -y
micromamba activate test
micromamba install delocate build -y
```

## Install VTK and OCP wheel

```bash
pip install VTK/wheel/*.whl
pip install OCP/wheel/*.whl
```

## Verify OCP

```bash
python -c "import OCP"
```

## Install cadquery

```bash
git clone https://github.com/cadquery/cadquery.git
cd cadquery
pip install .
pip install pytest docutils ipython
```

## Run tests

```bash
pytest tests
```