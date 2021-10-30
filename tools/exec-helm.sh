#!/bin/bash

dir=`dirname $0`
if [ $# -lt 2 ]; then
    echo "Usage: $0 YamlFile Tag"
    echo "for example, $0 yaml/values.yaml latest"
    exit -1
fi

VALUES=$1
TAG=$2

#-------------------------------------------------------------------------------------------

if [ ! -f $VALUES ] && [ ! -d $BIN ] ; then
    echo "yaml file($VALUES) not exists, exit."
    exit -1
fi

if [ -z $TAG ]; then
    echo "TAG must not be empty, exit"
    exit -1
fi

APP=`yq read $VALUES app`
SERVER=`yq read $VALUES server`
IMAGE=`yq read $VALUES repo.image`

IMAGE="$IMAGE:$TAG"

K8SSERVER="$APP-$SERVER"

DATE=`date +"%Y%m%d%H%M%S"`

REPO_ID="${DATE}-${TAG}"

echo "---------------------Environment---------------------------------"
echo "VALUES:               "$VALUES
echo "DATE:                 "$DATE
echo "TAG:                  "$TAG
echo "APP:                  "$APP
echo "SERVER:               "$SERVER
echo "REPO_ID:              "$REPO_ID
echo "IMAGE:                "$IMAGE
echo "----------------------Build docker--------------------------------"

#-------------------------------------------------------------------------------------------
function build_helm() 
{
    echo "--------------------build helm------------------------"

    cp $dir/Chart.yaml.orig $dir/helm-template/Chart.yaml
    cp -f ${VALUES} $dir/helm-template/values.yaml

    # 修改charts里面的参数
    yq write -i $dir/helm-template/Chart.yaml name $K8SSERVER

    # 更新values
    yq write -i $dir/helm-template/values.yaml repo.id $REPO_ID
    yq write -i $dir/helm-template/values.yaml repo.image $IMAGE

    # helm dependency update $dir/helm-template

    helm package $dir/helm-template
    
    echo "---------------------helm chart--------------------------"
    cat $dir/helm-template/Chart.yaml
}

build_helm 

echo "----------------finish $K8SSERVER---------------------"

