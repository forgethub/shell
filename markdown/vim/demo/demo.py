#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Create from 2018/6/23 15:01


import os
import ast
import vimpdb

class ReleaseCode (object):
    def __init__(self):
        c = "safsda"
        print "1"
        
    def _Internal(self):
        d = "ssafdssda"
        print "2"

    def release(self):
        self._Internal()
if __name__ == '__main__':
    a = "sadsaf"
    b = "sadsaf"
    vimpdb.set_trace()
    controller = ReleaseCode()
    print "3"
    vimpdb.set_trace()
    result = controller.release()

