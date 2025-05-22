![1](https://github.com/user-attachments/assets/997f4c75-4876-46a6-8fb6-170818aeb71d)

![2](https://github.com/user-attachments/assets/d6a0ef23-ddd8-4087-bfd3-b3b69fceb84e)


Так как deployments находятся в разных namespace, при выполнении команды curl auth-db выходит ошибка разрешения имен. Решилось дописанием к имени сервиса, имя namespace - auth-db.data

![3](https://github.com/user-attachments/assets/53999bfc-aa19-4d8f-9fc1-93a690fc55b5)

Исправленный манифест: https://github.com/alextee-dev/alextee-dev/blob/main/kube3-05/deployment.yaml
