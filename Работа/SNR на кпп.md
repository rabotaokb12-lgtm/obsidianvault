lПодключаемся по telnet к кпп
enable
show mac address-table | include xxxx.xxxx.xxxx (заметь формат точек именно такой)
conf t
interface ge?
switchport mode trunk
switchport trunk allowed vlan all
write 

Для создания влана 
conf t
vlan 101
exit
show vlan brief
write

хуй знает быть может