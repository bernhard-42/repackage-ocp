import json
import multiprocessing
import yaml
import sys

ind = 0

workflow = sys.argv[1]
vtk = sys.argv[2]

with open(f".github/workflows/{workflow}.yml", "r") as f:
    y = f.read()
d = yaml.safe_load(y)
result = {"env": d["env"]}
result["matrix"] = {
    "os": d["jobs"]["build"]["strategy"]["matrix"]["os"][ind],
    "python-version": d["jobs"]["build"]["strategy"]["matrix"]["python-version"][ind],
    "use-vtk": vtk,
}
result["matrix"].update(d["jobs"]["build"]["strategy"]["matrix"]["include"][ind])
result["steps"] = {"cpu-count": {"outputs": {"cpu_count": multiprocessing.cpu_count()}}}

with open(f"conf-{workflow}.json", "w") as f:
    json.dump(result, f)
