def _vtkmodules():
    import os
    libs_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir, 'vtkmodules'))
    os.add_dll_directory(libs_dir)

_vtkmodules()
del _vtkmodules

from OCP.OCP import * 