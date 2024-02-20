ENV_NAME=$(echo $GO_STAGE_NAME | tr [:upper:] [:lower:] )
aws ssm put-parameter --name "${ENV_NAME}.expense.${component}.app_version" --type "String" --value "${app_version}" --overwrite

aws ec2 describe-instances --filter "Name=tag:Name,Values=${ENV_NAME}-expense-${component}" --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text >/tmp/hosts

ssh_user=$(aws ssm get-parameter --name ssh.username --with-decryption --query 'Parameter.Value' |xargs)
ssh_pass=$(aws ssm get-parameter --name ssh.password --with-decryption --query 'Parameter.Value' |xargs)

ansible-playbook -i /tmp/hosts -e ansible_user=${ssh_user} ansible_password=${ssh_pass} expense.yml -e service_name=${component} -e env=${ENV_NAME} -e app_version=${app_version}

