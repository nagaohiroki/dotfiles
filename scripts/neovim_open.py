import os
import neovim
import subprocess
import sys


def func(address, cmd):
    nvim = neovim.attach('socket', path=address)
    nvim.command(cmd)
    nvim.close()


def main():
    env = os.path.join(os.path.expanduser('~'), '.cache_neovim', 'env.txt')
    if not os.path.exists(env):
        return
    f = open(env)
    address = f.readlines()[1]
    cmd = sys.argv;
    try:
        cmd[0] = 'edit'
        func(address, ' '.join(cmd))
    except:
        cmd[0] = 'nvim-qt'
        subprocess.Popen(cmd, shell=True)


if __name__ == "__main__":
    main()
