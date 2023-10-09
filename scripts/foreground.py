import pywinctl


def activate(title_name):
    titles = pywinctl.getAllTitles()
    for title in titles:
        if title_name in title:
            wins = pywinctl.getWindowsWithTitle(title)
            for win in wins:
                win.activate()


if __name__ == "__main__":
    activate("NVIM")
