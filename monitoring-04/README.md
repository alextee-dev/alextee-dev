1. ![1](https://github.com/user-attachments/assets/14b26f57-0f99-442b-b623-521b2964f91b)

2. ![2-1](https://github.com/user-attachments/assets/be567583-6424-493c-936c-765ad2e2a388)
![2-2](https://github.com/user-attachments/assets/81a448bb-8b5e-4699-a780-95253ef6d47e)

3. ![3](https://github.com/user-attachments/assets/65a430d6-fe26-4b42-a7d0-5ebb127f51cc)

Дополнительное задание:
![add](https://github.com/user-attachments/assets/c3ef8a65-033c-4cc2-a4f3-d9c9253be8a0)

```
import sentry_sdk

# Инициализация Sentry
sentry_sdk.init(
    dsn="https://5f924ea64260e573be15ce233c5c26c1@o4509031817871360.ingest.de.sentry.io/4509031841202256",
    # Add data like request headers and IP for users,
    # see https://docs.sentry.io/platforms/python/data-management/data-collected/ for more info
    send_default_pii=True,
)

def divide(a, b):
    return a / b

def main():
    try:
        print(divide(10, 0))  # Это вызовет ошибку деления на ноль
    except Exception as e:
        sentry_sdk.capture_exception(e)  # Отправляем событие в Sentry

    # Отправка тестового события
    sentry_sdk.capture_message("Это тестовое сообщение для Sentry")

if __name__ == "__main__":
    main()
```
