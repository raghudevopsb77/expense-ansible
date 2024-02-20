ENV_NAME=$(echo $GO_STAGE_NAME | tr [:upper:] [:lower:] )
aws ssm put-parameter --name "${ENV_NAME}.expense.${component}.app_version" --type "String" --value "${app_version}" --overwrite
