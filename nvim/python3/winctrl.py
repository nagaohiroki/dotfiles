import sys
import json
import typing
import pywinctl


class JsonDict(typing.TypedDict):
    pid: int
    width: int
    height: int
    method: str


class NvimWinCtrl:
    def __init__(self, params: JsonDict):
        self.pid: int = params["pid"]
        self.width: int = params["width"]
        self.height: int = params["height"]
        self.method: str = params["method"]

    def execute(self):
        win = self.get_win()
        if not win:
            print(f"pid: {self.pid} not found.")
            return
        result = True
        if self.method == "resize":
            result = win.resize(self.width, self.height)
        elif self.method == "move":
            result = win.move(self.width, self.height)
        elif self.method == "activate":
            result = win.activate()
        if not result:
            print(f"failed to {self.method}, pid: {self.pid}")

    def get_win(self):
        windows = pywinctl.getAllWindows()
        for w in windows:
            if w.getPID() == self.pid:
                return w


if __name__ == "__main__":
    jsonstr = sys.argv[0]
    params: JsonDict = typing.cast(JsonDict, json.loads(jsonstr))
    NvimWinCtrl(params).execute()
