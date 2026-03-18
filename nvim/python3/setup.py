import os
import platform
import pathlib
import shutil
import ctypes
import sys
import typing


DRY_RUN = "--dry-run" in sys.argv
INTERACTIVE = "--interactive" in sys.argv


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
    if DRY_RUN:
        print(f"remove {path} (dry run)")
        return
    if INTERACTIVE:
        ans = input(f"remove {path}? [y/N] ")
        if ans.lower() != "y":
            print(f"skip {path}")
            return
    if path.is_symlink() or path.is_file():
        path.unlink()
        print(f"remove file {path}")
    elif path.is_dir():
        shutil.rmtree(path)
        print(f"remove dir {path}")


def symlink(src: pathlib.Path, dst: pathlib.Path):
    if not src.exists():
        print(f"skip symlink {src} -> {dst} (not exists)")
        return
    if dst.exists():
        remove_path(dst)
    if DRY_RUN:
        print(f"symlink {src} -> {dst} (dry run)")
        return
    if INTERACTIVE:
        ans = input(f"symlink {src} -> {dst}? [y/N] ")
        if ans.lower() != "y":
            print(f"skip {src} -> {dst}")
            return
    dst.parent.mkdir(parents=True, exist_ok=True)
    os.symlink(src, dst, target_is_directory=src.is_dir())
    print(f"symlink {src} -> {dst}")


def is_admin() -> bool:
    try:
        return typing.cast(bool, ctypes.windll.shell32.IsUserAnAdmin())
    except Exception:
        return False


def relaunch_as_admin():
    params = " ".join([f'"{arg}"' for arg in sys.argv])
    ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, params, None, 1)


def dotlink(dir: pathlib.Path, filename: str):
    symlink(dotfiles() / filename, dir / filename)


def dotfiles_symlink():
    dotlink(xdg(), "nvim")
    dotlink(config(), "wezterm")
    if is_windows():
        dotlink(home() / "Documents" / "PowerShell", "Microsoft.PowerShell_profile.ps1")
        return
    dotlink(home(), ".zshrc")
    dotlink(home(), ".zprofile")


def main():
    if is_windows():
        if not is_admin():
            relaunch_as_admin()
            return
    dotfiles_symlink()
    if is_windows():
        _ = input("Press Enter to exit...")


if __name__ == "__main__":
    main()
