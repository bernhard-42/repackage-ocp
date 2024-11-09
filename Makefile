.phony clean

clean:
	rm -fr VTK/build
	rm -fr VTK/cadquery_vtk.egg-info
	rm -fr VTK/dist
	rm -fr VTK/libs
	rm -fr VTK/vtk.py
	rm -fr VTK/vtk.pybak
	rm -fr VTK/vtkmodules
	rm -fr VTK/wheel

	rm -fr OCP/OCP.*.so
	rm -fr OCP/build
	rm -fr OCP/cadquery_ocp
	rm -fr OCP/cadquery_ocp.egg-info
	rm -fr OCP/dist
	rm -fr OCP/wheel