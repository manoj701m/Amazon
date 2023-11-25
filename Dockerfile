# Use a Tomcat base image
FROM tomcat:8.5

# Copy the WAR file into the webapps directory
COPY ./**/target/*.war /usr/local/tomcat/webapps/
