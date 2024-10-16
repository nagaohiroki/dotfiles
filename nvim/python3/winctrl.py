import pywinctl
import sys
import json


class NvimWinCtrl:
    def execute(self, params):
        if params is None:
            return
        self.window = params["window"]
        method = params["method"]
        if method == "resize":
            w = int(params["width"])
            h = int(params["height"])
            self.resize(w, h)
        elif method == "activate":
            self.activate()

    def resize(self, width, height):
        wins = self.windows()
        for w in wins:
            w.size = (w.size[0] + width, w.size[1] + height)

    def activate(self):
        wins = self.windows()
        for w in wins:
            w.activate()

    def windows(self):
        return pywinctl.getWindowsWithTitle(self.window, condition=pywinctl.Re.CONTAINS)


if __name__ == "__main__":
    param = json.loads(sys.argv[0])
    NvimWinCtrl().execute(param)
