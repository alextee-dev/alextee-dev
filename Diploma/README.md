**Создание облачной инфраструктуры**

1. Предварительные настройки

Манифесты: https://github.com/alextee-dev/alextee-dev/tree/main/Diploma/infrastructure/prereq
В предварительной инфраструктуре создаю сеть, бакет, серивисную учетку и права к ней, также в этот этап вынес вм для ci/cd так как через нее будет настроено отслеживание изменений инфраструктуры

2. Основная инфраструктура

Манифесты: https://github.com/alextee-dev/diploma_ifrastructure
Создаю вм для k8s в виде отдельной для control node и группы вм для worker node. Для доступа к графане и тестовому приложению использую Application Load Balancer

![main](https://github.com/user-attachments/assets/e909071e-f6c0-4ffc-8d41-a5509d4d0e15)


**Создание Kubernetes кластера**

Настраиваю кластер через Kubespray - https://github.com/kubernetes-sigs/kubespray

![kubespray](https://github.com/user-attachments/assets/a5bd90cb-bbd3-4a80-b5b9-2226994ca63e)

**Создание тестового приложения**

Тестовое приложение в виде nginx с простой html страничкой
Репозиторий с приложением: https://github.com/alextee-dev/test_app
Ссылка на образ в регистри: cr.yandex/crpuvcd43esdeav9vcdq/nginx-custom:25

**Подготовка cистемы мониторинга и деплой приложения**

Для равертывания мониторинга использовал kube-prometheus, сделал фетч резозитория и поправил сервис и сетевые правила для графаны https://github.com/alextee-dev/kube-prometheus

![kubectl](https://github.com/user-attachments/assets/4e578c68-44d5-4075-9582-d9e4218a0190)

Доступ к приложениям настроен через 80 порт баласировщика (NodePort + Application Load Balancer)

![mon1](https://github.com/user-attachments/assets/bac4f8ff-05ca-494d-8ccb-c04ac69a0705)

![mon2](https://github.com/user-attachments/assets/9ebe71a1-b32d-4ef2-aef9-e4ea625925ce)

![mon3](https://github.com/user-attachments/assets/b9a74062-2ab4-4ff0-a4c3-d87de9cdedeb)

![test-app](https://github.com/user-attachments/assets/0e262b15-bc0f-4e42-859c-15f3a608566c)

**Установка и настройка CI/CD**

В качестве CI/CD выбрал TeamCity, отслеживание изменений инфраструктуры также настроил через ci\cd
Конфигурирую при помощи Ansible - https://github.com/alextee-dev/alextee-dev/tree/main/Diploma/configure/teamcity

![teamcity](https://github.com/user-attachments/assets/21a3fa62-3973-4c72-b53d-40f81de120ef)

Тестовое приложение:

![app1](https://github.com/user-attachments/assets/e6b78fb9-1790-4161-bda3-852962e8266d)

![app2](https://github.com/user-attachments/assets/09e88362-3881-468b-b2e2-faab661a11b0)

![app3](https://github.com/user-attachments/assets/fcd754a8-5de1-44b3-926f-463535d24965)

![app](https://github.com/user-attachments/assets/266c4c93-7fe6-44d2-bb68-e2e1771ce889)

Инфраструктура:

![infr](https://github.com/user-attachments/assets/e09324cc-4f57-400b-8c59-9486d58c9070)

![infr1](https://github.com/user-attachments/assets/5ab3e9ee-e0d8-465c-b35a-b5db4ed797ec)

![infr2](https://github.com/user-attachments/assets/4e728630-69e8-4294-b9d3-8a4f0da2492d)

Вся инфраструктура в облаке:

![image](https://github.com/user-attachments/assets/341d463b-acd9-4c86-99ee-301930d5682f)





