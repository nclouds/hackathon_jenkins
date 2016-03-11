#!/bin/bash


stack_id="832a66bf-d71c-47f1-a18f-7f7b54bba298"


FILE=deploy/hosts
OUTPUT=`aws opsworks describe-layers --region us-east-1 --stack-id $stack_id`

COUNT_LAYERS=`echo $OUTPUT | jq '.Layers[].Shortname' | wc -l`
COUNTER=0
FIRST_KEN='0'
FIRST_CELERY='0'

while [  $COUNTER -lt $COUNT_LAYERS ]; do
  LAYER_NAME=`echo $OUTPUT | jq --raw-output ".Layers[$COUNTER].Shortname"`
  LAYER_ID=`echo $OUTPUT | jq --raw-output ".Layers[$COUNTER].LayerId"`
  
  # ken and ken-main
  if [ "$LAYER_NAME" == "ken-web" ] && [ $FIRST_KEN == '0' ]
  then
    echo [ken-web-main]
    aws opsworks describe-instances --region us-east-1 --layer-id $LAYER_ID  | jq --raw-output '.Instances[0].PrivateIp'  | grep -v null
    FIRST_KEN=1
  fi
  if [ "$LAYER_NAME" == "ken-web" ]
  then
  echo [$LAYER_NAME]
  aws opsworks describe-instances --region us-east-1 --layer-id $LAYER_ID  | jq --raw-output '.Instances[].PrivateIp' | sed '1d'  | grep -v null
  let COUNTER=COUNTER+1
  continue
  fi
  
  # celery and celery-main
    if [ "$LAYER_NAME" == "celery" ] && [ $FIRST_CELERY == '0' ]
  then
    echo [celery-main]
    aws opsworks describe-instances --region us-east-1 --layer-id $LAYER_ID  | jq --raw-output '.Instances[0].PrivateIp'  | grep -v null
    FIRST_CELERY=1
  fi
  if [ "$LAYER_NAME" == "celery" ]
  then
  echo [$LAYER_NAME]
  aws opsworks describe-instances --region us-east-1 --layer-id $LAYER_ID  | jq --raw-output '.Instances[].PrivateIp' | sed '1d'  | grep -v null
  let COUNTER=COUNTER+1
  continue
  fi
  
  # default
  echo [$LAYER_NAME]
  aws opsworks describe-instances --region us-east-1 --layer-id $LAYER_ID  | jq --raw-output '.Instances[].PrivateIp' | grep -v null
  let COUNTER=COUNTER+1
done > $FILE

cat deploy/hosts
ansible-playbook -v -i deploy/hosts deploy/${env}.yml --extra-vars "deploy_version=${deploy_branch} current_build=`date +%s`" --vault-password-file /var/lib/jenkins/ken/${env}-vault-password.txt
