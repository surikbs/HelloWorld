FROM openjdk:8-jdk-alpine
RUN addgroup -S vcs_devops && adduser -S vcs_devops -G vcs_devops
USER vcs_devops:vcs_devops
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} HelloWorld-1.0-1.jar
ENTRYPOINT ["java","-jar","/HelloWorld-1.0-1.jar"]