import sys
import os

ATLAS_CONF_PATH=os.getenv("ATLAS_CONF_INSTALL", ".") + "/atlas-application.properties"

if __name__ == "__main__":
    keys=list(map(lambda x: str.split(x, "=")[0], sys.argv[1:]))
    filtered = []
    with open(ATLAS_CONF_PATH, "r") as fr:
        filtered = list(filter(lambda y: str.split(y, "=")[0] not in keys, fr))
    with open(ATLAS_CONF_PATH, "w") as fw:
        map(lambda z: fw.write(z + "\n"), filtered + sys.argv[1:])
