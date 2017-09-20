FROM jenkins/jenkins:lts

# Upgrade everything as root
USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y sudo && \
    rm -rf /var/lib/apt/lists/*

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

# # To enable keycloak, add the json in the variable below
# #ENV KEYCLOAK_JSON=''

USER jenkins

RUN curl -sSL https://get.docker.com/ | sh

RUN sudo usermod -aG docker jenkins

# Install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Set default number of exexcutors
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

# If KEYCLOAK_JSON is true, configure keycloak
COPY configure_keycloak.groovy /usr/share/jenkins/ref/init.groovy.d/configure_keycloak.groovy

# Get rid of upgrade wizard
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
