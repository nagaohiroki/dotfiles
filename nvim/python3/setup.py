import os
import platform
import pathlib
import shutil


def is_windows() -> bool:
    return platform.system() == "Windows"


def home() -> pathlib.Path:
    return pathlib.Path.home()


def dotfiles() -> pathlib.Path:
    return home() / "dotfiles"


def config() -> pathlib.Path:
    return home() / ".config"


def xdg() -> pathlib.Path:
    if is_windows():
        return pathlib.Path(os.environ["LOCALAPPDATA"])
    return config()


def remove_path(path: pathlib.Path):
    if path.is_symlink() or path.is_file():
        path.unlink()
        print(f"remove file {path}")
    elif path.is_dir():
        shutil.rmtree(path)
        print(f"remove dir {path}")


def symlink(src: pathlib.Path, dst: pathlib.Path):
    if not src.exists():
        print(f"skip symlink {src} -> {dst}")
        return
    if dst.exists():
        remove_path(dst)
    dst.parent.mkdir(parents=True, exist_ok=True)
    os.symlink(src, dst, target_is_directory=src.is_dir())
    print(f"symlink {src} -> {dst}")


def main():
    symlink(dotfiles() / "nvim", xdg() / "nvim")
    symlink(dotfiles() / "wezterm", config() / "wezterm")
    if is_windows():
        return
    symlink(dotfiles() / ".zshrc", home() / ".zshrc")
    symlink(dotfiles() / ".zprofile", home() / ".zprofile")


if __name__ == "__main__":
    main()
