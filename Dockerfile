FROM jenkins/jenkins:lts

# Upgrade everything as root
USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y sudo && \
    rm -rf /var/lib/apt/lists/*

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins

RUN curl -sSL https://get.docker.com/ | sh

RUN sudo usermod -aG docker jenkins

# Install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Copy groovy init scripts
COPY init.groovy.d/*.groovy /usr/share/jenkins/ref/init.groovy.d/
