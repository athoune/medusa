#!/bin/bash

VERSION=11.6.0

if [ ! -e debian-${VERSION}-amd64-netinst.iso.wal ]
then
	rm -f debian-${VERSION}-amd64-netinst.iso
fi
if [ ! -e SHA256SUMS ]
then
	curl -O https://cdimage.debian.org/debian-cd/${VERSION}/amd64/iso-cd/SHA256SUMS
fi

./bin/medusa-get \
    https://cdimage.debian.org/debian-cd/${VERSION}/amd64/iso-cd/debian-${VERSION}-amd64-netinst.iso \
    http://debian.koyanet.lv/debian-cd \
    http://debian.anexia.at/debian-cd \
    http://ftp.crifo.org/debian-cd \
    http://debian.obspm.fr/debian-cd \
    https://ftp.cica.es/debian-cd \
    http://ftp.ps.pl/pub/Linux/debian-cd \
    http://debian.mirror.root.lu/debian-cd \
    http://ftp.lanet.kr/debian-cd \
    http://mirror.checkdomain.de/debian-cd \
    http://mirror.as35701.net/debian-cd \
    http://mirror.asergo.com/debian-cd \
    http://giano.com.dist.unige.it/debian-cd \

shasum -a 256 debian-${VERSION}-amd64-netinst.iso
grep debian-${VERSION} SHA256SUMS
