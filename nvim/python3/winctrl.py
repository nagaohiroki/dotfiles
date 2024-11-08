import sys
import json
import pywinctl


class NvimWinCtrl:
    def execute(self, params):
        self.window = params["window"]
        self.width = params["width"]
        self.height = params["height"]
        getattr(self, params["method"])()

    def resize(self):
        wins = self.windows()
        for w in wins:
            w.resize(self.width, self.height)

    def move(self):
        wins = self.windows()
        for w in wins:
            w.move(self.width, self.height)

    def activate(self):
        wins = self.windows()
        for w in wins:
            w.activate()

    def windows(self):
        return pywinctl.getWindowsWithTitle(self.window, condition=pywinctl.Re.CONTAINS)


if __name__ == "__main__":
    param = json.loads(sys.argv[0])
    NvimWinCtrl().execute(param)
