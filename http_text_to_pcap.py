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
from scapy.all import IP, TCP, wrpcap, Raw, RandShort, sr, sr1, send, Ether
import socket


def get_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't even have to be reachable
        s.connect(("10.255.255.255", 1))
        IP = s.getsockname()[0]
    except:
        IP = "127.0.0.1"
    finally:
        s.close()
    return IP


def gen_pkt(dst, dst_port):
    http_request_text = None
    http_response_text = None
    # Read the HTTP response from a file
    with open("http-req.txt", "r") as f:
        http_request_text = f.read()

    # Read the HTTP response from a file
    with open("http-resp.txt", "r") as f:
        http_response_text = f.read()

    random_port = 43454

    # 构造 TCP SYN 数据包
    # syn_packet = IP(dst=dst) / TCP(sport=random_port, dport=dst_port, flags="S")

    # 发送 TCP SYN 数据包，获取 TCP SYN-ACK 数据包
    # syn_ack_packet = sr1(syn_packet)

    # 构造TCP ACK数据包
    # ack_packet = (
    #     Ether(src="88:16:5a:40:3c:e8", dst="f8:15:98:f4:ff:ce")
    #     / IP(dst=dst)
    #     / TCP(
    #         dport=dst_port,
    #         sport=random_port,
    #         flags="A",
    #         # seq=syn_ack_packet[TCP].ack,
    #         # ack=syn_ack_packet[TCP].seq + 1,
    #     )
    # )

    # 发送TCP ACK数据包
    # send(ack_packet)

    # 构造 TCP SYN-ACK 数据包
    # syn_ack_packet = IP(dst=dst) / TCP(
    #     sport=random_port, dport=dst_port, flags="SA", seq=100, ack=50
    # )

    # 构造 HTTP GET 请求数据包
    http_request = (
        Ether(src="88:16:5a:50:3c:e8", dst="f8:15:98:f4:ff:ce")
        / IP(dst=dst)
        / TCP(
            dport=dst_port,
            sport=random_port,
            # sport=syn_ack_packet[TCP].dport,
            # seq=syn_ack_packet[TCP].ack,
            # ack=syn_ack_packet[TCP].seq + 1,
            flags="A",
        )
        / Raw(bytes(http_request_text.replace("\n", "\r\n"), "utf-8") + b"\r\n")
    )

    http_request.show()

    # send(http_request)

    http_response = (
        Ether(dst="88:16:5a:40:3c:e8", src="f8:15:98:f4:ff:ce")
        / IP(
            src=dst,
            dst=get_ip(),
        )
        / TCP(
            dport=random_port,
            sport=dst_port,
            seq=http_request[TCP].ack,
            ack=http_request[TCP].seq + len(http_request[Raw]),
            flags="PA",
        )
        / http_response_text,
    )

    # send(http_response)

    # 构造TCP FIN数据包
    # fin_packet = (
    #     Ether(src="88:16:5a:40:3c:e8", dst="f8:15:98:f4:ff:ce")
    #     / IP(dst=dst)
    #     / TCP(
    #         dport=dst_port,
    #         sport=random_port,
    #         seq=http_request[TCP].ack,
    #         ack=http_request[TCP].seq + len(http_request[TCP].payload),
    #         flags="FA",
    #     )
    #     / Raw(b"FIN")
    # )

    # 发送TCP FIN数据包，获取TCP ACK数据包
    # fin_ack_packet = sr1(fin_packet)

    # 构造TCP ACK数据包
    # ack_packet_2 = (
    #     Ether(src="88:16:5a:40:3c:e8", dst="f8:15:98:f4:ff:ce")
    #     / IP(dst=dst)
    #     / TCP(
    #         dport=dst_port,
    #         sport=random_port,
    #         seq=fin_packet[TCP].ack,
    #         ack=fin_packet[TCP].seq + 1,
    #         flags="A",
    #     )
    # )

    # 发送TCP ACK数据包
    # send(ack_packet_2)
    return (
        # syn_packet,
        # syn_ack_packet,
        # ack_packet,
        http_request,
        http_response,
        # fin_packet,
        # ack_packet_2,
    )


if __name__ == "__main__":

    (
        # syn_packet,
        # syn_ack_packet,
        # ack_packet,
        http_request,
        http_response,
        # fin_packet,
        # ack_packet_2,
    ) = gen_pkt("www.a.com", 4081)

    # Write the request and response packets to a PCAP file
    wrpcap(
        "http.pcap",
        [
            # syn_packet,
            # syn_ack_packet,
            # ack_packet,
            http_request,
            http_response,
            # fin_packet,
            # ack_packet_2,
        ],
    )
