#!/usr/bin/env python

import binascii


with open("b.txt", 'rb') as f:
        s=f.read()
        print binascii.unhexlify(''.join(s.split()))
