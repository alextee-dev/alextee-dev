# Ansible Playbook: Install Clickhouse and Vector

## Описание

Этот Ansible плейбук предназначен для установки и настройки Clickhouse, Lighthouse и Vector на целевых хостах. Плейбук включает задачи по загрузке, установке и настройке необходимых пакетов, а также созданию базы данных для Clickhouse.

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

### Install Lighthouse
- **Hosts:** `lighthouse`
- **Handlers:** 
  - `Start nginx service`: Запускает службу nginx после применения конфигурации.
- **Tasks:**
  - `Install git packages`: Устанавливает пакеты git.
  - `Install nginx packages`: Устанавливает пакеты nginx.
  - `Clone lighthouse repo`: Клонирует GitHub репозиторий Lighthouse.
  - `Add nginx config`: Добавляет конфигурационный файл для nginx.
  - `Flush handlers`: Применяет все зарегистрированные обработчики.

## Переменные

| Переменная              | Описание                                 | Пример значения |
|-------------------------|------------------------------------------|-----------------|
| `clickhouse_version`    | Версия Clickhouse                        | `21.3.2.5`      |
| `clickhouse_packages`   | Список пакетов Clickhouse для установки  | `["clickhouse-common-static", "clickhouse-client", "clickhouse-server"]` |

## Требования

- Ansible 2.9+




## Скриншоты выполения

![image](https://github.com/user-attachments/assets/b93866af-b1ff-4205-8b62-3b0f229f7466)

![image](https://github.com/user-attachments/assets/0219adad-df7c-4a2b-b849-505e29136b1a)

![image](https://github.com/user-attachments/assets/493ffbce-8334-4e51-ac4c-8d55f302a13d)



