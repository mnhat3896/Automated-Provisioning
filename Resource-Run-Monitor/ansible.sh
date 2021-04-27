#!/bin/sh

#NOTE: CHANGE THIS TO YOUR STRONG PASSWORD (you can pass this agrument from main.sh)
ELASTIC_PASSWORD="guestXXX123"

# Create inventory for ansible (JUST BASIC FOR TESTING, CAN USE AZURE DYNAMIC INVENTORY INSTEAD)
os_username=$(az vm show -n vm-monitoring -g rg_monitoring --query "osProfile.adminUsername")

ssh_pem=$(az keyvault secret show --name kv-secret-ssh-monitoring --vault-name kvMonitoring --query "value")

echo -e $ssh_pem | sed 's/"//g' > ./Ansible/ssh.pem
sudo chmod 400 ./Ansible/ssh.pem

public_ip=$(az vm list-ip-addresses -g rg_monitoring -n vm-monitoring --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" -o tsv)

echo -e "[monitoring] \n$public_ip ansible_connection=ssh ansible_user=$os_username ansible_ssh_private_key_file=ssh.pem" > ./Ansible/inventory.ini


cd Ansible

try=0
while [ $try -le 10 ]
do
  export ANSIBLE_HOST_KEY_CHECKING=False
  ansible all -i inventory.ini -m ping
  if [ $? -eq 0 ]; then
    ansible-playbook main.yml  -i inventory.ini --extra-vars "ELASTIC_PASSWORD=$ELASTIC_PASSWORD ELASTICSEARCH_PASSWORD=$ELASTIC_PASSWORD"
    rm --force ssh.pem
    break
  else
    echo "cannot ping the vm, trying again..."
    sleep 1
  fi
  try=$(( $try + 1 ))
done
