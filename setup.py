import os
import platform


def make_symlink():
    home = os.path.expanduser("~")
    nvim = "nvim"
    dotfiles = os.path.join(home, "dotfiles")
    nvim_src = os.path.join(dotfiles, nvim)
    nvim_dst = os.path.join(home, ".config", nvim)
    if platform.system() == "Windows":
        nvim_dst = os.path.join(os.environ["LOCALAPPDATA"], nvim)
    symlink(nvim_src, nvim_dst)
    omnisharp = ".omnisharp"
    omni_src = os.path.join(dotfiles, "scripts", omnisharp)
    omni_dst = os.path.join(home, omnisharp)
    symlink(omni_src, omni_dst)


def symlink(src, dst):
    if os.path.exists(dst):
        os.remove(dst)
        print(f"remove {dst}")
    os.symlink(src, dst, target_is_directory=True)
    print(f"symlink {src} -> {dst}")


if __name__ == "__main__":
    make_symlink()
