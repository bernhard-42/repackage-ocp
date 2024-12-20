.PHONY: clean

clean:
	rm -fr ./OCCT ./OCP ./build123d ./cadquery
	rm -fr pypi/build pypi/cadquery_ocp_novtk pypi/cadquery_ocp_novtk.egg-info pypi/dist pypi/OCP pypi/wheel
	rm -fr /opt/local/occt-7.7.2/ /opt/local/vtk-9.2.6/ /opt/usr/local/include
	rm -f /usr/local/include/OpenGL
	if micromamba env list | grep -q "^\s*build-ocp\s"; then \
		@echo "Removing build-ocp environment"; \
		micromamba env remove -y -n build-ocp; \
	fi
	if micromamba env list | grep -q "^\s*vtk\s"; then \
		@echo "Removing vtk environment"; \
		micromamba env remove -y -n vtk; \
	fi
	if micromamba env list | grep -q "^\s*test\s"; then \
		@echo "Removing test environment"; \
		micromamba env remove -y -n vtk; \
	fi

	micromamba env list
	unset LDFLAGS
	unset CPPFLAGS
	unset Clang_DIR
	unset LLVM_DIR
	PATH=$(echo $PATH | tr ':' '\n' | grep -v /opt/homebrew/opt/llvm@15/bin | paste -s -d':' -)
	
	