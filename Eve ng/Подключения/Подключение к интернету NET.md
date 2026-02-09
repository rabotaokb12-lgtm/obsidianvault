cat /proc/sys/net/ipv4/ip_forward
nano /proc/sys/net/ipv4/ip_forward -> 0 меняем на 1 -> CTRLO ENTER CTRLX

#### КАК net-у сделать так чтобы он давал подключённым к нему устройствам сеть
тут пример с pnet5 (cloud5 на net)
1. В VMWare делаем ещё 1 сетевой адаптер и даём ему VMNet8(Nat) и запоминаем его mac
2. ip -br link | grep -E 'ens|eth|enp' прописываем и сверяем с mac(в нашем случае это eth1)
3. nano /etc/network/interfaces 
   auto pnet5
    iface pnet5 inet manual
    bridge_ports eth1
    bridge_stp off
    bridge_fd 0
4. ip link add name pnet5 type bridge 2>/dev/null || true
    ip link set pnet5 up
    ip link set eth1 up
    ip link set eth1 master pnet5
5. brctl show 
   bridge link
   должно быть что то типо такого 
   pnet5        ...              no           eth1
                           vunl0_1_0(если его нет не переживай он есть)
6. ip address add 192.168.73.5/24 dev pnet5

##### Сохранение всех прописанных настроек eve ng
1. В терминале eve: iptables-save > /etc/network/iptables.rules
2. nano /etc/network/if-pre-up.d/iptables-load
3. В скрипте пишем:
""#!/bin/sh
ip link set pnet5 up
ip link set eth1 up
ip link set eth1 master pnet5
ip address add 192.168.73.5/24 dev pnet5
iptables-restore < /etc/network/iptables.rules
echo "1" > /proc/sys/net/ipv4/ip_forward
exit 0
"" - ковычки не прописывай
4. cd /etc/network/if-pre-up.d/
5. chmod +x iptables-load
6. ls -al