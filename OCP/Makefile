.phony: clean clean-all wheel

PY_TAG := $(shell python -c "import sys; print(f'cp{sys.version_info.major}{sys.version_info.minor}')")
PLATFORM := macosx_11_0_arm64
MINOS=11.1

clean:
	@rm -rf build cadquery_ocp.egg-info dist wheel

clean-all: clean
	@rm -fr  OCP.cpython-$(PY_TAG)-darwin.so

wheel: clean
	@python -m build -n -w

rename-wheel:
	python -m wheel tags --remove --platform-tag  $(PLATFORM) --abi-tag $(PY_TAG) --python-tag $(PY_TAG) dist/*.whl

delocate:
	env MACOSX_DEPLOYMENT_TARGET=$(MINOS) \
    DYLD_LIBRARY_PATH=../VTK/libs:$$CONDA_PREFIX/lib \
    python -m delocate.cmd.delocate_wheel \
    -e libvtk \
    --wheel-dir=wheel \
    dist/*.whl
