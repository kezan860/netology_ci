# Самоконтроль выполненения задания

1. Где расположен файл с `some_fact` из второго пункта задания?
2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?
3. Какой командой можно зашифровать файл?
4. Какой командой можно расшифровать файл?
5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?
6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?
7. Как называется модуль подключения к host на windows?
8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh
9. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?


## Ответы:

1. `/group_vars/all/examp.yml`
2. `ansible-playbook -i inventory/test.yml site.yml`
3. `ansible-vault encrypt <имя файла>`
4. `ansible-vault decrypt <имя файла>`
5. `ansible-vault view <имя файлв> так же можно посмотреть и изменить с помощью edit`
6. `ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass`
7. `winrm | Run tasks over Microsoft's WinRM || psrp | Run tasks over Microsoft PowerShell Remoting Protocol`
8. `ansible-doc -t connection -l | ssh - connect via ssh client binary`
9. `remote_user`
