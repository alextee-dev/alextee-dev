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
