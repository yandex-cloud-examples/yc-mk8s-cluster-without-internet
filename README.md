# Создание и настройка кластера Managed Service for Kubernetes® без доступа в интернет

Вы можете создать и настроить кластер Managed Service for Kubernetes®, для которого недоступно подключение к интернету. Для этого используется следующая конфигурация:

* У кластера и группы узлов Managed Service for Kubernetes нет публичного адреса. К такому кластеру можно подключиться только с виртуальной машины Yandex Cloud.
* Кластер и группа узлов размещены в подсетях без доступа в интернет.
* У сервисных аккаунтов нет ролей на работу с ресурсами, имеющими доступ в интернет, например [Yandex Network Load Balancer](https://cloud.yandex.ru/ru/docs/network-load-balancer/).
* Группы безопасности кластера ограничивают входящий и исходящий трафик.

Подробное руководство см. в [документации Yandex Cloud](https://cloud.yandex.ru/ru/docs/managed-kubernetes/tutorials/k8s-cluster-with-no-internet).