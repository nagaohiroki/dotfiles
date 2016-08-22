# coding:utf-8
from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals
from __future__ import absolute_import
from xml.etree.ElementTree import *
import sys
import os
import vim
def svn_add_revfile(file_path):
    xml_file = 'tmp'
    os.system('svn log --quiet --xml ' + file_path + ' > ' + xml_file)
    elem = parse(xml_file).getroot()
    logentry = elem.findall('logentry')
    mini = sys.maxint
    for l in logentry:
        mini = min(mini, int(l.get('revision')))
    comd = 'svn cat -r ' + str(mini) + ' ' + file_path + ' > tmp.cpp' 
    os.system(comd)

if __name__ == '__main__':
    svn_add_revfile(vim.eval("expand('%')"))
