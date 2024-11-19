.phony: clean clean-all wheel

clean:
	@rm -rf build cadquery_vtk cadquery_vtk.egg-info dist wheel libs

clean-all: clean
	@rm -fr  vtk.py vtkmodules

wheel: clean
	@python -m build -n -w

delocate:
	env MACOSX_DEPLOYMENT_TARGET=11.1 \
    DYLD_LIBRARY_PATH=./libs:$$CONDA_PREFIX/lib \
    python -m delocate.cmd.delocate_wheel \
    --wheel-dir=wheel \
    dist/*.whl
