# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jre-slim

# Set environment variables for Tomcat
ENV TOMCAT_VERSION=8.5.24
ENV TOMCAT_TAR=apache-tomcat-${TOMCAT_VERSION}.tar.gz
ENV TOMCAT_URL=https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.24/bin/${TOMCAT_TAR}

# Install required packages
RUN apt-get update && \
    apt-get install -y wget && \
    wget ${TOMCAT_URL} && \
    tar -xzvf ${TOMCAT_TAR} && \
    mv apache-tomcat-${TOMCAT_VERSION} /usr/local/tomcat && \
    rm ${TOMCAT_TAR}

# Copy configuration files
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml

# Copy the application WAR file
COPY addressbook/addressbook_main/target/addressbook.war /usr/local/tomcat/webapps/

# Expose the port Tomcat runs on
EXPOSE 8082

# Start Tomcat
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
