# -*- coding:utf-8 -*-

from scapy.all import *

import queue
import json


class Wifi:
    iface = 'prism0'
    aps = []
    aps2 = []
    channel_lst = set()
    frequency_lst = {
        "1": 2412,
        "2": 2417,
        "3": 2422,
        "4": 2427,
        "5": 2432,
        "6": 2437,
        "7": 2442,
        "8": 2447,
        "9": 2452,
        "10": 2457,
        "11": 2462,
        "12": 2467,
        "13": 2472,
        "32": 5160,
        "34": 5170,
        "36": 5180,
        "38": 5190,
        "40": 5200,
        "42": 5210,
        "44": 5220,
        "46": 5230,
        "48": 5240,
        "50": 5250,
        "52": 5260,
        "54": 5270,
        "56": 5280,
        "58": 5290,
        "60": 5300,
        "62": 5310,
        "64": 5320,
        "68": 5340,
        "96": 5480,
        "100": 5500,
        "102": 5510,
        "104": 5520,
        "106": 5530,
        "108": 5540,
        "110": 5550,
        "112": 5560,
        "114": 5570,
        "116": 5580,
        "118": 5590,
        "120": 5600,
        "122": 5610,
        "124": 5620,
        "126": 5630,
        "128": 5640,
        "132": 5660,
        "134": 5670,
        "136": 5680,
        "138": 5690,
        "140": 5700,
        "142": 5710,
        "144": 5720,
        "149": 5745,
        "151": 5755,
        "153": 5765,
        "155": 5775,
        "157": 5785,
        "159": 5795,
        "161": 5805,
        "165": 5825,
        "169": 5845,
        "173": 5865,
        "183": 4915,
        "184": 4920,
        "185": 4925,
        "187": 4935,
        "188": 4940,
        "189": 4945,
        "192": 4960,
        "196": 4980,
        "0": 0
    }
    def __init__(self, iface='prism0'):
        self.iface = iface
        
    def start(self):
        sniff(iface = self.iface, prn = self.worker)
    
    def get_rssi(self, pkt):
        # 在混杂模式下获取信号强度。
        # 参考 https://stackoverflow.com/questions/10818661/scapy-retrieving-rssi-from-wifi-packets
        rssi = -100
        if pkt.haslayer(Dot11Beacon) or pkt.haslayer(Dot11ProbeResp):
            try:
                if pkt.type == 0 and (pkt.subtype == 5 or pkt.subtype == 8):
                    extra = pkt.notdecoded
                    rssi = -(256-ord(extra[-4:-3]))
            except:
                pass
            #print("WiFi signal strength:", rssi, "dBm of", pkt.addr2, pkt.info)
        return rssi
    
    def get_channel(self, pkt):
        # 获取信道频率
        # 参考 https://tutorials.technology/tutorials/49-Process-wifi-packets-with-scapy.html
        channel = 0
        if ((pkt.haslayer(Dot11Beacon))):
            try:
                if pkt.type == 0 and (pkt.subtype == 5 or pkt.subtype == 8):
                    channel = int(ord(pkt[Dot11Elt:3].info))
            except:
                pass
        return channel
    
    def get_frequency(self, channel):
        frequency = int(self.frequency_lst[str(channel)]/1000)
        if frequency == 2:
            frequency = 2.4
        return "{}GHz".format(frequency)
        
    def get_aps(self, pkt):
        #
        # 加密类型识别参考： https://stackoverflow.com/questions/21613091/how-to-use-scapy-to-determine-wireless-encryption-type/21664038#21664038
        # 参考scapy源码： https://github.com/secdev/scapy/blob/c3b6d41fea1d916ab1cb8e40f20bd135c116bf92/scapy/layers/dot11.py#L442
        # 识别加密算法参考： https://gist.github.com/tintinweb/04c14d1497001e55e6c10ca28f198fbe
        #                   https://gist.github.com/garyconstable/16b12823411c2d6515fb
        
        '''
            '\x01\x00'                 #RSN Version 1
            '\x00\x0f\xac\x02'         #Group Cipher Suite : 00-0f-ac TKIP
            '\x02\x00'                 #2 Pairwise Cipher Suites (next two lines)
            '\x00\x0f\xac\x04'         #AES Cipher
            '\x00\x0f\xac\x02'         #TKIP Cipher
            '\x01\x00'                 #1 Authentication Key Managment Suite (line below)
            '\x00\x0f\xac\x02'         #Pre-Shared Key
            '\x00\x00')) #RSN Capabilities (no extra capabilities)
        '''
        bssid = pkt[Dot11].addr3
        mac = pkt[Dot11].addr2
        p = pkt[Dot11Elt]
        cap = pkt.sprintf("{Dot11Beacon:%Dot11Beacon.cap%}"
                          "{Dot11ProbeResp:%Dot11ProbeResp.cap%}").split('+')
        ssid, channel, channel_frequency = None, None, None
        crypto = set()
        is_hidden = 0
        while isinstance(p, Dot11Elt):
            if p.ID == 0:
                ssid = p.info
                try:
                    if binascii.hexlify(p.info)[:2] == '00':
                        is_hidden = 1
                        ssid = ""
                    if not p.info.strip():
                        is_hidden = 1
                except:
                    print("hexlify error")
                    pass
            elif p.ID == 3:
                channel = ord(p.info)
                # 信道频率参考 https://en.wikipedia.org/wiki/List_of_WLAN_channels
                channel_frequency = self.get_frequency(channel)
            elif p.ID == 48:
                
                # 将info中的十六进制转换为字符串，使用 5*2-5*2+2 取02 AES Cipher或04 TKIP Cipher表示十六进制的字符，
                # WPA-PSK / WPA2-PSK使用-6:-4取PKS值02表示十六进制的字符
                # 例如:
                #   binascii.hexlify(p.info)[5*2:5*2+2]
                #   binascii.hexlify(p.info)[-6:-4]
                if binascii.hexlify(p.info)[5*2:5*2+2] == '02':
                    #print("====================5============= TKIP")
                    pass
                
                if binascii.hexlify(p.info)[5*2:5*2+2] == '04':
                    #print("====================5============= AES")
                    pass

                if binascii.hexlify(p.info)[-6:-4] == '02':
                    #print("====================11============= PSK")
                    crypto.add("WPA2-PSK")
                else:
                    crypto.add("WPA2")

            elif p.ID == 221 and p.info.startswith('\x00P\xf2\x01\x01\x00'):
                crypto.add("WPA")
            p = p.payload
        if not crypto:
            if 'privacy' in cap:
                crypto.add("WEP")
            else:
                crypto.add("OPN")
        
        ap = {
            "ssid": ssid,
            "mac": mac,
            "is_hidden": is_hidden,
            "bssid": bssid,
            "channel": channel,
            "channel_frequency": channel_frequency,
            "rssi": self.get_rssi(pkt),
            "crypto": list(crypto)
        }
        print("ssid: {ssid},mac: {mac},is_hidden: {is_hidden}, bssid: {bssid}, channel: {channel}, channel_frequency: {channel_frequency}, rssi: {rssi}, crypto: {crypto}".format(  
                    ssid=ssid,
                    mac=mac, 
                    is_hidden=is_hidden,
                    bssid=bssid,
                    channel=channel,
                    channel_frequency=channel_frequency,
                    rssi=self.get_rssi(pkt),
                    crypto=list(crypto)
                )
            )
        #print(json.dumps(ap))
        #print("NEW AP: %r [%s], channed %d, %s" % (str(ssid).decode('utf-8'), bssid, channel,' / '.join(crypto)))
        self.aps2.append(ap)
        
        return self.aps2
        
    def worker(self, pkt):
        # info = pkt.sprintf("{Dot11Beacon:%Dot11.addr3% %Dot11Beacon.info% %PrismHeader.channel% %Dot11Beacon.cap%}")
        # print(info)
        try:
            if pkt.haslayer(Dot11):
                if pkt.type == 0 and (pkt.subtype == 5 or pkt.subtype == 8):
                    if pkt.addr2 not in self.aps:
                        self.aps.append(pkt.addr2)
                        self.get_aps(pkt)
                        
                        '''
                        rssi = self.get_rssi(pkt)
                        channel = self.get_channel(pkt)
                        print("test channel: %s"%channel)
                        channel = int(ord(pkt[Dot11Elt:3].info))
                        print("WIFI SSID: %s WIFI Name: %s RSSI: %s Channel: %s"%(pkt.addr2, pkt.info, rssi, channel))
                        
                        #sig_str = -(256-ord(pkt.notdecoded[-4:-3]))
                        #print("signal strength: %s" % sig_str)
                        
                        self.ssid = pkt.addr2
                        '''
                        
        except Exception as e:
            print(e)

if __name__ == '__main__':
    
    iface = 'prism0'
    try:
        opts, args = getopt.getopt(sys.argv[1:],'i:',['interface=','help'])
    except getopt.GetoptError as e:
        sys.exit('use -i or --interface')
    
    for o, opt in opts:
        if o in ("-i", "--interface"):
            iface = opt
    
    Wifi(iface=iface).start()
