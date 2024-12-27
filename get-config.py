import yaml
import json
import multiprocessing

ind = 0

with open(".github/workflows/build-ocp.yml", "r") as f: y = f.read()
d = yaml.safe_load(y)
result = {"env": d["env"]}
result["matrix"] = {
    "os":d["jobs"]["build"]["strategy"]["matrix"]["os"][ind], 
    "python-version":d["jobs"]["build"]["strategy"]["matrix"]["python-version"][ind]
}
result["matrix"].update(d["jobs"]["build"]["strategy"]["matrix"]["include"][ind])
result["steps"] = {"cpu-count":{"outputs":{"cpu_count": multiprocessing.cpu_count()}}}

with open("conf.json", "w") as f:
    json.dump(result, f)