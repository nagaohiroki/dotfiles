import pywinctl


def activate(title_name):
    wins = pywinctl.getWindowsWithTitle(title_name, condition=pywinctl.Re.CONTAINS)
    for win in wins:
        win.activate()


if __name__ == "__main__":
    activate("NVIM")
