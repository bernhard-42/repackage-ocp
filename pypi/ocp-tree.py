import inspect
from pathlib import Path
import shutil

import OCP

def traverse(module, p, depth=0):
    prefix = "  " * depth
    print(f"{prefix}{module.__name__}")

    for name, obj in inspect.getmembers(module):
        if inspect.ismodule(obj) and obj.__name__.startswith(module.__name__):
            Path.mkdir(p / name, exist_ok=True)
            p2 = Path(p / name)
            with open(p2 / "__init__.py", "w") as f:
                f.write(f"from ..{obj.__name__} import *\n")
            traverse(obj, p2, depth + 1)


Path.mkdir(Path.cwd() / "OCP", exist_ok=True)
p = Path.cwd() / "OCP"
shutil.copy("__ini__.py", Path.cwd() / "OCP")
traverse(OCP, p)