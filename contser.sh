#!/bin/bash
# connect to remote server using name instead of ip


ali="123.57.128.111"
vultr="139.180.140.72"
sensetime="jump01.bj.sensetime.com"


ssh ${1}@${!2}
