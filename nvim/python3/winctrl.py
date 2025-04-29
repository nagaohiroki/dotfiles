import sys
import json
import typing
import pywinctl


class JsonDict(typing.TypedDict):
    window: str
    width: int
    height: int
    method: str


class NvimWinCtrl:
    def __init__(self, params: JsonDict):
        self.window: str = params["window"]
        self.width: int = params["width"]
        self.height: int = params["height"]
        self.method: str = params["method"]

    def execute(self):
        if self.method == "resize":
            self.resize()
        elif self.method == "move":
            self.move()
        elif self.method == "activate":
            self.activate()

    def resize(self):
        wins = self.windows()
        for w in wins:
            if not w.resize(self.width, self.height):
                print(f"failed to resize {w.title}")

    def move(self):
        wins = self.windows()
        for w in wins:
            if not w.move(self.width, self.height):
                print(f"failed to move {w.title}")

    def activate(self):
        wins = self.windows()
        for w in wins:
            if not w.activate():
                print(f"failed to activate {w.title}")

    def windows(self):
        return pywinctl.getWindowsWithTitle(
            self.window, condition=pywinctl.Re.CONTAINS, flags=pywinctl.Re.IGNORECASE
        )


if __name__ == "__main__":
    jsonstr = sys.argv[0]
    params: JsonDict = typing.cast(JsonDict, json.loads(jsonstr))
    NvimWinCtrl(params).execute()
