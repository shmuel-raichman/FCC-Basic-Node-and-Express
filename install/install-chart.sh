#!/bin/bash
# B"H


E_DB=99    # Error code for missing entry.

IMAGE_TAG=$1
REGISTRY="${2:-smuel770}"

# Map of app spesific values.
declare -A values
values[REPOSITORY_NAME]="$REGISTRY\/fcc-basic-node-and-express"
values[TAG]=$IMAGE_TAG
values[INGRESS_ENABLED]=ture
values[INGRESS_HOST_NAME]=fcc-basic-node-and-express
values[SERVICE_TYPE]=ClusterIP

CHART_NAME=fcc-basic-node-and-express
CHART_NMAESPACE=dev

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

cd ../myapps
cp values.yaml tmp-values.yaml
for value in ${!values[@]}
do
    fetch_value $value
    # sed -i -e "s/$value/${values[$value]}/g" tmp-values.yaml
    sed -i -e "s/$value/$(fetch_value $value)/g" tmp-values.yaml
done
#

if ! kubectl get ns $CHART_NMAESPACE &> /dev/null ; then
    helm install $CHART_NAME ./ --namespace=$CHART_NMAESPACE --values=tmp-values.yaml --create-namespace
    echo "Chart deployed in new namespace"
elif helm status --namespace=$CHART_NMAESPACE $CHART_NAME &> /dev/null; then
    helm upgrade $CHART_NAME ./ --namespace=$CHART_NMAESPACE --values=tmp-values.yaml 
     echo "Chart was upgraded"
else
    helm install $CHART_NAME ./ --namespace=$CHART_NMAESPACE --values=tmp-values.yaml
    echo "Chart deployed"
fi

# if [ "$BUILD_OR_UPGRADE" == "install" ]; then
#     helm install $CHART_NAME ./ --namespace=$CHART_NMAESPACE --values=tmp-values.yaml --create-namespace
# else
#     helm upgrade $CHART_NAME ./ --namespace=$CHART_NMAESPACE --values=tmp-values.yaml 
# fi

rm -f tmp-values.yaml

exit $?   # In this case, exit code = 99, since that is function return.