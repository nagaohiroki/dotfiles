# coding:utf-8
from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import
from xml.etree.ElementTree import *
import sys
import os
import subprocess
import codecs

is_vim_import = True
try:
    import vim
except ImportError:
    is_vim_import = False

def svn_add_revfile(file_path):
    out = subprocess.check_output('svn log --quiet --xml ' + file_path)
    elem = fromstring(out)
    logentry = elem.findall('logentry')
    mini = sys.maxint
    for l in logentry:
        mini = min(mini, int(l.get('revision')))

    comd = 'svn cat -r ' + str(mini) + ' ' + file_path
    result = subprocess.check_output(comd)
    old_file_path = os.environ['TEMP'] + '/' + 'r' + str(mini) + '_' + file_path
    old_file = codecs.open(old_file_path, 'w' , 'utf-8')
    old_file.write(result.decode('utf-8'))
    old_file.close()
    return old_file_path

if __name__ == '__main__':
    if is_vim_import == True:
        old_file_path = svn_add_revfile(vim.eval("expand('%')"))
        vim.command("VDsplit " + old_file_path)
