from __future__ import absolute_import
from __future__ import generators
from __future__ import division
from __future__ import unicode_literals
from __future__ import with_statement
from __future__ import print_function
from __future__ import nested_scopes
import xml.etree.ElementTree as ET
import os
import codecs
import json
import glob


class UE4Setting:
    @staticmethod
    def ue4_flags():
        json_path = os.path.join(os.path.dirname(__file__), 'ue4path.json')
        projects = UE4Setting.load_dirs(json_path)
        return UE4Setting.ue4_flags_dir_def(projects)

    @staticmethod
    def elem_to_values(root, tag):
        define_elems = root.find(tag)
        return define_elems.text.split(';')

    @staticmethod
    def load_dirs(json_path):
        if not os.path.exists(json_path):
            return
        with codecs.open(json_path, 'r', 'utf-8_sig') as json_file:
            return json.load(json_file)

    @staticmethod
    def ue4_flags_dir_def(projects):
        if not projects:
            return
        flags = []
        for vcx in projects:
            if not os.path.exists(vcx):
                continue
            ns = './/{http://schemas.microsoft.com/developer/msbuild/2003}'
            tree = ET.parse(vcx)
            root = tree.getroot()
            # define
            define_tag = 'NMakePreprocessorDefinitions'
            define_values = UE4Setting.elem_to_values(root, ns + define_tag)
            for define in define_values:
                if define == '$({0})'.format(define_tag):
                    continue
                if define in flags:
                    continue
                if '/' in define:
                    continue
                flags += ['-D', define]
            # include
            include_tag = 'NMakeIncludeSearchPath'
            include_values = UE4Setting.elem_to_values(root, ns + include_tag)
            dirname = os.path.dirname(vcx)
            for i in include_values:
                path = os.path.abspath(os.path.join(dirname, i))
                path = path.replace('\\', '/')
                if os.path.exists(path):
                    if path not in flags:
                        flags += ['-I', path]
        return flags

    @staticmethod
    def find_uproject(filename):
        filepath = os.path.abspath(filename)
        while True:
            head, tail = os.path.split(filepath)
            if not head:
                return
            uprojects = glob.glob(head, '*.uproject')
            if uprojects:
                return uprojects[0]


def main():
    flags = UE4Setting.ue4_flags()
    if flags:
        print('\n'.join(flags))


if __name__ == '__main__':
    main()
