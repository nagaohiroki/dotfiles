import os
import neovim
import subprocess
import sys
import platform


def neovim_command(address):
    cmd = sys.argv[1:]
    edit = 'exe "e "'
    for c in cmd:
        if c.startswith('+'):
            edit += f' . \'{c} \''
            continue
        edit += f' . fnameescape(\'{c}\') '
    nvim = neovim.attach('socket', path=address)
    print(edit)
    nvim.command(edit)
    nvim.close()


def open_neovim():
    cmd = sys.argv
    if platform.system() == 'Windows':
        cmd[0] = 'nvim-qt'
    if platform.system() == 'Darwin':
        cmd[0] = '/Applications/goneovim.app/Contents/MacOS/goneovim'
    subprocess.Popen(cmd)


def activate_neovim():
    if platform.system() == 'Darwin':
        subprocess.Popen(['open', '-a', 'goneovim'])


def main():
    env = os.path.join(os.path.expanduser('~'), '.cache_neovim', 'env.txt')
    if not os.path.exists(env):
        open_neovim()
        return
    f = open(env)
    address = f.readline()
    try:
        neovim_command(address)
        activate_neovim()
    except:
        open_neovim()


if __name__ == "__main__":
    main()
