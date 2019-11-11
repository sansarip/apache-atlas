FROM openjdk:8
LABEL maintainer="Sepehr Ansaripour <sansaripour@ata-llc.com>"

ARG VERSION=2.0.0

ENV ATLAS_INSTALL=/opt/install/apache-atlas-${VERSION}
ENV ATLAS_CONF_INSTALL=${ATLAS_INSTALL}/conf
ENV ATLAS_BIN_INSTALL=${ATLAS_INSTALL}/bin
ENV ATLAS_HOME=/opt/apache-atlas-${VERSION}
ENV ATLAS_CONF=/opt/apache-atlas-${VERSION}/conf
ENV ATLAS_BIN=/opt/apache-atlas-${VERSION}/bin
ENV MANAGE_LOCAL_SOLR=true
ENV MANAGE_LOCAL_HBASE=true

# Install python
RUN apt-get install -y python2.7

# Create atlas user
RUN groupadd -r -g 47144 atlas && useradd -r -u 47145 -g atlas atlas

# Add install files
ADD --chown=atlas:atlas target/apache-atlas-${VERSION}-server.tar.gz /opt/install

# Edit conf
USER atlas
RUN echo "atlas.ui.editable.entity.types=*" >> $ATLAS_CONF_INSTALL/atlas-application.properties
RUN cd $ATLAS_BIN_INSTALL && \
  ATLAS_HOME=${ATLAS_INSTALL} \
  ATLAS_CONF=${ATLAS_CONF_INSTALL} \
  ATLAS_BIN=${ATLAS_BIN_INSTALL} \
  python2.7 atlas_start.py -setup || true

# Start script
USER root
COPY --chown=atlas:atlas atlas_start.sh /opt/
COPY --chown=atlas:atlas atlas_configure.sh /opt/
COPY --chown=atlas:atlas atlas_configure.py /opt/
COPY --chown=atlas:atlas hbase-site.xml /opt/
RUN chmod u=wrx,g=wrx /opt/atlas_start.sh && \
    chmod u=wrx,g=wrx /opt/atlas_configure.sh && \
    chmod u=wrx,g=wrx /opt/atlas_configure.py
RUN mkdir ${ATLAS_HOME}

# Permissions
RUN chown atlas:atlas ${ATLAS_HOME} && chown atlas:atlas /opt/install

USER atlas

EXPOSE 21000

WORKDIR ${ATLAS_HOME}

CMD ["/opt/atlas_start.sh"] 
