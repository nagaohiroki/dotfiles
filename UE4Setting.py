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


class UE4Setting:
    @staticmethod
    def ue4_flags(ue4_path):
        proj_path = os.path.join(ue4_path, 'Intermediate/ProjectFiles')
        if not os.path.exists(proj_path):
            return []
        cur = os.getcwd()
        os.chdir(proj_path)
        ns = './/{http://schemas.microsoft.com/developer/msbuild/2003}'
        includes = []
        defines = []
        for vcx in glob.glob('*.vcxproj'):
            tree = ET.parse(vcx)
            root = tree.getroot()
            includes_elems = root.find(ns + 'NMakeIncludeSearchPath')
            for i in includes_elems.text.split(';'):
                path = os.path.abspath(i)
                if os.path.exists(path):
                    if path not in includes:
                        includes.append(path)

            define_elems = root.find(ns + 'NMakePreprocessorDefinitions')
            for define in define_elems.text.split(';'):
                if define not in defines:
                    defines.append(define)
        result = []
        for i in includes:
            result += ['-I', i]
        for d in defines:
            result += ['-D', d]
        os.chdir(cur)
        return result


def main():
    print('\n'.join(UE4Setting.ue4_includes('D:/work/UnrealEngine/Engine')))


if __name__ == '__main__':
    main()
