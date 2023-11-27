import subprocess
import glob


def main():
    tss = glob.glob('*.ts')
    # ffmpeg -i "concat:index0.ts|index1.ts|index2.ts|index3.ts|index4.ts|index5.ts|index6.ts" -c copy output.mp4
    for ts in tss:
        mp4 = ts.replace('.ts', '.mp4')
        cmd = ['ffmpeg', '-i', ts, '-c', 'copy', mp4]
        # str_cmd = ' '.join(cmd)
        subprocess.call(cmd, shell=True)
        print(cmd)

if __name__ == "__main__":
    main()
