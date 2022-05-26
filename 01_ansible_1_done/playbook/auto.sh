echo "Создание контейнеров"
docker run -di --name ubuntu pycontribs/ubuntu bash
docker run -di --name centos7 centos:7 bash
docker run -di --name fedora pycontribs/fedora bash

echo "Запуск playbook"
ansible-playbook -i inventory/prod.yml site.yml

echo "Удаление запущенных контейнеров"
docker rm -f ubuntu
docker rm -f centos7
docker rm -f fedora
