#!/bin/bash
#clean directory
rm -R /home/dexip/virtualiztic-build 

#buat directory untuk build di /home/dexip/
mkdir -p /home/dexip/virtualiztic-build && cd /home/dexip/virtualiztic-build

#clone virtualiztic iso dan app
git clone http://172.16.0.30:9999/virtualiztic/iso-virtualiztic.git

# cd into directory then checkout
cd /home/dexip/virtualiztic-build/iso-virtualiztic && git checkout master

# pull app-virtualiztic
cd /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/ && rm virtualiztic -R && git clone http://172.16.0.30:9999/virtualiztic/app-virtualiztic.git && mv app-virtualiztic virtualiztic && cd virtualiztic && git checkout master
