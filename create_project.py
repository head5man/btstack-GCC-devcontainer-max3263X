#!/usr/bin/python3
import os
import sys

script_path = os.path.abspath(os.path.dirname(sys.argv[0]))
project_path = os.path.join(script_path, sys.argv[1])
btstack_root = os.path.join(script_path, 'btstack')

sys.path.append(os.path.join(btstack_root, "port/max32630-fthr/scripts"))
from create_project_makefile import createProjectMakefile
print(f"Creating project in {project_path}")
createProjectMakefile(project_path, btstack_root)