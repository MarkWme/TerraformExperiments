#!/bin/bash 

terraform init \
    -backend=true \
    -backend-config="storage_account_name=psaeuwshared" \
    -backend-config="container_name=terraform-state" \
    -backend-config="access_key=${TF_VAR_accessKey}" \
    -backend-config="key=test.mtjw.azure.tfstate"