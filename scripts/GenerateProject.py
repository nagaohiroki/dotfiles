import subprocess
import os
import json
import pathlib


def build(engine, uproject):
    bat = str(engine.joinpath("Engine", "Build", "BatchFiles", "Build.bat"))
    sln = [bat, "-projectfiles", f"-project={uproject}", "-game", "-engine"]
    database = [
        bat,
        "-mode=GenerateClangDatabase",
        "-game",
        "-engine",
        f"-project={uproject}",
        f"{uproject.stem}Editor",
        "Development",
        "Win64",
        f"-OutputDir={uproject.parent}",
    ]
    subprocess.call(sln, shell=True)
    subprocess.call(database, shell=True)


def find_uproject_path(cur: pathlib.Path):
    uproject = list(cur.glob("*.uproject"))
    if len(uproject) > 0:
        return uproject[0]
    new_cur = cur.parent
    if new_cur == cur:
        return None
    return find_uproject_path(new_cur)


def find_ue_path():
    gameuser = pathlib.Path(
        os.environ["LOCALAPPDATA"],
        "EpicGamesLauncher",
        "Saved",
        "Config",
        "Windows",
        "GameUserSettings.ini",
    )
    with open(gameuser, "r") as f:
        for line in f:
            install_dir = "DefaultAppInstallLocation="
            if line.startswith(install_dir):
                ue_path = line.replace(install_dir, "").replace("\n", "")
                return pathlib.Path(ue_path)


def main():
    uproject = find_uproject_path(pathlib.Path.cwd())
    if uproject is None:
        return
    with open(uproject, "r") as f:
        dic = json.load(f)
        ver = dic["EngineAssociation"]
        engine = find_ue_path()
        if engine is None:
            return
        build(engine.joinpath(f"UE_{ver}"), uproject)


if __name__ == "__main__":
    main()
