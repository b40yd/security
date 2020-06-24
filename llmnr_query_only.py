#/usr/bin/env python

__doc__ = """
    LLMNR Query ,
                    by Her0in
"""

import socket, struct

class LLMNR_Query:
    def __init__(self,name):
        self.name = name

        self.IsIPv4 = True
        self.populate()
    def populate(self):
        self.HOST = '224.0.0.252' if self.IsIPv4 else 'FF02::1:3'
        self.PORT = 5355
        self.s_family = socket.AF_INET if self.IsIPv4 else socket.AF_INET6

        self.QueryType = "IPv4"
        self.lqs = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP) #socket.socket(self.s_family, socket.SOCK_DGRAM)

        self.QueryData = (
        b"\xa9\xfb"  # Transaction ID
        b"\x00\x00"  # Flags Query(0x0000)? or Response(0x8000) ?
        b"\x00\x01"  # Question
        b"\x00\x00"  # Answer RRS
        b"\x00\x00"  # Authority RRS
        b"\x00\x00"  # Additional RRS
        b"LENGTH"    # length of Name
        b"NAME"      # Name
        b"\x00"      # NameNull
        b"TYPE"      # Query Type ,IPv4(0x0001)? or IPv6(0x001c)?
        b"\x00\x01") # Class
        namelen = len(self.name)
        self.data = self.QueryData.replace(b'LENGTH', struct.pack('>B', namelen))
        self.data = self.data.replace(b'NAME', struct.pack(">{}s".format(namelen).encode('utf-8'), bytes(self.name)))
        self.data = self.data.replace(b"TYPE",  b"\x00\x0C" if self.QueryType == "IPv4" else b"\x00\x1c")

    def Query(self):
        self.lqs.sendto(self.data, (self.HOST, self.PORT))

        print("LLMNR Querying... -> %s" % self.name)
        print(self.data)
       
        self.lqs.close()

if __name__ == "__main__":
    llmnr = LLMNR_Query(b"118.6.168.192.in-addr.arpa")
    llmnr.Query()
