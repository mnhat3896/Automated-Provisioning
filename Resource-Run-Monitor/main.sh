#!/bin/sh

bash -e terraform.sh
#If the provisioning fail, stop the script
if [ $? -ne 0 ] ; then exit 1 ; fi

try=0
while [ $try -le 10 ]
do
  if [[ $(az vm show -n vm-monitoring -g rg_monitoring --query "provisioningState") == *"Succeeded"* ]]; then
    bash -e ansible.sh
    break
  else
    echo "Can not run ansible.sh because VM is not completely running, sleep 5s and try again..."
    sleep 5
  fi
  try=$(( $try + 1 ))
done
