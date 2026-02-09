/opt/unetlab/wrappers/unl_wrapper -a fixpermissions

1. echo "qemu" > /opt/unetlab/platform
2. chmod 644 /opt/unetlab/platform
3. systemctl restart nginx
4. systemctl restart apache2