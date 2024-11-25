import os
import sys
import platform
import subprocess
import pathlib


def make_symlink():
    home = pathlib.Path.home()
    nvim = "nvim"
    nvim_src = home.joinpath("dotfiles").joinpath(nvim)
    nvim_dst = home.joinpath(".config", nvim)
    if platform.system() == "Windows":
        nvim_dst = pathlib.Path(os.environ["LOCALAPPDATA"], nvim)
    symlink(nvim_src, nvim_dst)


def symlink(src, dst):
    if dst.exists():
        os.remove(dst)
        print(f"remove {dst}")
    os.symlink(src, dst, target_is_directory=True)
    print(f"symlink {src} -> {dst}")


def install_requirements():
    requirements = pathlib.Path.home().joinpath("dotfiles", "requirements.txt")
    subprocess.run(
        [sys.executable, "-m", "pip", "install", "--upgrade", "-r", requirements]
    )


if __name__ == "__main__":
    install_requirements()
    make_symlink()
