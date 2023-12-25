import subprocess
import os
import json


def generate_project():
    ue_config = os.path.join(os.path.expanduser("~"), "ue_config.json")
    if not os.path.exists(ue_config):
        config_dict = {
            "project": "C:\\work\\yourprojectdir",
            "engine": "C:\\Program Files\\Epic Games\\UE_5.3",
        }
        with open(ue_config, "w") as f:
            json.dump(config_dict, f, indent=4)
        print("Please edit " + ue_config)
        return
    with open(ue_config, "r") as f:
        config = json.load(f)
    engine = config["engine"]
    if not os.path.exists(engine):
        print("not found " + engine + " in " + ue_config)
        return
    project_dir = config["project"]
    if not os.path.exists(project_dir):
        print("not found " + project_dir + " in " + ue_config)
        return
    project_name = os.path.basename(project_dir)
    uproject = os.path.join(project_dir, project_name + ".uproject")
    bat = os.path.join(engine, "Engine", "Build", "BatchFiles", "Build.bat")
    subprocess.call(
        [
            bat,
            "-projectfiles",
            "-project=" + uproject,
            "-game",
            "-rocket",
            "-progress",
        ],
        shell=True,
    )
    subprocess.call(
        [
            bat,
            "-mode=GenerateClangDatabase",
            "-game",
            "-engine",
            "-project=" + uproject,
            project_name + "Editor",
            "Development",
            "Win64",
        ],
        shell=True,
    )
    database = "compile_commands.json"
    src = os.path.join(engine, database)
    dst = os.path.join(project_dir, database)
    os.replace(src, dst)


if __name__ == "__main__":
    generate_project()
