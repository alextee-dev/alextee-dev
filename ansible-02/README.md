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
2-4. 
```
- name: Install Vector
  hosts: vector
  handlers:
    - name: Start vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
  tasks:
    - block:
      - name: Add the Vector repo
        ansible.builtin.shell: bash -c "$(curl -L https://setup.vector.dev)"

      - name: Install vector packages
        become: true
        ansible.builtin.yum:
         name:
           - vector

      - name: Add config
        become: true
        ansible.builtin.template:
          src: templates/vector.j2
          dest: /etc/vector/vector.yaml
      notify: Start vector service
    - name: Flush handlers
      meta: flush_handlers
```
5. ![image](https://github.com/user-attachments/assets/3f2c2ff9-b336-4ed8-921d-b71cc64133af)

После исправления:
https://github.com/alextee-dev/alextee-dev/commit/ffbc196d8afbef0397e77f4305dc479a9878102a
![image](https://github.com/user-attachments/assets/45bcf987-6201-49b5-9658-a7b1c571eb4a)

6. ![image](https://github.com/user-attachments/assets/1606581a-d4a4-4a0d-bf65-4c5eccda32b0)
   
7. ![image](https://github.com/user-attachments/assets/357ea580-1b67-41ed-907b-d2d35756add9)

8. ![image](https://github.com/user-attachments/assets/6036651c-c911-4fea-a171-fedc29955539)
