# Задание
https://github.com/netology-code/ter-homeworks/blob/main/05/hw-05.md


# Задание 1
Возьмите код:
из ДЗ к лекции 4,
из демо к лекции 4.
Проверьте код с помощью tflint и checkov. Вам не нужно инициализировать этот проект.
Перечислите, какие типы ошибок обнаружены в проекте (без дублей).



## скопируем  ДЗ к лекции 4 

Проверим  код с помощью tflint и checkov

```
cd demonstration1/
```
```
 docker run --rm -v "$(pwd):/tflint" -w /tflint ghcr.io/terraform-linters/tflint
```

![alt text](image.png)


```
docker run --rm --tty --volume $(pwd):/tf --workdir /tf bridgecrew/checkov --download-external-modules true --directory /tf

```

![alt text](image-1.png)

Тут куча коментариев


теперь проверим ```src```

```
cd src/
```
```
docker run --rm -v "$(pwd):/tflint" -w /tflint ghcr.io/terraform-linters/tflint
```
![alt text](image-2.png)

```
 docker run --rm --tty --volume $(pwd):/tf --workdir /tf bridgecrew/checkov --download-external-modules true --directory /tf
```


![alt text](image-3.png)

а тут нет ни чего


# Задание 2



1. Возьмите ваш GitHub-репозиторий с **выполненным ДЗ 4** в ветке 'terraform-04' и сделайте из него ветку 'terraform-05'.
2. Настройте remote state с встроенными блокировками:
   - Создайте S3 bucket в Yandex Cloud для хранения state (если еще не создан)
   - Создайте service account с правами на чтение/запись в bucket
   - Настройте backend в providers.tf с использованием нового механизма блокировок:
     ```hcl
     terraform {
       required_version = "~>1.12.0"
       
       backend "s3" {
         bucket  = "ваш-bucket-name"
         key     = "terraform.tfstate"
         region  = "ru-central1"
         
         # Встроенный механизм блокировок (Terraform >= 1.6)
         # Не требует отдельной базы данных!
         use_lockfile = true
         
         endpoints = {
           s3 = "https://storage.yandexcloud.net"
         }
         
         skip_region_validation      = true
         skip_credentials_validation = true
         skip_requesting_account_id  = true
         skip_s3_checksum            = true
       }
     }
     ```
   - Выполните `terraform init -migrate-state` для миграции state в S3
   - Предоставьте скриншоты процесса настройки и миграции
3. Закоммитьте в ветку 'terraform-05' все изменения.
4. Откройте в проекте terraform console, а в другом окне из этой же директории попробуйте запустить terraform apply.
5. Пришлите ответ об ошибке доступа к state (блокировка должна сработать автоматически).
6. Принудительно разблокируйте state командой `terraform force-unlock <LOCK_ID>`. Пришлите команду и вывод.

**Примечание:** В Terraform >= 1.6 появился встроенный механизм блокировок через `use_lockfile = true`. 
Это упрощает настройку - больше не нужно создавать отдельную базу данных (YDB в режиме DynamoDB) для хранения блокировок.
Lock-файл создается автоматически в том же S3 bucket рядом с state-файлом с именем `<key>.lock.info`.



# Создаем сервисный аккаунт
```
yc iam service-account create --name terraform --folder-id $(yc config get folder-id)
```

## Создадим ключ 
```
yc iam access-key create  --description " yc iam access-key create  --description "sting" --service-account-name terraform2 --format json > access-key.json" --service-account-name terraform2 --format json > access-key.json
```
![alt text](image-4.png)

## Создадим конфиг

```
mkdir -p ~/.aws
cat > ~/.aws/credentials << EOF
[default]
aws_access_key_id =--------------------
aws_secret_access_key = ------------------------------
EOF
```
проверим 
```
 cat  ~/.aws/credentials

```


![alt text](image-5.png)



Инициализируем проект



```
 terraform init

```
![alt text](image-6.png)
```
terraform apply

```
![alt text](image-8.png)
### проверим что локально появился ``terraform.tfstate``



в файл providers.tf добавим 
```
terraform {
  
  backend "s3" {
    bucket  = "test-bucket-netology-homework"  # замените на имя вашего бакета
    key     = "terraform.tfstate"
    region  = "ru-central1"
    
    # Встроенный механизм блокировок (Terraform >= 1.6)
    use_lockfile = true
    
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true

    # Можно добавить явное указание профиля
    profile = "default"
  }
}
```
Инициализируем
```
 terraform init
```


![alt text](image-7.png)
```
terraform apply

```
файл terraform.tfstate пустой  т.к. стайт перенессая в наш бакет
![alt text](image-9.png)


![alt text](image-10.png)


## Проверяем блокировку

В первом терминале открываем консоль:

```
terraform console
```
```
terraform apply -auto-approve
```


![alt text](image-11.png)


## Принудительная разблокировка


```
# Получаем LOCK_ID из предыдущей ошибки и разблокируем
terraform force-unlock 62bd7dd4-84a8-d72e-a342-6b9d3179c5d7
```