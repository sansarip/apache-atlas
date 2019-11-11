#!/bin/bash
trap 'kill -15 $(jobs -p) && python2.7 ${ATLAS_BIN}/atlas_stop.py && exit 0' EXIT INT SIGTERM
if [ ! -f $ATLAS_BIN/atlas_start.py ]; then
	echo "Copying from apache install to apache home..."
	cp -pr ${ATLAS_INSTALL}/* ${ATLAS_HOME}
	cp -pr ${ATLAS_HOME}/../hbase-site.xml ${ATLAS_HOME}/hbase/conf
fi
python2.7 ${ATLAS_BIN}/atlas_start.py
tail -f ${ATLAS_HOME}/logs/application.log & wait
