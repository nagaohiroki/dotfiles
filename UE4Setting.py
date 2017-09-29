from __future__ import absolute_import
from __future__ import generators
from __future__ import division
from __future__ import unicode_literals
from __future__ import with_statement
from __future__ import print_function
from __future__ import nested_scopes
import xml.etree.ElementTree as ET
import glob
import os

ue4_dirs = [
        '',
        '',
        ]


class UE4Setting:
    @staticmethod
    def ue4_flags():
        result = []
        for d in ue4_dirs:
            intermdiate = os.path.join(d, 'Intermediate')
            result += UE4Setting.ue4_flags_dir_def(intermdiate)
            # result += UE4Setting.ue4_flags_include(intermdiate)
        return result

    @staticmethod
    def ue4_flags_dir_def(ue4_dir):
        proj_path = os.path.join(ue4_dir, 'ProjectFiles')
        if not os.path.exists(proj_path):
            return []
        cur = os.getcwd()
        os.chdir(proj_path)
        ns = './/{http://schemas.microsoft.com/developer/msbuild/2003}'
        flags = []
        for vcx in glob.glob('*.vcxproj'):
            tree = ET.parse(vcx)
            root = tree.getroot()
            include_tag = 'NMakeIncludeSearchPath'
            include_values = UE4Setting.elem_to_values(root, ns + include_tag)
            for i in include_values:
                path = os.path.abspath(i)
                if os.path.exists(path):
                    if path not in flags:
                        flags += ['-I', path]

            define_tag = 'NMakePreprocessorDefinitions'
            define_values = UE4Setting.elem_to_values(root, ns + define_tag)
            for define in define_values:
                if define not in flags:
                    flags += ['-D', define]
        os.chdir(cur)
        return flags

    @staticmethod
    def elem_to_values(root, tag):
        define_elems = root.find(tag)
        return define_elems.text.split(';')

    @staticmethod
    def ue4_flags_include(ue4_dir):
        proj_path = os.path.join(ue4_dir, 'Build')
        flags = []
        for root, _, files in os.walk(proj_path):
            for f in files:
                if not f.endswith('.h'):
                    continue
                full = os.path.abspath(os.path.join(root, f))
                if not os.path.exists(full):
                    continue
                if full not in flags:
                    flags += ['-macros', full]
        return flags


def main():
    print('\n'.join(UE4Setting.ue4_flags()))


if __name__ == '__main__':
    main()
