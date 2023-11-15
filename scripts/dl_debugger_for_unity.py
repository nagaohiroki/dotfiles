import os
import zipfile
import requests
import shutil


def dl_debugger():
    ext_dir = os.path.join(os.path.expanduser("~"), ".vscode", "extensions")
    tmp_dir = os.path.join(ext_dir, "tmp")
    new_dir = os.path.join(ext_dir, "deitry.unity-debug-3.0.11")
    zip_path = os.path.join(tmp_dir, "unity_debugger.zip")
    if os.path.exists(tmp_dir):
        shutil.rmtree(tmp_dir)
    if os.path.exists(new_dir):
        shutil.rmtree(new_dir)
    downloader = requests.get(
        f"https://marketplace.visualstudio.com/_apis/public/gallery/publishers/deitry/vsextensions/unity-debug/3.0.11/vspackage"
    )
    if downloader.status_code != 200:
        print(downloader.status_code)
        return
    os.makedirs(tmp_dir)
    with open(zip_path, "wb") as f:
        f.write(downloader.content)
    with zipfile.ZipFile(zip_path, "r") as zip_ref:
        zip_ref.extractall(path=tmp_dir)
        old_dir = os.path.join(tmp_dir, "extension")
        os.rename(old_dir, new_dir)
        shutil.rmtree(tmp_dir)


if __name__ == "__main__":
    dl_debugger()
