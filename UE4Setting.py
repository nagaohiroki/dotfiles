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
            define_tag = 'NMakePreprocessorDefinitions'
            define_values = UE4Setting.elem_to_values(root, ns + define_tag)
            for define in define_values:
                if define not in flags:
                    flags += ['-D', define]
            include_tag = 'NMakeIncludeSearchPath'
            include_values = UE4Setting.elem_to_values(root, ns + include_tag)
            dirname = os.path.dirname(vcx)
            for i in include_values:
                path = os.path.join(dirname, i)
                if os.path.exists(path):
                    if path not in flags:
                        flags += ['-I', path]
        return flags


def main():
    flags = UE4Setting.ue4_flags()
    if flags:
        print('\n'.join(flags))


if __name__ == '__main__':
    main()
