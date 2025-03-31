FROM tomcat:9.0-jdk17

# Preparation
RUN apt-get update && \
    mkdir -p /opt/magnolia && \
    chmod 775 /opt/magnolia

COPY your-project-webapp/build-support/setenv.sh $CATALINA_HOME/bin/

# Copy WAR from local path
COPY your-project-webapp/target/magnolia-webapp.war $CATALINA_HOME/webapps/ROOT.war

# Environment Settings
ENV JVM_XMS=1g
ENV JVM_XMX=4g
ENV MGNL_REPOSITORIES_HOME=/opt/magnolia/repositories
ENV MGNL_RESOURCES_DIR=/opt/magnolia/resources
ENV MGNL_BOOTSTRAP_DIR=/opt/magnolia/bootstrap/common
ENV MGNL_REPOSITORIES_JACKRABBIT_CONFIG=WEB-INF/config/repo-conf/jackrabbit-bundle-h2-search.xml
ENV MGNL_DB=h2
ENV MGNL_BOOTSTRAP_AUTHOR_INSTANCE=false
ENV MGNL_UPDATE_AUTO=true
ENV MGNL_DEVELOP=true
ENV MGNL_PERISCOPE_RESULT_RANKING=false
ENV MGNL_UI_STICKER_ENVIRONMENT=PUBLIC
ENV MGNL_UI_STICKER_COLOR=#9A3332
ENV MGNL_UI_STICKER_COLOR_BACKGROUND=#FFFFFF
ENV MGNL_WEBAPP="Public"
ENV MGNL_INJECT_CONFIG=NA

CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]