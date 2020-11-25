FROM jenkins/jenkins:2.249.3-lts-alpine 
COPY --from=hashicorp/terraform:0.13.5 /bin/terraform /bin/
ENV JENKINS_USER admin
ENV JENKINS_PASS admin

# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

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
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt