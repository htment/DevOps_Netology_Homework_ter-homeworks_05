FROM jenkins/jenkins:lts

USER root

# Установка базовых пакетов
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    iputils-ping \
    wget \
    dnsutils \
    nano \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Скачивание и установка Terraform
RUN TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | grep -o '"current_version":"[^"]*"' | cut -d '"' -f4) \
    && curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform.zip \
    && chmod +x /usr/local/bin/terraform

# Установка Docker CLI
RUN curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh get-docker.sh


ENV JAVA_OPTS="-Djava.net.preferIPv4Stack=true"

# Установка плагинов 
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN JAVA_OPTS="-Djava.net.preferIPv4Stack=true" \
    jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt --verbose

# Создание директорий для обновлений
#RUN mkdir -p /usr/share/jenkins/ref/updates \
#    && mkdir -p /var/jenkins_home/updates

# Загрузка обновлений Jenkins
#RUN curl -L --retry 3 --retry-delay 5 --connect-timeout 10 https://updates.jenkins.io/update-center.json | sed '1d;$d' > /var/jenkins_home/updates/default.json

# Копирование в ref директорию для сохранения при перезапуске
#RUN cp /var/jenkins_home/updates/default.json /usr/share/jenkins/ref/updates/default.json \
#    && chown -R jenkins:jenkins /usr/share/jenkins/ref/updates \
#    && chown -R jenkins:jenkins /var/jenkins_home/updates

USER jenkins

# Проверка установки
RUN terraform version
