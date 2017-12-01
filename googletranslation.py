from __future__ import absolute_import
from __future__ import generators
from __future__ import division
from __future__ import unicode_literals
from __future__ import with_statement
from __future__ import print_function
from __future__ import nested_scopes
import webbrowser
import urllib
from Tkinter import Tk


def GoogleTranslation(before, after, word):
    url = '''
    https://translate.google.co.jp/?um=1&ie=UTF-8&hl=ja&client=tw-ob#{0}/{1}/{2}
    '''.format(before, after, urllib.quote(word.encode('utf-8')))
    webbrowser.open(url)


def main():
    r = Tk()
    r.withdraw()
    clip = r.clipboard_get()
    r.destroy()
    GoogleTranslation('en', 'ja', clip)


if __name__ == '__main__':
    main()
