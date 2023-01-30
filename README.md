# EXPLANATION
## auto-prebuild.sh
```
- Script ini digunakan untuk melakukan update isi dari ISO-VIRTUALIZTIC dan APP-VIRTUALIZTIC
- Project yang di clone akan checkout di development
- Directory baru akan dibuat di /home/dexip/virtualiztic-build
- Jika prebuild selesai dilakukan, maka jalankan merge ke master untuk APP-VIRTUALIZTIC & ISO-VIRTUALIZTIC

### How to run:
git clone http://172.16.0.30:9999/virtualiztic/automation.git
cd automation
chmod +x auto-prebuild.sh
./auto-prebuild.sh
```
## auto-build.sh
```
- Script ini digunakan untuk melakukan pembungkusan (build) 
- Asumsinya source code (app-virtualiztic) dan builder (iso-virtualiztic) sudah fix dan siap clone dari master
- Directory baru akan dibuat di /home/dexip/virtualiztic-build
- Hasil dari Image yang dibuild akan didelivery ke web server di 172.16.0.30

### How to run:
git clone http://172.16.0.30:9999/virtualiztic/automation.git
cd automation
chmod +x auto-build.sh
./auto-build.sh
```

## auto-update.sh
```
- Script ini digunakan untuk melakukan sync dari git ke server virtualiztic (sudah berjalan)
- Script dijalankan di directory mana saja 
- Beberapa file akan diperbarui ke virtualiztic yang sudah berjalan :
1. install/datafile/*
2. install/database/db-ve.db
3. virtualiztic.sql
4. install/etc/snmp/snmpd.conf
5. install/crontabs/root
6. active_directory.json alertconfig.xml api-code.txt  api-code-ver.txt cluster.json config.xml history.json host-location.json  ip_localhost.txt db-ve.db /var/www/html/. && \
7. lcs/*

### How to run:
git clone http://172.16.0.30:9999/virtualiztic/automation.git
cd automation
chmod +x auto-update.sh
./auto-update.sh
```

