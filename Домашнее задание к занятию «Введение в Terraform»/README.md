terraform --version
![image](https://github.com/user-attachments/assets/2c4f4a5d-870d-4877-9a7a-0243b5b98338)

Задание 1

  1.
  ![image](https://github.com/user-attachments/assets/bd1c81f5-5951-439d-84bf-014f2557d89c)

  2.
    a) В любом файле, находящимся в директории ".terraform/"
    b) в любом файле, имя которого начинается с .terraform*, кроме .terraformrc
    c) В personal.auto.tfvars 
  3. "result": "xBhgLI3Z29aYtHC0"
  4.
    a) resource "docker_image" { - В блоке resource указана только одна метка, должно быть тип и имя.
    b) resource "docker_container" "1nginx" { - Имя не может начинаться с цифры
    c) name  = "example_${random_password.random_string_FAKE.resulT}" -  В конфигурации нет ресурса с названием "random_string_FAKE". И в ресурсе нет атрибута resulT, есть result

  5.
![Задание 1-5](https://github.com/user-attachments/assets/cffbc7ed-ac6a-45d2-9c9c-ba8e2f90a8e2)
![docker ps](https://github.com/user-attachments/assets/995bad81-e891-493e-b4cb-822feb5484a9)

  6. Не посмотрев перед применением конфиг, можно выкатить то, чего не планировалось. Ключ -auto-approve может пригодиться для автоматизации или для массовых изменений
     ![hello docker ps](https://github.com/user-attachments/assets/5c597ee5-80ef-4f0b-9d08-f6cf0fe3aa3b)

  7.
![image](https://github.com/user-attachments/assets/e877b042-aa25-4ec7-a27e-5a83cb4a9664)

  8. Потому что в блоке resource "docker_image" "nginx" есть параметр keep_locally = true.
     ![Скриншот 11-12-2024 170915](https://github.com/user-attachments/assets/480123b9-3716-4576-b4a5-652ad1aded03)


