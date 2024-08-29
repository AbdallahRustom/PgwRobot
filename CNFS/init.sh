#!/bin/bash
# BSD 2-Clause License
# Copyright (c) 2020, Supreeth Herle
# All rights reserved.
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export IP_ADDR=$(awk 'END{print $1}' /etc/hosts)
export IF_NAME=$(ip r | awk '/default/ { print $5 }')


[ ${#MNC} == 3 ] && EPC_DOMAIN="epc.mnc${MNC}.mcc${MCC}.3gppnetwork.org" || EPC_DOMAIN="epc.mnc0${MNC}.mcc${MCC}.3gppnetwork.org"


IMSI="${MCC}${MNC}1234567895"
S6BIMSI="${MCC}${MNC}1234567896"
PCOIMSI="${MCC}${MNC}1234567898"

if [[ ${#MNC} == 3 ]];
then
    IMSI="${MCC}${MNC}123456789"
    S6BIMSI="${MCC}${MNC}123456788"
    PCOIMSI="${MCC}${MNC}123456790"
fi


ETH0=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d '/' -f 1)

sed -i 's|ETH0|'$ETH0'|g' /pgwrobot/src/python/mydiameterscript.py
sed -i 's|ETH0|'$ETH0'|g' /pgwrobot/src/resources/pgw_resource.robot
sed -i 's|EPC_DOMAIN|'$EPC_DOMAIN'|g' /pgwrobot/src/python/mydiameterscript.py
sed -i 's|PGW_IP|'$PGW_IP'|g' /pgwrobot/src/python/mydiameterscript.py
sed -i 's|PGW_IP|'$PGW_IP'|g' /pgwrobot/src/resources/pgw_resource.robot
sed -i 's|MCC|'$MCC'|g' /pgwrobot/src/python/mydiameterscript.py
sed -i 's|MNC|'$MNC'|g' /pgwrobot/src/python/mydiameterscript.py
sed -i 's|MCC|'$MCC'|g' /pgwrobot/src/resources/pgw_resource.robot
sed -i 's|MNC|'$MNC'|g' /pgwrobot/src/resources/pgw_resource.robot
sed -i 's|IMSI|'$IMSI'|g' /pgwrobot/src/resources/pgw_resource.robot
sed -i 's|S6BIMSi|'$S6BIMSI'|g' /pgwrobot/src/resources/pgw_resource.robot

cd /pgwrobot/src
robot pgw.robot
robot_status=$?
if [ $robot_status -ne 0 ]; then
    echo "Robot test failed"
    exit 1
fi
