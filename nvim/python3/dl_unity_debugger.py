import os
import sys
import zipfile
import requests
import shutil
import json


def dl_debugger(url, out_dir):
    if os.path.exists(out_dir):
        shutil.rmtree(out_dir)
    os.makedirs(out_dir)
    response = requests.get(url)
    if response.status_code != 200:
        print(response.status_code)
        return
    zip_path = os.path.join(out_dir, "tmp.zip")
    with open(zip_path, "wb") as f:
        f.write(response.content)
    with zipfile.ZipFile(zip_path, "r") as zip_ref:
        zip_ref.extractall(path=out_dir)
    os.remove(zip_path)


def main():
    if len(sys.argv) > 1:
        return
    json_str = sys.argv[0]
    json_str = json_str.replace("\\", "/")
    dic = json.loads(json_str)
    dl_debugger(dic["url"], dic["out"])


if __name__ == "__main__":
    main()
