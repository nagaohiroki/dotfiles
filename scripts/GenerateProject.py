import subprocess
import os
import json
import glob


def generate_project(engine, uproject):
    pj_dir = os.path.dirname(uproject)
    name = os.path.basename(pj_dir)
    bat = os.path.join(engine, "Engine", "Build", "BatchFiles", "Build.bat")
    sln = [bat, "-projectfiles", f"-project={uproject}", "-game", "-engine"]
    database = [
        bat,
        "-mode=GenerateClangDatabase",
        "-game",
        "-engine",
        f"-project={uproject}",
        f"{name}Editor",
        "Development",
        "Win64",
        f"-OutputDir={pj_dir}",
    ]
    subprocess.call(sln, shell=True)
    subprocess.call(database, shell=True)


def find_uproject(cur=os.getcwd()):
    uproject = glob.glob(os.path.join(cur, "*.uproject"))
    if len(uproject) > 0:
        return uproject[0]
    else:
        new_cur = os.path.dirname(cur)
        if new_cur == cur:
            return None
        return find_uproject(new_cur)


def find_ue_path():
    gameuser = os.path.join(
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
                return line.replace(install_dir, "").replace("\n", "")


def main():
    uproject = find_uproject()
    if uproject is None:
        return
    with open(uproject, "r") as f:
        dic = json.load(f)
        ver = dic["EngineAssociation"]
        engine_dir = find_ue_path()
        if engine_dir is None:
            return
        engine = os.path.join(engine_dir, f"UE_{ver}")
        generate_project(engine, uproject)


if __name__ == "__main__":
    main()
