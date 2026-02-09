#### Cisco IOL I86 L2 (l2 Свич)
НО СУКА ПОНИМАЙ ЧТО НУЖНО СТАВИТЬ СВОИ IP И СВОИ ПОРТЫ И СВОИ ШЛЮЗЫ ТУТ ПРОСТО ПРИМЕР
 Вписываем команды
   enable
   conf t
   interface ethernet0/0
   switchport mode access
   switchport access vlan 100
   no shut
   interface vlan 100
   ip address 192.168.100.3 255.255.255.0
   no shut
   ip routing
   end
   
   conf t
   ip route 0.0.0.0 0.0.0.0 192.168.100.1
   end

Проверка:
     show ip interface brief
     show interface status

#### Cisco VIOSL2 (l2 l3 свич)
enable
conf t
interface gi0/0
swithport mode access
switchport access vlan 100
no shut
exit
interface vlan 100
ip address 192.168.100.3 255.255.255.0
ip routing
no shut
exit
ip route 0.0.0.0 0.0.0.0 192.168.100.1
ip default-gateway 192.168.100.1
end
write memory

**Выдача порту транк**
	enable
	conf t
	interface gi0/0
	switchport trunk encapsulation dot1q
	switchport mode trunk
	switchport trunk allowed vlan 20,30,40,100
	или
	 switchport trunk allowed vlan all - типо все вланы разрешены

**Создание vlan-ов**
	conf t
	vlan 10 
	name LAN_10
	exit
	interface vlan 10
	ip address 192.168.10.1 255.255.255.0
	no shut
	end
	write memory

**Команды для просмотра состояния сети**
	show ip interface brief
	show interface status
	show interfaces trunk
	show interface e0/0 switchport
	show vlan brief - пул вланов
	show ip arp - весь пул ip адресов и их мак адреса 
	.
	show ip dhcp pool - пул dhcp серверов
	show ip dhcp binding - список ip выданных dhcp
	show ip dhcp conflict-конфликты адресов dhcp
	show running-config | section dhcp  - просмотр конфига dhcp
	show ip dhcp server statistics-статистика dhcp
	
	

**Запрет взаимодействия между vlan-ами**
	На примере 30 и 20 
	ip access-list extended BLOCK_VLAN20_TO_30
	 deny ip 192.168.20.0 0.0.0.255 192.168.30.0 0.0.0.255
	 deny ip 192.168.30.0 0.0.0.255 192.168.20.0 0.0.0.255
	 permit ip any any
	!
	interface Vlan20
	 ip access-group BLOCK_VLAN20_TO_30 in
	!
	interface Vlan30
	 ip access-group BLOCK_VLAN20_TO_30 in

**Создание dhcp сервера**
	enable
	conf t
	ip dhcp pool VLAN20
	 network 192.168.20.0 255.255.255.0
	 default-router 192.168.20.1
	 dns-server 192.168.100.1 
	 lease 0 0 30
	 end или exit
	 .
	 conf t
	 ip dhcp ping packets 1
	 ip dhcp ping timeout 500
	 Ручная очистка пула dhcp 
	 clear ip dhcp binding *
	 clear ip dhcp conflict *
	 Просмотр применилось ли
	 show running-config | include dhcp
	 show running-config | section dhcp