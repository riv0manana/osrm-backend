#!/bin/bash

# Defaults
OSRM_DATA_LABEL=${OSRM_DATA_LABEL:="madagascar-latest"}
OSRM_GRAPH_PROFILE=${OSRM_GRAPH_PROFILE:="bicycle"}
OSRM_PBF_URL=${OSRM_PBF_URL:="http://download.geofabrik.de/africa/madagascar-latest.osm.pbf"}
OSRM_MAX_TABLE_SIZE=${OSRM_MAX_TABLE_SIZE:="8000"}
OSRM_DATA_PATH=${OSRM_DATA_PATH:="/opt"}

_sig() {
  kill -TERM $child 2>/dev/null
}
trap _sig SIGKILL SIGTERM SIGHUP SIGINT EXIT


# Retrieve the PBF file
wget $OSRM_PBF_URL

# Set the graph profile path
OSRM_GRAPH_PROFILE_PATH="$OSRM_DATA_PATH/$OSRM_GRAPH_PROFILE.lua"


# Build the graph
osrm-extract $OSRM_DATA_PATH/$OSRM_DATA_LABEL.osm.pbf -p $OSRM_GRAPH_PROFILE_PATH
osrm-contract $OSRM_DATA_PATH/$OSRM_DATA_LABEL.osrm

# Start serving requests
osrm-routed $OSRM_DATA_PATH/$OSRM_DATA_LABEL.osrm --max-table-size $OSRM_MAX_TABLE_SIZE &
child=$!
wait "$child"
