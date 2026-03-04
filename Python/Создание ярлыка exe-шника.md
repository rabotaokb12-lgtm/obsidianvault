py -m pip install pyinstaller
Идёшь в путь где лежит код
py -m PyInstaller --onefile --noconsole Keepass_auto.py

Если это не один файл а проект то 
py -m PyInstaller --onefile --noconsole --name "Rabotyaga_V3" main.py