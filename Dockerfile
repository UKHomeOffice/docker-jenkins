FROM jenkins/jenkins:lts

# Upgrade everything as root
USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://get.docker.com/ | sh

RUN usermod -aG docker jenkins

USER 1000

# Install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Copy groovy init scripts
COPY init.groovy.d/*.groovy /usr/share/jenkins/ref/init.groovy.d/
