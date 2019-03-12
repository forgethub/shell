#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Create from 2018/6/23 15:01

"""
Minion side functions for svn-update
Usage:
  archive.py (options)

Options:
  --app=(var),       App Name
  --idc=[var],       Internet Data Center
  --type=(var),      更新类型[getfile/unpack/symlink/stop/start]
  --group=(var),     分组更新[1/2]
  --action=[var],    Dubbo admin应用的启用与禁用[enable|disable]
  --level=[number],  更新级别[1/2/3]，L2站点聚合，L3原子[default: 1]
  --site=[var],      指定聚合网站
  -h --help          Show this screen.
"""

import os
import ast
import logging
import collections
from ConfigParser import ConfigParser
BASE_PATH = '/'.join(os.path.dirname(os.path.abspath(__file__)).split('/')[:-1])
PARSER = ConfigParser()


class ReleaseCode (object):
    """
    """
    def __init__(self):
        print "初始化"
        
    def _Internal(self):
        print "执行内部逻辑"

    def release(self):
        self._Internal()
        print "执行逻辑"
if __name__ == '__main__':
    controller = ReleaseCode()
    result = controller.release()

