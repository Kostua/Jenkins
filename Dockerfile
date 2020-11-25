# Base LTS version of Jenkins 
FROM jenkins/jenkins:2.249.3-lts-alpine
# Fun way to get terraform ;)
COPY --from=hashicorp/terraform:0.13.5 /bin/terraform /bin/
# Set default login/password
ENV JENKINS_USER admin
ENV JENKINS_PASS admin

# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
# Install additional packages
USER root
RUN apk add docker
RUN apk add py-pip
RUN apk add python3-dev libffi-dev openssl-dev gcc libc-dev make
RUN pip install docker-compose
RUN pip install ansible
# COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/
USER jenkins
ADD jenkins.yaml /usr/share/jenkins/ref/
# Install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt