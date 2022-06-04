import os
import neovim
import subprocess
import sys
import platform
try:
    import win32gui
except Exception as e:
    pass


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
    activate_neovim()


def open_neovim(address):
    nvim = 'nvim-qt'
    if platform.system() == 'Darwin':
        nvim = '/Applications/nvim-qt.app/Contents/MacOS/nvim-qt'
    cmd = [nvim, '--', '--listen', address] + sys.argv[1:]
    subprocess.Popen(cmd)


def activate_neovim():
    if platform.system() == 'Windows':
        win32gui.EnumWindows(activate_win32, None)
    if platform.system() == 'Darwin':
        subprocess.Popen(['open', '/Applications/nvim-qt.app'])


def main():
    server_address = '\\\\.\\pipe\\nvim'
    if platform.system() == 'Darwin':
        server_address = '/tmp/nvim'
    try:
        neovim_command(server_address)
    except Exception as e:
        print(e)
        open_neovim(server_address)


if __name__ == "__main__":
    main()
