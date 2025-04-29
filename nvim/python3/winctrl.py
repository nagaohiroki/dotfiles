import sys
import json
import pywinctl
import typing


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
        getattr(self, self.method)()

    def resize(self):
        wins = self.windows()
        for w in wins:
            _ = w.resize(self.width, self.height)

    def move(self):
        wins = self.windows()
        for w in wins:
            _ = w.move(self.width, self.height)

    def activate(self):
        wins = self.windows()
        for w in wins:
            _ = w.activate()

    def windows(self):
        return pywinctl.getWindowsWithTitle(
            self.window, condition=pywinctl.Re.CONTAINS, flags=pywinctl.Re.IGNORECASE
        )


if __name__ == "__main__":
    jsonstr = sys.argv[0]
    params: JsonDict = typing.cast(JsonDict, json.loads(jsonstr))
    NvimWinCtrl(params).execute()
