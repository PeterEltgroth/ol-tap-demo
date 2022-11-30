#!/bin/bash
read -p "Name (default: 'demo-ol-cics'):" name
name=${name:-demo-ol-cics}
echo "Name: $name"

echo "Create a module"
ol create module --connector mf-cics-cobol $name
cd $name

echo "Test connection to mainframe"
ol test connection --base-url http://mainframe.openlegacy.com --port 12345 --uri-map /ol/demos

echo "Add Assets to the module and test them"
echo "Add an Asset via a cobol source"
ol add --source-path ../resources/OACTCS9.cbl --program-path OACTCS9
cp ../resources/test-json/oactcs9.json
ol test asset oactcs9

echo "Add Assets via a cobol copy books"
ol add -i ../resources/GACTCS9I.cpy -o ../resources/GACTCS9O.cpy --program-path GACTCS9
cp ../resources/test-json/gactcs9.json
ol test asset gactcs9

ol add -i ../resources/LACTCS9I.cpy -o ../resources/LACTCS9O.cpy --program-path LACTCS9
# List does not require a change to the input
ol test asset lactcs9

echo "Push the Module to OpenLegacy Hub"
ol push module

echo "Create a Project with the Module"
ol create project $name --modules $name