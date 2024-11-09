from distutils.dist import Distribution

from setuptools import Extension, find_packages, setup


class BinaryDistribution(Distribution):
    def has_ext_modules(self):
        return True


setup(
    name="cadquery-ocp",
    author="Bernhard Walter (pypi packaging for cadquery)",
    author_email="b_walter@arcor.de",
    description="Unchanged OCP, just pypi packaged",
    version="7.7.2",
    python_requires=">=3.10",
    packages=[
        "",
        "cadquery_ocp",
        "cadquery_ocp.include",
    ],
    package_data={
        "": ["OCP.cpython-311-darwin.so"],
        "cadquery_ocp": [
            "include/*",
        ],
    },
    include_package_data=True,
    distclass=BinaryDistribution,
    platforms=["macOS"],
    zip_safe=False,
    install_requires=[],
)
