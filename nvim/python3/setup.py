import os
import platform
import pathlib
import shutil
import ctypes
import sys
import typing


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


def is_admin() -> bool:
    try:
        return typing.cast(bool, ctypes.windll.shell32.IsUserAnAdmin())
    except Exception:
        return False


def relaunch_as_admin():
    params = " ".join(sys.argv)
    ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, params, None, 1)


def symlinks():
    symlink(dotfiles() / "nvim", xdg() / "nvim")
    symlink(dotfiles() / "wezterm", config() / "wezterm")
    if is_windows():
        return
    symlink(dotfiles() / ".zshrc", home() / ".zshrc")
    symlink(dotfiles() / ".zprofile", home() / ".zprofile")


def main():
    if is_windows():
        if not is_admin():
            relaunch_as_admin()
            return
    symlinks()
    _ = input("Press Enter to exit...")


if __name__ == "__main__":
    main()
