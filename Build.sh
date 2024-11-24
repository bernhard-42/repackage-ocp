# - - - - - - - - - - - - - - OCCT - - - - - - - - - - - - - - 

brew install freeimage rapidjson ninja cmake

# Create an environment with conda VTK to get the include files
mamba create -y -n vtk python=3.11
mamba activate vtk
mamba install -y vtk=9.2.6

rm -fr /opt/local/vtk-9.2.6
mkdir -p /opt/local/vtk-9.2.6/include
mkdir -p /opt/local/vtk-9.2.6/lib
mkdir -p /opt/local/vtk-9.2.6/lib/cmake
cp -r $CONDA_PREFIX/include/vtk-9.2/ /opt/local/vtk-9.2.6/include/
cp cmake/vtk-config.cmake /opt/local/vtk-9.2.6/lib/cmake
mamba deactivate

# Create an environment with pypi VTK to get the VTK shared libraries
mamba create -y -n build-ocp python=3.11
mamba activate build-ocp
pip install vtk==9.2.6
cp $CONDA_PREFIX/lib/python3.11/site-packages/vtkmodules/.dylibs/* /opt/local/vtk-9.2.6/lib/
cp $CONDA_PREFIX/lib/python3.11/site-packages/vtk.py /opt/local/vtk-9.2.6
cp -r $CONDA_PREFIX/lib/python3.11/site-packages/vtkmodules /opt/local/vtk-9.2.6

# Clone OCCT and checkout 7.7.2
git clone https://github.com/Open-Cascade-SAS/OCCT.git
cd OCCT
git checkout -b V7_7_2 tags/V7_7_2

# Build OCCT (inspired by: conda's occt-7.7.2-all_h1e2436f_201)
rm -fr build

sed -i ".bak" 's/const char\* aTags/const unsigned char\* aTags/' src/StdPrs/StdPrs_BRepFont.cxx

cmake -S . -B build  -G Ninja \
      -D CMAKE_INSTALL_PREFIX=/opt/local/occt-7.7.2 \
      \
      -D USE_TBB=OFF \
      -D USE_FREEIMAGE=ON \
      -D USE_FREETYPE=ON \
      -D USE_RAPIDJSON=ON \
      -D USE_FFMPEG=OFF \
      \
      -D BUILD_CPP_STANDARD=C++11 \
      -D CMAKE_OSX_DEPLOYMENT_TARGET="11.1" \
      -D CMAKE_BUILD_TYPE="Release" \
      -D BUILD_RELEASE_DISABLE_EXCEPTIONS=OFF \
      -D BUILD_MODULE_Draw=OFF \
      \
      -D USE_VTK=ON \
      -D VTK_RENDERING_BACKEND="OpenGL2" \
      -D 3RDPARTY_VTK_INCLUDE_DIR=/opt/local/vtk-9.2.6/include/ \
      -D 3RDPARTY_VTK_LIBRARY_DIR=/opt/local/vtk-9.2.6/lib/ \
      -D CMAKE_CXX_STANDARD_LIBRARIES="-lvtkCommonMath-9.2 -lvtkCommonTransforms-9.2 -lvtksys-9.2 -lvtkCommonExecutionModel-9.2 -lvtkCommonDataModel-9.2"

# Patch build file to use VTK libraries with "9.2" suffix
for l in vtkCommonCore  vtkRenderingCore  vtkRenderingFreeType  vtkFiltersGeneral  vtkInteractionStyle  vtkRenderingOpenGL2; do
    sed -i ".bak" "s/-l$l/-l$l-9.2/" build/build.ninja
done
rm build/build.ninja.bak

# Build OCCT
ninja -C build -j 10
ninja -C build install

cd .. # OCCT

# - - - - - - - - - - - - - - OCP - - - - - - - - - - - - - - 

brew install llvm@15

# Link llvm@15 compiler
export PATH="/opt/homebrew/opt/llvm@15/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm@15/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm@15/include"
export Clang_DIR=${brew --prefix}/Cellar/llvm@15/15.0.7/lib/cmake/clang
export LLVM_DIR=${brew --prefix}/Cellar/llvm@15/15.0.7/lib/cmake/llvm/
export CC=${brew --prefix}/Cellar/llvm@15/15.0.7/bin/clang
export CXX=${brew --prefix}/opt/llvm@15/bin/clang++
export CPATH=/opt/homebrew/include
export LDFLAGS="-L/opt/local/vtk-9.2.6/lib"

# For code generation clang 15 and MacOS SDK 11.3 are mandatory
mkdir -p /opt/usr/local
curl -L -O https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX11.3.sdk.tar.xz
tar -xf MacOSX11.3.sdk.tar.xz -C /opt
sudo mkdir -p /opt/usr/local/
sudo ln -s /opt/MacOSX11.3.sdk/usr/include /opt/usr/local/include
sudo ln -s /opt/MacOSX11.3.sdk/System/Library/Frameworks/OpenGL.framework/Headers /usr/local/include/OpenGL

# Clone OCP and checkout 7.7.2.1
git clone https://github.com/cadquery/OCP.git
cd OCP
git checkout -b V7.7.2.1 tags/7.7.2.1
git submodule update --init

# Use the OCCT 7.7.2 includes
# mv opencascade opencascade.orig
# ln -s /opt/local/occt-7.7.2/include/opencascade opencascade

# Install Python dependencies
pip install "pybind11==2.10.*" logzero toml "numpy==1.26.4" "pandas<2" joblib path tqdm jinja2 toposort schema click lief "clang==15.0.7"


cmake -B new -S . -G Ninja -D N_PROC=10 \
    -D VTK_DIR=/opt/local/vtk-9.2.6/lib/cmake \
    -D OpenCASCADE_DIR=/opt/local/occt-7.7.2/lib/cmake/opencascade \
    -D pybind11_DIR=$(python -c "import pybind11; print(pybind11.get_cmake_dir())") \
    -D CMAKE_OSX_SYSROOT=/opt/MacOSX11.3.sdk

# Build OCP
cmake -B build -S OCP -G Ninja \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_OSX_DEPLOYMENT_TARGET="11.1" \
    -D CMAKE_CXX_FLAGS="-I $(brew --prefix)/include" \
    -D VTK_DIR=/opt/local/vtk-9.2.6/lib/cmake \
    -D OpenCASCADE_DIR=/opt/local/occt-7.7.2/lib/cmake/opencascade \
    -D pybind11_DIR=$(python -c "import pybind11; print(pybind11.get_cmake_dir())") \
    -D CMAKE_CXX_STANDARD=17 \
    -D CMAKE_OSX_SYSROOT=/opt/MacOSX11.3.sdk

ninja -C build -j 10
