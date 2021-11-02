import os
import neovim
import subprocess
import sys
import platform


app = '/Applications/nvim-qt.app'

def neovim_command(address):
    nvim = neovim.attach('socket', path=address)
    if len(sys.argv) > 1:
        cmd = sys.argv[1:]
        edit = 'exe "e "'
        for c in cmd:
            if c.startswith('+'):
                edit += f' . \' {c} \''
                continue
            edit += f' . fnameescape(\'{c}\') '
        nvim.command(edit)
    nvim.close()
    activate_neovim()


def open_neovim():
    cmd = sys.argv
    if platform.system() == 'Windows':
        cmd[0] = 'nvim-qt'
    if platform.system() == 'Darwin':
        cmd[0] = os.path.join(app, 'Contents/MacOS/nvim-qt')
    subprocess.Popen(cmd)


def activate_neovim():
    if platform.system() == 'Darwin':
        subprocess.Popen(['open', app])


def main():
    env = os.path.join(os.path.expanduser('~'), '.cache_neovim', 'env.txt')
    if not os.path.exists(env):
        open_neovim()
        return
    f = open(env)
    address = f.readline()
    try:
        neovim_command(address)
    except Exception as e:
        print(e)
        open_neovim()


if __name__ == "__main__":
    main()
