#!python    
#/usr/bin/env python
# -*- coding:utf-8 -*-


__doc__ = """

    NBNS Query ,
                    by Her0in

"""

import socket, struct

class NBNS_Query:
    def __init__(self,name):
        self.name = name
        self.populate()
    def populate(self):
        self.HOST = '192.168.6.123'
        self.PORT = 137
        self.nqs = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.nqs.bind(("0.0.0.0", self.PORT))
        self.QueryData = (
        b"\xa9\xfb"  # Transaction ID
        b"\x00\x00"  # Flags Query
        b"\x00\x01"  # Question:1
        b"\x00\x00"  # Answer RRS
        b"\x00\x00"  # Authority RRS
        b"\x00\x00"  # Additional RRS
        b"\x20"      # length of Name:32
        b"NAME"      # Name   
        b"\x00"      # NameNull
        b"\x00\x21"  # Query Type:NB
        b"\x00\x01") # Class

        self.data = self.QueryData.replace(b'NAME', struct.pack("32s".encode('utf-8'), self.encode_name(self.name)))

    # From http://code.google.com/p/dpkt/
    def encode_name(self, name):
        """Return the NetBIOS first-level encoded name."""
        l = []
        for c in struct.pack("16s", bytes(str(name).encode('utf-8'))):
            l.append(chr((c >> 4) + 0x41))
            l.append(chr((c & 0xf) + 0x41))
        print(l)
        return bytes(str(''.join(l)).encode('utf-8'))

    def Query(self):
        
        print("NBNS Querying... -> %s" % self.name)
        self.nqs.sendto(self.data, (self.HOST, self.PORT))
        while 1:
            try:
                data, addr = self.nqs.recvfrom(1024)
                print(data, addr)
            except Exception as e:
                print(e)
        self.nqs.close()

if __name__ == "__main__":
    nbns = NBNS_Query("*")
    nbns.Query()
