# Use a Tomcat base image
FROM tomcat:9.0.55

# Copy the WAR file into the webapps directory
COPY ./**/target/*.war /usr/local/tomcat/webapps/
