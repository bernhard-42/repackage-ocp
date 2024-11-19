
mamba create -y -n ocp python=3.11
mamba activate ocp
mamba install -y -c conda-forge ocp=7.7.2.1
mamba install -y build wheel

# PLATFORM=${{ matrix.plat }}
PLATFORM=macosx_11_0_arm64
PY_VER=$(python -c "import sys; print(f'cp{sys.version_info.major}{sys.version_info.minor}')")

cd VTK
cp -r $CONDA_PREFIX/lib/python3.11/site-packages/vtkmodules .
cp $CONDA_PREFIX/lib/python3.11/site-packages/vtk.py .

mkdir libs
cp $CONDA_PREFIX/lib/libvtk*9.2.1.* libs

cd vtkmodules
for l in *.so; do \
    install_name_tool -delete_rpath "@loader_path/../../../" "$l"; \
done
codesign --force --sign - *.so
cd ..

python -m build -n -w

python -m wheel \
    tags --remove \
         --platform-tag  $PLATFORM \
         --abi-tag $PY_VER \
         --python-tag $PY_VER \
    dist/*.whl

env MACOSX_DEPLOYMENT_TARGET=11.1 \
    DYLD_LIBRARY_PATH=./libs:$CONDA_PREFIX/lib \
    python -m delocate.cmd.delocate_wheel \
    --wheel-dir=wheel \
    dist/*.whl

cd ..