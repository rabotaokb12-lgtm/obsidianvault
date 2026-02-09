1. Скачиваем образ img с сайта mikrotik https://mikrotik.com/download/archive 
   Поддерживаемые версий **6.44.5, 6.48.6, 7.2.3, 7.3.1, 7.4.1, 7.5.0, 7.6.0**
2. Создаём папку по пути /opt/unetlab/addons/qemu/**miktorik-версия** используем для этого WinSCP
3. Закидываем туда img файл и переименовываем его в hda.qcow2
   *Опционально*: можем переименовать в ручную используя команду 
   cd /opt/unetlab/addons/qemu/mikrotik-версия/ - для перехода в эту папку
   mv файл.img hda.qcow2 - для переименовывания
4. /opt/unetlab/wrappers/unl_wrapper -a fixpermissions - прописываем для поправки прав
