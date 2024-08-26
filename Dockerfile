# Use an official Ubuntu base image
FROM ubuntu:22.04

# Install OpenJDK
RUN apt-get update && \
    apt-get install -y openjdk-17-jre wget && \
    apt-get clean

# Install Apache Tomcat
RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.24/bin/apache-tomcat-8.5.24.tar.gz
RUN tar -xzvf apache-tomcat-8.5.24.tar.gz 
RUN mv apache-tomcat-8.5.24 /opt/tomcat

# Configure Tomcat (customize as needed)
COPY tomcat-users.xml /opt/tomcat/apache-tomcat-8.5.24/conf/tomcat-users.xml
COPY context.xml /opt/tomcat/apache-tomcat-8.5.24/webapps/manager/META-INF/context.xml
RUN sed -i "s/8080/8082/g" /opt/tomcat/apache-tomcat-8.5.24/conf/server.xml

# Expose the port Tomcat is running on
EXPOSE 8082

COPY addressbook/addressbook_main/target/addressbook.war /opt/tomcat/apache-tomcat-8.5.24/webapps/

# Set the Tomcat directory as an environment variable
ENV CATALINA_HOME /opt/tomcat

# Start Tomcat
CMD ["sh", "-c", "$CATALINA_HOME/bin/catalina.sh run"]
