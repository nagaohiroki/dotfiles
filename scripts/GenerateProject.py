import subprocess
import os
import json


def generate_project():
    with open(os.path.join(os.path.expanduser("~"), "ue_config.json"), "r") as f:
        config = json.load(f)
    project = config["project"]
    engine = config["engine"]
    bat = os.path.join(engine, "Engine", "Build", "BatchFiles", "Build.bat")
    subprocess.call(
        [bat, "-projectfiles", "-project=" + project, "-game", "-rocket", "-progress"],
        shell=True,
    )
    prj, _ = os.path.splitext(os.path.basename(project))
    subprocess.call(
        [
            bat,
            "-mode=GenerateClangDatabase",
            "-game",
            "-engine",
            "-project=" + project,
            prj + "Editor",
            "Development",
            "Win64",
        ],
        shell=True,
    )
    database = "compile_commands.json"
    src = os.path.join(engine, database)
    dst = os.path.join(os.path.dirname(project), database)
    os.replace(src, dst)


if __name__ == "__main__":
    generate_project()
