import os
import platform
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


if __name__ == "__main__":
    make_symlink()
