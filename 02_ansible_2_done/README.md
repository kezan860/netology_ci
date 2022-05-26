# Домашнее задание к занятию "08.02 Работа с Playbook"
## Основная часть
1. Приготовьте свой собственный inventory файл `prod.yml`.

### Ответ: 

```
✗ cat inventory/prod.yml 
---
elasticsearch:
  hosts:
    elastic01:
      ansible_connection: docker
kibana:
  hosts:
    kibana01:
      ansible_connection: docker
```

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.

### Ответ:

```
Создал дополнительный хост для kibana, чтобы не нарушать микросервисную архитектуру

- name: Install Kibana
  hosts: kibana
  tasks:
    - name: Upload tar.gz Kibana from remote URL
      get_url:
        url: "https://artifacts.elastic.co/downloads/kibana/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        mode: 0755
        timeout: 60
        force: true
        validate_certs: false
      register: get_kibana
      until: get_kibana is succeeded
      tags: kibana
    - name: Create directrory for Kibana ({{ kibana_home }})
      file:
        path: "{{ kibana_home }}"
        state: directory
      tags: kibana
    - name: Extract Kibana in the installation directory
      become: yes
      unarchive:
        copy: false
        src: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "{{ kibana_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ kibana_home }}/bin/kibana"
      tags:
        - skip_ansible_lint
        - kibana
    - name: Set environment Kibana
      become: yes
      template:
        src: templates/kib.sh.j2
        dest: /etc/profile.d/kib.sh
      tags: kibana
```

3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.

### Ответ:

```
Добавил
```

4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.

### Ответ:

```
Выполняется
```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

### Ответ:

```
Ошибок не обнаружено

✗ ansible-lint site.yml -vvv
Examining site.yml of type playbook
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

### Ответ:

```
✗ ansible-playbook -i inventory/prod.yml site.yml --check

PLAY [Install Java] ****************************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host kibana01 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible
release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible-core/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [kibana01]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host elastic01 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible
release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible-core/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [elastic01]

TASK [Set facts for Java 11 vars] **************************************************************************************************************************************************************************
ok: [elastic01]
ok: [kibana01]

TASK [Upload .tar.gz file containing binaries from local storage] ******************************************************************************************************************************************
ok: [elastic01]
ok: [kibana01]

TASK [Ensure installation dir exists] **********************************************************************************************************************************************************************
ok: [elastic01]
ok: [kibana01]

TASK [Extract java in the installation directory] **********************************************************************************************************************************************************
skipping: [elastic01]
skipping: [kibana01]

TASK [Export environment variables] ************************************************************************************************************************************************************************
ok: [kibana01]
ok: [elastic01]

PLAY [Install Elasticsearch] *******************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************
ok: [elastic01]

TASK [Check that the elasticsearch.tar.gz exists] **********************************************************************************************************************************************************
ok: [elastic01]

TASK [Upload tar.gz Elasticsearch from remote URL] *********************************************************************************************************************************************************
skipping: [elastic01]

TASK [Create directrory for Elasticsearch] *****************************************************************************************************************************************************************
ok: [elastic01]

TASK [Extract Elasticsearch in the installation directory] *************************************************************************************************************************************************
skipping: [elastic01]

TASK [Set environment Elastic] *****************************************************************************************************************************************************************************
ok: [elastic01]

PLAY [Install Kibana] **************************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************
ok: [kibana01]

TASK [Upload tar.gz Kibana from remote URL] ****************************************************************************************************************************************************************
changed: [kibana01]

TASK [Create directrory for Kibana (/opt/kibana/7.12.0)] ***************************************************************************************************************************************************
ok: [kibana01]

TASK [Extract Kibana in the installation directory] ********************************************************************************************************************************************************
skipping: [kibana01]

TASK [Set environment Kibana] ******************************************************************************************************************************************************************************
ok: [kibana01]

PLAY RECAP *************************************************************************************************************************************************************************************************
elastic01                  : ok=9    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
kibana01                   : ok=9    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

### Ответ:

