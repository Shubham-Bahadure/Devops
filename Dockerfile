# Use a base image with Java installed
FROM openjdk:17-jre-slim

# Set environment variables
ENV TOMCAT_VERSION=8.5.24
ENV TOMCAT_HOME=/opt/tomcat
ENV CATALINA_HOME=${TOMCAT_HOME}

# Install required packages
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install Tomcat
RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar -xzvf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt && \
    mv /opt/apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME} && \
    rm apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Copy Tomcat configuration files
COPY tomcat-users.xml ${TOMCAT_HOME}/conf/
COPY context.xml ${TOMCAT_HOME}/webapps/manager/META-INF/

# Copy the application WAR file
COPY addressbook/addressbook_main/target/addressbook.war ${TOMCAT_HOME}/webapps/

# Change ownership of the Tomcat files
RUN chown -R 1000:1000 ${TOMCAT_HOME}

# Expose the Tomcat port
EXPOSE 8082

# Start Tomcat
CMD ["sh", "-c", "${TOMCAT_HOME}/bin/catalina.sh run"]
