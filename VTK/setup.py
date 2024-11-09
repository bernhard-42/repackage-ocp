from distutils.dist import Distribution

from setuptools import find_packages, setup


class BinaryDistribution(Distribution):
    def has_ext_modules(self):
        return True


setup(
    name="cadquery_vtk",
    author="Bernhard Walter (pypi packaging for cadquery)",
    author_email="b_walter@arcor.de",
    description="Unchanged VTK, just pypi packaged for cadquery",
    version="9.2.6",
    python_requires=">=3.10",
    packages=find_packages(
        include=[
            "vtkmodules",
            "vtkmodules.*",
        ]
    ),
    py_modules=["vtk"],
    package_data={
        "vtkmodules": ["*.so", "*.py", "*/*.py", "*/*.dylib"],
    },
    distclass=BinaryDistribution,
    include_package_data=True,
    platforms=["macOS"],
    zip_safe=False,
    install_requires=[],
)
