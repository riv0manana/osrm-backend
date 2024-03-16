FROM osrm/osrm-backend:latest
ENV OSRM_PBF_URL=http://download.geofabrik.de/africa/madagascar-latest.osm.pbf
ENV OSRM_GRAPH_PROFILE=bicycle
ENV OSRM_DATA_LABEL=madagascar-latest
RUN sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list
RUN sed -i s/security.debian.org/archive.debian.org/g /etc/apt/sources.list
RUN apt update && apt install -y wget
EXPOSE 5000
COPY ./docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN ls
RUN chmod +x /opt/docker-entrypoint.sh
ENTRYPOINT ["/opt/docker-entrypoint.sh"]
