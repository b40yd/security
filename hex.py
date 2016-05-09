#!/usr/bin/env python

import binascii
import sys

with open(sys.argv[1], 'rb') as f:
        s=f.read()
        print binascii.unhexlify(''.join(s.split()))
