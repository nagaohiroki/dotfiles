import os
import json


def get_dir_size(root_path):
    size = 0
    for root, _, files in os.walk(root_path):
        for file in files:
            full_path = os.path.join(root, file)
            if os.path.exists(full_path):
                size += os.path.getsize(full_path)
    return size


def convert_mb(size):
    return round(size / 1024**2, 2)


def score_dict(root_path):
    score = {}
    for d in os.listdir(root_path):
        path = os.path.join(root_path, d)
        if not os.path.isdir(path):
            continue
        size = get_dir_size(path)
        if size > 0:
            score[path] = convert_mb(size)
        print(path)
    return score


if __name__ == "__main__":
    root_path = "."
    score = score_dict(root_path)
    sorted_dict = dict(sorted(score.items(), key=lambda x: x[1], reverse=True))
    print(json.dumps(sorted_dict, indent=2))
