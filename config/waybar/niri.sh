#!/usr/bin/env python3

import json
import os
import subprocess

output = os.environ.get('WAYBAR_OUTPUT_NAME', 'whoops')

workspaces = json.loads(subprocess.run(['niri', 'msg', '-j', 'workspaces'], stdout=subprocess.PIPE).stdout)
workspace = list(filter(lambda x: x['output'] == output and x['is_active'] == True, workspaces))
workspace_id = workspace.pop()['id']

windows = json.loads(subprocess.run(['niri', 'msg', '-j', 'windows'], stdout=subprocess.PIPE).stdout)
count = len(list(filter(lambda x: x['workspace_id'] == workspace_id, windows)))
if count > 0:
    print(count)
