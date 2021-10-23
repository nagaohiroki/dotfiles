import os
import neovim
import subprocess
import sys
import platform


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
        if platform.system() == 'Windows':
            cmd[0] = 'nvim-qt'
        if platform.system() == 'Darwin':
            cmd = ['open', '-a', 'goneovim'] + cmd[1:]
        subprocess.Popen(cmd)


if __name__ == "__main__":
    main()
