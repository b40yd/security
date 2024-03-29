#
# Copyright (C) 2023, b40yd
#
# Author: b40yd <bb.qnyd@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
import random
import re
import socket
import uuid

from scapy.all import IP, TCP, wrpcap, Raw, Ether

from sys import version_info

if version_info.major == 2:
    from BaseHTTPServer import BaseHTTPRequestHandler
    from StringIO import StringIO
else:
    from http.server import BaseHTTPRequestHandler
    from io import StringIO


class HTTPRequest(BaseHTTPRequestHandler):

    def __init__(self, request_text):
        self.rfile = StringIO(request_text)
        self.raw_requestline = self.rfile.readline()
        self.error_code = self.error_message = None
        self.parse_request()

    def send_error(self, code, message):
        self.error_code = code
        self.error_message = message

DOMAIN_REGEX = re.compile(
    r"^(?:https?:\/\/)?(?:[^@\n]+@)?(?:www\.)?([a-zA-Z0-9\-]+\.[a-zA-Z]{2,})(?:[\/\w\.-]*)*\/?$"
)


def get_ip():
    """get local ip"""
    ssc = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't even have to be reachable
        ssc.connect(("10.255.255.255", 1))
        local_ip = ssc.getsockname()[0]
    except:
        local_ip = "127.0.0.1"
    finally:
        ssc.close()
    return local_ip


def gen_pkt(
    dst,
    dst_port,
    random_port=43454,
    http_request_text="",
    http_response_text="",
    src_mac="18:26:3a:30:3c:e8",
    dst_mac="02:42:AC:11:00:03",
):
    """gen pcap packet"""
    http_request_bytes = bytes(http_request_text)
    if not http_request_bytes.endswith("\n"):
        http_request_bytes = http_request_bytes + b"\n"

    http_response_bytes = bytes(http_response_text)
    if not http_response_bytes.endswith("\n"):
        http_response_bytes = http_response_bytes + b"\n"

    http_request = (Ether(src=src_mac, dst=dst_mac) / IP(dst=dst) / TCP(
        dport=dst_port,
        sport=random_port,
        flags="A",
    ) / Raw(http_request_bytes))

    # http_request.show()

    (http_response, ) = (Ether(dst=src_mac, src=dst_mac) / IP(
        src=dst,
        dst=get_ip(),
    ) / TCP(
        dport=random_port,
        sport=dst_port,
        seq=http_request[TCP].ack,
        ack=http_request[TCP].seq + len(http_request[Raw]),
        flags="PA",
    ) / Raw(http_response_bytes))
    # http_response.show()
    return http_request, http_response


def get_mac_address():
    """get interface mac address"""
    mac_address = uuid.getnode()
    return ":".join([
        "{:02x}".format((mac_address >> ele) & 0xFF)
        for ele in range(0, 8 * 6, 8)
    ][::-1])


def get_host_and_port(request=""):
    """get host and port"""

    host = ""
    port = 80
    req = HTTPRequest(request)
    host_str = req.headers.get("host", "")

    if ":" in host_str:
        tmp = host_str.replace("http://", "").replace("https://","").split(":")
        if len(tmp) >= 2:
            host = tmp[0]
            port = int(tmp[1])
    else:
        host = host_str

    if re.search(DOMAIN_REGEX, host):
        host = get_ip()

    return host, port


def gen_all_packet(multi_http_packet):
    """gen all http text to http packet"""
    result = []
    for req, resp in multi_http_packet:
        host, port = get_host_and_port(req)

        http_pkt = gen_pkt(
            host,
            port,
            random.randint(23456, 65500),
            req,
            resp,
            src_mac=get_mac_address(),
        )
        result.append(http_pkt)

    return result


def test_from_files():
    """test http request and response from file"""
    with open("http-req.txt", "r") as f:
        http_request_text = f.read()

    # Read the HTTP response from a file
    with open("http-resp.txt", "r") as f:
        http_response_text = f.read()

    pkts = gen_all_packet([(http_request_text, http_response_text)])
    # Write the request and response packets to a PCAP file
    wrpcap(
        "http.pcap",
        pkts,
    )
