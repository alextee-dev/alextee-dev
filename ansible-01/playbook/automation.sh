docker run -dit --name fed pycontribs/fedora
docker run -dit --name centos7 pycontribs/centos:7
docker run -dit --name ubuntu pycontribs/ubuntu:latest
ansible-playbook site.yml -i ./inventory/prod.yml --vault-password-file vault.txt
docker rm -f fed
docker rm -f centos7
docker rm -f ubuntu