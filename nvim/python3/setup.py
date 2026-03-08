import os
import platform
import pathlib


def make_symlink(dir: str, is_xdg: bool):
    src = pathlib.Path.home().joinpath("dotfiles", dir)
    if is_xdg:
        symlink(src, pathlib.Path(os.environ["LOCALAPPDATA"], dir))
    else:
        symlink(src, pathlib.Path.home().joinpath(".config", dir))


def symlink(src: pathlib.Path, dst: pathlib.Path):
    if dst.exists():
        os.remove(dst)
        print(f"remove {dst}")
    dst.parent.mkdir(parents=True, exist_ok=True)
    os.symlink(src, dst, target_is_directory=True)
    print(f"symlink {src} -> {dst}")


if __name__ == "__main__":
    make_symlink("nvim", platform.system() == "Windows")
    make_symlink("wezterm", False)
