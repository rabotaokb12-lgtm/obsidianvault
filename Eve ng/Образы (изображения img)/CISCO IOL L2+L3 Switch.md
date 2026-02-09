1. Скачиваем образ а какой именно смотрим тут:
    https://www.eve-ng.net/index.php/documentation/howtos/howto-add-cisco-iol-ios-on-linux/
2. Закидываем образ по пути **/opt/unetlab/addons/iol/bin/** через **WINSCP**
3. Прописываем в консоли EVE /opt/unetlab/wrappers/unl_wrapper -a fixpermissions 
4. Прописываем эти команды:
   apt-get update
   apt-get install vim nano
   cd /opt/unetlab/addons/iol/bin/
5. vim ioukeygen.py
        #! /usr/bin/python
		print "\n*********************************************************************"
		print "Cisco IOU License Generator - Kal 2011, python port of 2006 C version"
		import os
		import socket
		import hashlib
		import struct
		# get the host id and host name to calculate the hostkey
		hostid=os.popen("hostid").read().strip()
		hostname = socket.gethostname()
		ioukey=int(hostid,16)
		for x in hostname:
		 ioukey = ioukey + ord(x)
		print "hostid=" + hostid +", hostname="+ hostname + ", ioukey=" + hex(ioukey)[2:]
		# create the license using md5sum
		iouPad1='\x4B\x58\x21\x81\x56\x7B\x0D\xF3\x21\x43\x9B\x7E\xAC\x1D\xE6\x8A'
		iouPad2='\x80' + 39*'\0'
		md5input=iouPad1 + iouPad2 + struct.pack('!L', ioukey) + iouPad1
		iouLicense=hashlib.md5(md5input).hexdigest()[:16]
		# add license info to $HOME/.iourc
		print "\n*********************************************************************"
		print "Create the license file $HOME/.iourc with this command:"
		print " echo -e '[license]\\n" + hostname + " = " + iouLicense + ";'" + " | tee $HOME/.iourc "
		print "\nThe command adds the following text to $HOME/.iourc:"
		print "[license]\n" + hostname + " = " + iouLicense + ";"
		# disable phone home feature
		print "\n*********************************************************************"
		print "Disable the phone home feature with this command:"
		print " grep -q -F '127.0.0.1 xml.cisco.com' /etc/hosts || echo '127.0.0.1 xml.cisco.com' | sudo tee -a /etc/hosts"
		print "\nThe command adds the following text to /etc/hosts:"
		print "127.0.0.1 xml.cisco.com"
		print "\n*********************************************************************"
6. Нажимаем i потом esc и прописываем :wq 
7. chmod 777 ioukeygen.py
8. python2 /opt/unetlab/addons/iol/bin/ioukeygen.py
9.  Копируем что то типо этого
    `[license]`  
    `T470P = 413b2074a06a8f08;`
10. vim /opt/unetlab/addons/iol/bin/iourc
11. Туда вставляем 9 пункт
12. Нажимаем i потом esc и прописываем :wq 
13. /opt/unetlab/wrappers/unl_wrapper -a fixpermissions