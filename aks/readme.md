# AKS

Deploys an AKS instance into an Azure subscription.

Terraform state is kept in Azure Storage. Use the `tfinit.sh` script to initialise the Terraform configuration.

This script will create a random ID which is used as a suffix for the name of the resource group and AKS instance.

The client ID, client secret and SSH keys to be used during the AKS deployment are stored in an Azure KeyVault instance.

The script shows how a standard naming convention can be utilised whilst creating resources. The naming standard looks like this

    environment-resourceType-azureRegion-resourceName-randomSuffix

Environment is a single character representing development, test, production or a "temp" environment (I use temp personally for things I'm experimenting with and know I can safely trash if needed!)

For example, a resource group for an AKS cluster being used for a production environment in the Azure West Europe region might be

    p-rg-euw-aks-1234

The default values for the script will use the "temp" environment, the West Europe Azure region and the name "aks".

A resource group is created and a simple AKS cluster with 3 nodes is deployed. 

### Inputs

The environment variables below are required to be set before the script is run.

| **Variable** | **Example Value** | **Description** |
| ------------ | ----------------- | --------------- |
| **TF_VAR_subscriptionId** | `00000000-0000-0000-0000-000000000000` | ID of the Azure subscription where you will deploy the AKS instance |
| **TF_VAR_clientId** | `00000000-0000-0000-0000-000000000000` | Client ID used by the AzureRM provider to sign-in to your Azure subscription |
| **TF_VAR_clientSecret** | `<client secret>` | Secret / password for the Client ID above |
| **TF_VAR_tenantId** | `00000000-0000-0000-0000-000000000000` | ID of the Azure AD tenant where the above Client ID is kept |
| **TF_VAR_accessKey** | `<access key>`  | Access key for the Azure Storage account used to hold Terraform state |
| **TF_VAR_aks-keyvault-name** | `myKeyVault` | Name of the Azure KeyVault instance where the client ID and client secret for the AKS deployment are stored |
| **TF_VAR_aks-sp-clientId** | `aks-client-id` | Name of the Azure KeyVault secret that holds the client ID to be used for the AKS deployment |
| **TF_VAR_aks-sp-clientSecret** | `aks-client-secret` | Name of the Azure KeyVault secret that holds the client secret to be used for the AKS deployment |
| **TF_VAR_ssh-keyvault-name** | `myKeyVault` | Name of the Azure KeyVault instance where the SSH key for the AKS deployment is stored |
| **TF_VAR_ssh-secret-name** | `sshkey` | Name of the Azure KeyVault secret that holds the SSH key to be used for the AKS deployment |
