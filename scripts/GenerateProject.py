import subprocess
import os
import json


def generate_project():
    with open(os.path.join(os.path.expanduser('~'), 'ue_config.json'), 'r') as f:
        config = json.load(f)
    engine = config['engine']
    project = config['project']
    bat = os.path.join(engine, 'Engine', 'Build', 'BatchFiles', 'Build.bat')
    subprocess.call([
            bat,
            '-projectfiles',
            '-project=' + project,
            '-game',
            '-rocket',
            '-progress'
            ], shell=True)
    prj, _ = os.path.splitext(os.path.basename(project))
    subprocess.call([
            bat,
            '-mode=GenerateClangDatabase',
            '-game',
            '-engine',
            '-project=' + project,
            prj + 'Editor',
            'Development',
            'Win64',
            ], shell=True)
    database = 'compile_commands.json'
    with open(os.path.join(engine, database), 'r') as reader:
        with open(os.path.join(os.path.dirname(project), database), 'w') as writer:
            read = reader.read().replace('-std=', '/std:')
            writer.write(read)


if __name__ == "__main__":
    generate_project()
