#!/bin/bash
# B"H


E_DB=99    # Error code for missing entry.

IMAGE_TAG=$1
BUILD_OR_UPGRADE=$2

# Map of app spesific values.
declare -A values
values[REPOSITORY_NAME]="smuel770\/fcc-basic-node-and-express"
values[TAG]=$IMAGE_TAG
values[INGRESS_ENABLED]=ture
values[INGRESS_HOST_NAME]=fcc-basic-node-and-express
values[SERVICE_TYPE]=ClusterIP


fetch_value()
{
  if [[ -z "${values[$1]}" ]]
  then
    echo "$1's value is not in database."
    return $E_DB
  fi

  echo "${values[$1]}"
  return $?
}

echo $values
CHART_NAME=myapp-nodejs
CHART_NMAESPACE=apps-dev

cd ../myapps
cp values.yaml tmp-values.yaml
for value in ${!values[@]}
do
    fetch_value $value
    # sed -i -e "s/$value/${values[$value]}/g" tmp-values.yaml
    sed -i -e "s/$value/$(fetch_value $value)/g" tmp-values.yaml
done
#

if [ "$BUILD_OR_UPGRADE" == "install" ]; then
    helm install $CHART_NAME ./ --namespace=$CHART_NMAESPACE --values=tmp-values.yaml
else
    helm upgrade $CHART_NAME ./ --namespace=$CHART_NMAESPACE --values=tmp-values.yaml
fi

rm -f tmp-values.yaml

exit $?   # In this case, exit code = 99, since that is function return.