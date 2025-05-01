import os
import platform
import pathlib


def make_symlink():
    nvim = "nvim"
    src = pathlib.Path.home().joinpath("dotfiles", nvim)
    if platform.system() == "Windows":
        symlink(src, pathlib.Path(os.environ["LOCALAPPDATA"], nvim))
    else:
        symlink(src, pathlib.Path.home().joinpath(".config", nvim))


def symlink(src: pathlib.Path, dst: pathlib.Path):
    if dst.exists():
        os.remove(dst)
        print(f"remove {dst}")
    os.symlink(src, dst, target_is_directory=True)
    print(f"symlink {src} -> {dst}")


if __name__ == "__main__":
    make_symlink()
