# Ansible Playbook: Install Clickhouse and Vector

## Описание

Этот Ansible плейбук предназначен для установки и настройки Clickhouse и Vector на целевых хостах. Плейбук включает задачи по загрузке, установке и настройке необходимых пакетов, а также созданию базы данных для Clickhouse.

## Плейбуки

### Install Clickhouse
- **Hosts:** `clickhouse`
- **Handlers:** 
  - `Start clickhouse service`: Запускает службу Clickhouse после установки.
- **Tasks:**
  - `Get clickhouse distrib`: Загружает дистрибутивы Clickhouse.
  - `Get alternative clickhouse distrib`: Загружает альтернативный дистрибутив Clickhouse при неудаче.
  - `Install clickhouse packages`: Устанавливает пакеты Clickhouse.
  - `Flush handlers`: Применяет все зарегистрированные обработчики.
  - `Create database`: Создает базу данных `logs`.

### Install Vector
- **Hosts:** `vector`
- **Handlers:** 
  - `Start vector service`: Запускает службу Vector после установки.
- **Tasks:**
  - `Add the Vector repo`: Добавляет репозиторий Vector.
  - `Install vector packages`: Устанавливает пакеты Vector.
  - `Add config`: Добавляет конфигурационный файл для Vector.
  - `Flush handlers`: Применяет все зарегистрированные обработчики.

## Переменные

| Переменная              | Описание                                 | Пример значения |
|-------------------------|------------------------------------------|-----------------|
| `clickhouse_version`    | Версия Clickhouse                        | `21.3.2.5`      |
| `clickhouse_packages`   | Список пакетов Clickhouse для установки  | `["clickhouse-common-static", "clickhouse-client", "clickhouse-server"]` |

## Требования

- Ansible 2.9+




## Скриншоты выполения
5. ![image](https://github.com/user-attachments/assets/3f2c2ff9-b336-4ed8-921d-b71cc64133af)

После исправления:
https://github.com/alextee-dev/alextee-dev/commit/ffbc196d8afbef0397e77f4305dc479a9878102a
![image](https://github.com/user-attachments/assets/45bcf987-6201-49b5-9658-a7b1c571eb4a)

6. ![image](https://github.com/user-attachments/assets/1606581a-d4a4-4a0d-bf65-4c5eccda32b0)
   
7. ![image](https://github.com/user-attachments/assets/357ea580-1b67-41ed-907b-d2d35756add9)

8. ![image](https://github.com/user-attachments/assets/6036651c-c911-4fea-a171-fedc29955539)
