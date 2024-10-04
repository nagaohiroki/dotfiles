import pywinctl
import sys
import json


class NvimWinCtrl:
    def execute(self, params):
        if params is None:
            return
        method = params["method"]
        if method == "resize":
            w = int(params["width"])
            h = int(params["height"])
            self.resize(w, h)
        elif method == "activate":
            self.activate()

    def resize(self, width, height):
        for w in self.wins():
            w.size = (w.size[0] + width, w.size[1] + height)

    def activate(self):
        for w in self.wins():
            w.activate()

    def wins(self):
        return pywinctl.getWindowsWithTitle("NVIM", condition=pywinctl.Re.CONTAINS)


if __name__ == "__main__":
    param = json.loads(sys.argv[0])
    NvimWinCtrl().execute(param)
