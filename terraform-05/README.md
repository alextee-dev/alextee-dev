**Задание 1**

Tflint типы ошибок: 
  1) В качестве источника для модуля используется ветка main
  ![image](https://github.com/user-attachments/assets/52be1da6-c350-4d7e-bb4f-c12fdb5746e4)
  2) Отсутствует ограничение версии для провайдера
     ![image](https://github.com/user-attachments/assets/60c87569-b046-4cba-971f-a010d0ba3ae3)
  3) Неиспользуемые переменные
     ![image](https://github.com/user-attachments/assets/f6a86233-fd5e-4a69-8638-0c6e66d93792)

Chekov типы ошибок:
  1) Использование внешнего IP для вм
     ![image](https://github.com/user-attachments/assets/cd4eec49-b62c-4a5f-ac3a-046e955b3d0b)
  2) Не назначена группа безопасности для сетевого интерфейса
     ![image](https://github.com/user-attachments/assets/7faf014d-add2-4c2b-8e85-1a1869a55bbf)
  3) Не используется определенный коммит в источнике модуля
     ![image](https://github.com/user-attachments/assets/40dc0304-100f-4282-a2a9-431e63c718d8)
  4) Нет тега с версией в источнике модуля
     ![image](https://github.com/user-attachments/assets/b7dd0196-fbd8-434e-a566-63b7451710af)
  5) Явно указанный пароль
     ![image](https://github.com/user-attachments/assets/f39c6cc0-1e0e-40c8-98a2-5ceaf48d03fe)

**Задание 2**

![image](https://github.com/user-attachments/assets/d9cd1dc1-80d3-491b-9ff5-9644cedb5a49)
![image](https://github.com/user-attachments/assets/ac8e7944-70fc-4db3-94ae-e7148fdc5778)
![image](https://github.com/user-attachments/assets/05050ffd-8ec6-469f-8781-24b6514b4818)
![image](https://github.com/user-attachments/assets/238191d3-c507-421e-8a70-87c688a5b58f)
![image](https://github.com/user-attachments/assets/735a7548-9ae7-429b-8454-a2dc0781e82f)

**Задание 3**

https://github.com/alextee-dev/alextee-dev/pull/1

**Задание 4**

```
variable "ip_address" {
  type        = string
  description = "IP-адрес"
  validation {
    condition     = can(regex("^(25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?))$", var.ip_address))
    error_message = "Значение переменной 'ip_address' должно быть корректным IPv4-адресом."
  }
}

variable "ip_addresses" {
  type        = list(string)
  description = "Список IP-адресов"
  validation {
    condition     = alltrue([for ip in var.ip_addresses : can(regex("^(25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?))$", ip))])
    error_message = "Все адреса в списке 'ip_addresses' должны быть корректными IPv4-адресами."
  }
}
```
![image](https://github.com/user-attachments/assets/720a4f85-0038-4f9c-b329-1e7658109894)
![image](https://github.com/user-attachments/assets/aa75d378-3f88-4463-aa36-f0cefce6ca39)

**Задание 5**

```
variable "example_string" {
  type        = string
  default     = "строка без верзнего регистра"

  validation {
    condition     = can(regex("^[a-zа-яё0-9\\s]*$", var.example_string))
    error_message = "Строка не должна содержать символов верхнего регистра."
  }
}
```
![image](https://github.com/user-attachments/assets/3c85f65e-0e10-43b7-ac8b-85aa35ab2470)
