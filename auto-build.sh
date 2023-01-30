#!/bin/bash
#clean directory
#rm -R /home/dexip/virtualiztic-build -R 

#buat directory untuk build di /home/dexip/
#mkdir -p /home/dexip/virtualiztic-build && cd /home/dexip/virtualiztic-build

#clone virtualiztic iso dan app
#git clone http://172.16.0.30:9999/virtualiztic/iso-virtualiztic.git

# cd into directory then checkout
#cd /home/dexip/virtualiztic-build/iso-virtualiztic && git checkout master

# entering virtualiztic directory and pull app-virtualiztic
#cd /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/ && git clone http://172.16.0.30:9999/virtualiztic/app-virtualiztic.git && mv app-virtualiztic virtualiztic && cd virtualiztic && git checkout master

# copy mandatory script from gitlab iso-virtualiztic
# copy MULTIPATH
cp /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/virtualiztic/install/etc/multipath.conf /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/conf/multipath.conf.template -R
# COPY SNMPD
cp /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/virtualiztic/install/etc/snmp/snmpd.conf /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/conf/snmpd.conf.template -R
# COPY NGINX TEMPLATE
cp /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/virtualiztic/install/etc/nginx/sites-available/default /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/conf/nginx.template -R
# COPY CRONTAB
cp /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/virtualiztic/install/crontabs/root /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/conf/crontab -R
# COPY MYSQL-BACKUP
cp /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/virtualiztic/install/database/* /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/mysql-backup/. -R
# COPY EXPLORIZTIC.TEMPLATE
cp /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/virtualiztic/install/etc/nginx/sites-available/exploriztic /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/conf/exploriztic.template -R

# create release notes
cd /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/ && dch -im

# Build Class
echo "Classification of build (alpha,beta,rc,unrelease,release,or just click enter)\n"
echo "Your Answer: "
read build_class

#get old version virtualiztic.deb then remove
rm_old_deb=$(rm /home/dexip/virtualiztic-build/iso-virtualiztic/virtualiztic-multiboot/cd/pool/extras/virtualiztic*)

#get new deb version virtualiztic then copy latest deb to iso dir
get_new_deb=$(ls /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise | grep .deb | sort -V | tail -1)
cp /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/$get_new_deb /home/dexip/virtualiztic-build/iso-virtualiztic/virtualiztic-multiboot/cd/pool/extras/

#write new version number to rc.local 
get_new_deb_pars=$(cat /home/dexip/virtualiztic-build/iso-virtualiztic//p_virtualiztic_enterprise/virtualiztic-enterprise/debian/changelog | grep urgency | grep virtualiztic-enterprise | awk '{print $2}' | tr -d '('  | tr -d ')')

get_old_ver=$(cat /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/conf/rc.local.template | grep VIRTUALIZTIC | awk '{print $5}' | head -1)

sed -i "s/$get_old_ver/$get_new_deb_pars/g" /home/dexip/virtualiztic-build/iso-virtualiztic/p_virtualiztic_enterprise/virtualiztic-enterprise/files/conf/rc.local.template 

#build
dpkg-buildpackage -uc -us

# cd to iso dir then scanpackages
cd /home/dexip/virtualiztic-build/iso-virtualiztic/virtualiztic-multiboot/cd/pool/extras/ && dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

# cd to irmod then write initrd
cd /home/dexip/virtualiztic-build/iso-virtualiztic/virtualiztic-multiboot/irmod-uefi/ && find . | cpio -H newc --create --verbose | gzip -9 > /home/dexip/virtualiztic-build/iso-virtualiztic/virtualiztic-multiboot/cd/install.amd/gtk/initrd-uefi.gz

# get new deb then pars to iso prefix
get_new_deb_pars=$(ls /home/dexip/virtualiztic-build/iso-virtualiztic/virtualiztic-multiboot/cd/pool/extras/ | grep virtualiztic-enterprise | sort -V | tail -1 | sed -En "s/_amd64.deb/$build_class.iso/p")

# build iso image
cd /home/dexip/virtualiztic-build/iso-virtualiztic/virtualiztic-multiboot/cd/ && xorriso -as mkisofs -c isolinux/boot.cat -b isolinux/isolinux.bin -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -o $get_new_deb_pars .

# move iso image to repo dir
mv /home/dexip/virtualiztic-build/iso-virtualiztic/virtualiztic-multiboot/cd/$get_new_deb_pars /mnt/builder/repository-dir/iso/VIRTUALIZTIC
