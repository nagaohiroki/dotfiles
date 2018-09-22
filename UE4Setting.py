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
    def find_ptn(filepath, ptn):
        head, tail = os.path.split(os.path.abspath(filepath))
        if not tail:
            return
        targets = glob.glob(os.path.join(head, ptn))
        if targets:
            return targets[0]
        return UE4Setting.find_ptn(head, ptn)

    @staticmethod
    def find_vcxproj(filepath):
        proj = 'Engine/Intermediate/ProjectFiles'
        ue4 = UE4Setting.find_ptn(filepath, os.path.join(proj, 'UE4.vcxproj'))
        proj = UE4Setting.find_ptn(filepath, '*.uproject')
        if not proj:
            return [ue4]
        proj = os.path.splitext(os.path.basename(proj))[0] + '.vcxproj'
        uproj = UE4Setting.find_ptn(filepath, os.path.join(proj, proj))
        return [ue4, uproj]


def main():
    flags = UE4Setting.ue4_flags()
    if flags:
        print('\n'.join(flags))


if __name__ == '__main__':
    main()
