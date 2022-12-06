#!/bin/bash
read -p "Name (default: 'demo-ol-cics'):" name
name=${name:-demo-ol-cics}
echo "Name: $name"

echo "Delete the Tanzu Application Platform Workload"
tanzu app wld delete $name

echo "Delete the OpenLegacy Hub Project and Module"
ol delete project $name
ol delete module $name

echo "Cleanup Check"
ol list projects
ol list modules
tanzu app wld list

