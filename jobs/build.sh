#!/bin/bash


stack_id="832a66bf-d71c-47f1-a18f-7f7b54bba298"

FILE=deploy/hosts
OUTPUT=`aws opsworks describe-layers --region us-east-1 --stack-id $stack_id`

COUNT_LAYERS=`echo $OUTPUT | jq '.Layers[].Shortname' | wc -l`
COUNTER=0
FIRST_KEN='0'

while [  $COUNTER -lt $COUNT_LAYERS ]; do
  LAYER_NAME=`echo $OUTPUT | jq --raw-output ".Layers[$COUNTER].Shortname"`
  LAYER_ID=`echo $OUTPUT | jq --raw-output ".Layers[$COUNTER].LayerId"`
  if [ "$LAYER_NAME" == "rss" ] && [ $FIRST_KEN == '0' ]
  then
    echo [rssmain]
    aws opsworks describe-instances --region us-east-1 --layer-id $LAYER_ID  | jq --raw-output '.Instances[0].PrivateIp'  | grep -v null
    FIRST_KEN=1
  fi
  if [ "$LAYER_NAME" == "rss" ]
  then
  echo [$LAYER_NAME]
  aws opsworks describe-instances --region us-east-1 --layer-id $LAYER_ID  | jq --raw-output '.Instances[].PrivateIp' | sed '1d'  | grep -v null
  let COUNTER=COUNTER+1
  continue
  fi
  echo [$LAYER_NAME]
  aws opsworks describe-instances --region us-east-1 --layer-id $LAYER_ID  | jq --raw-output '.Instances[].PrivateIp' | grep -v null
  let COUNTER=COUNTER+1
done > $FILE
