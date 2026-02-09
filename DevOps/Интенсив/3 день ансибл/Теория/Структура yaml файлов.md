``` yaml
- name: настройка моего сервера 
  hosts: myserver #имя в inventory файле
  become: yes #Повышение привелегий для всех задач
  tasks: 
	- name: Проверить доступность сервера
	  ping: 
	  
	- name: Показать информацию о сервере
	  debug: 
	    msg: |
			Настраиваем сервер: {{ ansible_hostname }}
			IP адрес: {{ansible_default_ipv4.address }}
			ОС: {{ ansible_dustibution }} {{ ansible_distribution_version }}
			Всего памяти: {{ ansible_memtotal_mb }} MB
			#Это всё переменные {{}} внутри ансибла
			
	- name: Обновить систему 
	  apt: 
		update_cache: yes #тоже самое что apt update
		cache_valid_time: 3600 
			#Не обновлять кэш если он обновлялся в последние 3600 сек
	  when: ansible_os_family == "Debian" 
		  #Только на дебиан подобных дистрибутивах(там и ubuntu и т.д)
	
	- name: Установить базовые пакеты
	  package: #Автоматически определяет какой пакетный менеджер ему использовать
		name:
		    - htop
		    - vim
		    - curl
		    - wget
		    - git
		state: present 
			#Если пакеты установлены пропустить, если нет установить
			
	- name: Создать юзера для приложений
	  user: 
		name: appuser #Имя пользователя
		shell: /bin/bash #Какой shell дать
		create_home: yes #Создать дом.дир
		groups: sudo
		append: yes 
			#Добавить к существующим группам а не заменять их
		state: present 
	
	- name: Настроить базовый фаирвол
	  ufw:
		rule: allow 
		port: "{{ item }}"
		proto: tcp
	  loop:
		- "22"
		- "80"
		- "443"
		  #Правило говорить разрешить входящие подключения только на этих портах 
	  notify: enable ufw
	  
	- name: создать структуру директорий 
	  file:
	    path: "{{ item }}"
	    state: directory
		    #Если нет директорий создать, если есть убедиться в правильности параметров те что ниже 
	    owner: appuser
	    group: appuser
	    mode: '0755'
		    #ПРОСТО НАДО СТАВИТЬ 0 ВСЕГДА
	  loop:
	    - /opt/apps
	    - /var/log/apps 
	    - /etc/apps
	
	- name: Создать файл с информацией о настройке 
	  template: 
	    src: server_info.j2
	    dest: /etc/server_configured.txt
		    #Конечная точка куда сохранить
	    owner: root
	    group: root
	    mode: '0644' 
	    
    handlers: 
    - name: enble ufw
      ufw:
        state: enabled
        policy: allow
        #БЛЯТЬ КАРОЧЕ NOTIFY ГОВОРИТ СДЕЛАЙ ЭТО ЕСЛИ БЫ БЫЛИ КАКИЕ ЛИБО ИЗМЕНЕНИЯ
```