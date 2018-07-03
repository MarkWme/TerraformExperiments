# Backend

This provides the base scripts needed to deploy to Azure and use Azure Storage as a backend where Terraform state information is kept.

| File | Details |
| ------ | ------- |
|main.tf | Establish the azurerm provider, connect to the Azure subscription using a service principal, create a resource group as an example |
|variables.tf | Variables used by main.tf. These are passed in as environment variables (i.e. TF_VAR_subscriptionId) |
|tfinit.sh | Initialises Terraform passing in the configuration required for the backend. At this time, you cannot use interpolation in the backend section of main.tf, therefore this method passes in the configuration using environment variables, so that secrets aren't stored in the code |


