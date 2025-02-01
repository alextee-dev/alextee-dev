1. prod.yml
```
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 84.252.130.78
      ansible_connection: ssh
      ansible_user: ansible
      ansible_ssh_private_key_file: ~/.ssh/yc-ansible

vector:
  hosts:
    vector-01:
      ansible_host: 89.169.152.24
      ansible_connection: ssh
      ansible_user: ansible
      ansible_ssh_private_key_file: ~/.ssh/yc-ansible
```
