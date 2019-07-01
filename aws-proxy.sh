#!/bin/bash

set -eu

if [ $# -lt 2 ] ; then
    echo "Usage: $0 [--profile profile] [--region region] [--key key] [--filter filterkey] user host [port]"
    exit
fi

while true; do
  case $1 in
    --profile)
      PROFILE="--profile $2"
      shift 2
      ;;
    --region)
      REGION="--region $2"
      shift 2
      ;;
    --key)
      KEY=$2
      shift 2
      ;;
    --filter)
      FILTER=$2
      shift 2
      ;;
    *)
      break
      ;;
  esac
done

FILTER="${FILTER:-private-ip-address}"
ARGS="--ssh-public-key file://$KEY.pub --instance-os-user $1"
PORT="${3:-22}"
LOGIN=$1
DESTHOST=$2
read -r instance_id availability_zone <<< $(aws ec2 describe-instances $PROFILE $REGION --filter "Name=$FILTER,Values=$DESTHOST" --query 'Reservations[*].Instances[*].[InstanceId,Placement.AvailabilityZone]' --output text)

aws ec2-instance-connect send-ssh-public-key $REGION $PROFILE --instance-id $instance_id --availability-zone $availability_zone $ARGS

nc $DESTHOST $PORT
