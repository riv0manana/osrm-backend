#!/bin/bash
set -e

OSRM_DATA_LABEL=${OSRM_DATA_LABEL:-"madagascar-latest"}
OSRM_GRAPH_PROFILE=${OSRM_GRAPH_PROFILE:-"bicycle"}
OSRM_PBF_URL=${OSRM_PBF_URL:-"http://download.geofabrik.de/africa/madagascar-latest.osm.pbf"}
OSRM_MAX_TABLE_SIZE=${OSRM_MAX_TABLE_SIZE:-"8000"}
OSRM_DATA_PATH=${OSRM_DATA_PATH:-"/data"}

mkdir -p $OSRM_DATA_PATH
cd $OSRM_DATA_PATH

echo "Downloading PBF..."
wget -O ${OSRM_DATA_LABEL}.osm.pbf $OSRM_PBF_URL

echo "Extracting..."
osrm-extract ${OSRM_DATA_LABEL}.osm.pbf -p /opt/${OSRM_GRAPH_PROFILE}.lua

echo "Contracting..."
osrm-contract ${OSRM_DATA_LABEL}.osrm

echo "Starting OSRM..."
exec osrm-routed ${OSRM_DATA_LABEL}.osrm --max-table-size $OSRM_MAX_TABLE_SIZE
