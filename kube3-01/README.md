**Расчет необходимых ресурсов**

База данных (3 копии): 12Гб 3 CPU

Кеш (3 копии): 12Гб 3 CPU

Фронтенд (5 копий): 0.25 ГБ 1 CPU

Бекенд (10 копий): 6 ГБ 10 CPU

Итого без учета запаса:

ОЗУ: 30.25 ГБ

CPU: 17 ядер

Плюс 2гб 0.1 cpu под ОС и kubelet на каждую ноду

Плюс запас для возможности потери одной ноды. Увеличим требования на 20%

**Итоговая конфигурация**:

Количество нод: 3

Параметры каждой ноды:

CPU: 8 ядер

ОЗУ: 32 ГБ
