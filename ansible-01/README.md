**Обязательная часть**

1. ![image](https://github.com/user-attachments/assets/82a5580c-3c93-4546-b45a-035ffeed2065)

2. ![image](https://github.com/user-attachments/assets/9fe05b60-2af2-4002-b731-7aad232e6e46)

3-4. ![image](https://github.com/user-attachments/assets/e8a9770e-6e61-45ac-92fa-20218747e83c)

5-6. ![image](https://github.com/user-attachments/assets/d5faeff8-0464-462b-b022-dab4a1f0ec16)

7. ![image](https://github.com/user-attachments/assets/19467ddd-0198-4c43-ba09-9341dc6b5b37)

8. ![image](https://github.com/user-attachments/assets/55557d51-701e-4220-a41e-145958c54576)


9. ansible-doc -t connection -l
    ansible.builtin.local          execute on controller

10-11.
```
local:
    hosts:
      localhost:
        ansible_connection: local
```
    
![image](https://github.com/user-attachments/assets/e269b8c5-3e87-4dad-b1b7-43db6cd9e575)


**Необязательная часть**

1. ![image](https://github.com/user-attachments/assets/7c1b5457-2199-450b-8346-f6e5947772db)

2. ![image](https://github.com/user-attachments/assets/5123ef98-12d3-449a-a634-835055ceaf39)
3. ![image](https://github.com/user-attachments/assets/594f06ff-b19c-4738-9516-bd283d0538da)
4. ![image](https://github.com/user-attachments/assets/6a191818-54ac-457c-8fe6-0805d2102620)
5.
```
docker run -dit --name fed pycontribs/fedora
docker run -dit --name centos7 pycontribs/centos:7
docker run -dit --name ubuntu pycontribs/ubuntu:latest
ansible-playbook site.yml -i ./inventory/prod.yml --vault-password-file vault.txt
docker rm -f fed
docker rm -f centos7
docker rm -f ubuntu
```
![image](https://github.com/user-attachments/assets/b3f3f9a7-26e8-40a5-8b80-65466c43d62c)