```
✗ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Java] ****************************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host elastic01 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible
release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible-core/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [elastic01]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host kibana01 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible
release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible-core/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [kibana01]

TASK [Set facts for Java 11 vars] **************************************************************************************************************************************************************************
ok: [kibana01]
ok: [elastic01]

TASK [Upload .tar.gz file containing binaries from local storage] ******************************************************************************************************************************************
ok: [kibana01]
ok: [elastic01]

TASK [Ensure installation dir exists] **********************************************************************************************************************************************************************
ok: [kibana01]
ok: [elastic01]

TASK [Extract java in the installation directory] **********************************************************************************************************************************************************
skipping: [kibana01]
skipping: [elastic01]

TASK [Export environment variables] ************************************************************************************************************************************************************************
ok: [kibana01]
ok: [elastic01]

PLAY [Install Elasticsearch] *******************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************
ok: [elastic01]

TASK [Check that the elasticsearch.tar.gz exists] **********************************************************************************************************************************************************
ok: [elastic01]

TASK [Upload tar.gz Elasticsearch from remote URL] *********************************************************************************************************************************************************
skipping: [elastic01]

TASK [Create directrory for Elasticsearch] *****************************************************************************************************************************************************************
ok: [elastic01]

TASK [Extract Elasticsearch in the installation directory] *************************************************************************************************************************************************
skipping: [elastic01]

TASK [Set environment Elastic] *****************************************************************************************************************************************************************************
ok: [elastic01]

PLAY [Install Kibana] **************************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************
ok: [kibana01]

TASK [Check that the kibana.tar.gz exists] *****************************************************************************************************************************************************************
ok: [kibana01]

TASK [Upload tar.gz Kibana from remote URL] ****************************************************************************************************************************************************************
skipping: [kibana01]

TASK [Create directrory for Kibana (/opt/kibana/7.12.0)] ***************************************************************************************************************************************************
ok: [kibana01]

TASK [Extract Kibana in the installation directory] ********************************************************************************************************************************************************
skipping: [kibana01]

TASK [Set environment Kibana] ******************************************************************************************************************************************************************************
ok: [kibana01]

PLAY RECAP *************************************************************************************************************************************************************************************************
elastic01                  : ok=9    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
kibana01                   : ok=9    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

### Ответ:

```
✗ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Java] ****************************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host elastic01 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible
release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible-core/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [elastic01]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host kibana01 should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible
release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible-core/2.11/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [kibana01]

TASK [Set facts for Java 11 vars] **************************************************************************************************************************************************************************
ok: [elastic01]
ok: [kibana01]

TASK [Upload .tar.gz file containing binaries from local storage] ******************************************************************************************************************************************
ok: [kibana01]
ok: [elastic01]

TASK [Ensure installation dir exists] **********************************************************************************************************************************************************************
ok: [kibana01]
ok: [elastic01]

TASK [Extract java in the installation directory] **********************************************************************************************************************************************************
skipping: [elastic01]
skipping: [kibana01]

TASK [Export environment variables] ************************************************************************************************************************************************************************
ok: [kibana01]
ok: [elastic01]

PLAY [Install Elasticsearch] *******************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************
ok: [elastic01]

TASK [Check that the elasticsearch.tar.gz exists] **********************************************************************************************************************************************************
ok: [elastic01]

TASK [Upload tar.gz Elasticsearch from remote URL] *********************************************************************************************************************************************************
skipping: [elastic01]

TASK [Create directrory for Elasticsearch] *****************************************************************************************************************************************************************
ok: [elastic01]

TASK [Extract Elasticsearch in the installation directory] *************************************************************************************************************************************************
skipping: [elastic01]

TASK [Set environment Elastic] *****************************************************************************************************************************************************************************
ok: [elastic01]

PLAY [Install Kibana] **************************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************
ok: [kibana01]

TASK [Check that the kibana.tar.gz exists] *****************************************************************************************************************************************************************
ok: [kibana01]

TASK [Upload tar.gz Kibana from remote URL] ****************************************************************************************************************************************************************
skipping: [kibana01]

TASK [Create directrory for Kibana (/opt/kibana/7.12.0)] ***************************************************************************************************************************************************
ok: [kibana01]

TASK [Extract Kibana in the installation directory] ********************************************************************************************************************************************************
skipping: [kibana01]

TASK [Set environment Kibana] ******************************************************************************************************************************************************************************
ok: [kibana01]

PLAY RECAP *************************************************************************************************************************************************************************************************
elastic01                  : ok=9    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
kibana01                   : ok=9    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
```

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

Ссылка на файл: https://github.com/kezan860/devops/blob/main/mnt-homeworks/02_ansible2/playbook/README.md

10. Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.

Ссылка на репозиторий: https://github.com/kezan860/devops/tree/main/mnt-homeworks/02_ansible2/playbook
