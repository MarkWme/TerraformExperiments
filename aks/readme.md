# AKS

Deploys an AKS instance into an Azure subscription.

### Inputs

As environment variables

| **Variable** | **Example Value** | **Description** |
| ------------ | ----------------- | --------------- |
| **TF_VAR_subscriptionId** | `00000000-0000-0000-0000-000000000000` | ID of the Azure subscription where you will deploy the AKS instance |
| **TF_VAR_clientId** | `00000000-0000-0000-0000-000000000000` | Client ID used by the AzureRM provider to sign-in to your Azure subscription |
| **TF_VAR_clientSecret** | `<client secret>` | Secret / password for the Client ID above |
| **TF_VAR_tenantId** | `00000000-0000-0000-0000-000000000000` | ID of the Azure AD tenant where the above Client ID is kept |
| **TF_VAR_accessKey** | `<access key>`  | Access key for the Azure Storage account used to hold Terraform state |
| **TF_VAR_aks-keyvault-name** | `myKeyVault` | Name of the Azure KeyVault instance where the client ID and client secret for the AKS deployment are stored |
| TF_VAR_aks-sp-clientId=aks-sp-client-id
| TF_VAR_aks-sp-clientSecret=aks-sp-client-secret
| TF_VAR_ssh-keyvault-name=p-kv-euw-keyvault
| TF_VAR_ssh-secret-name=MacBook-SSH-Public-Key
