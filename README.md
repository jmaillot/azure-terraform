# Deploy Azure Resources using Terraform

This repository is a template used to deploy resource within your Azure Subscription

## 🚀 First Steps

The very first step will be to download this repository files onto a local folder, or just **clone the repository** and `cd` into it.

📍 _**All commands** are run on your **local** workstation within your repository directory_

## 🔧 Workstation Tools

Lets get the required workstation tools installed and configured.

1. Install the latest version of the ([Terraform CLI](https://developer.hashicorp.com/terraform/downloads)) and add an environment variable pointing to the terraform.exe PATH.

    📍 _See the task [installation docs](https://stackoverflow.com/questions/1618280/where-can-i-set-path-to-make-exe-on-windows) to add a variable to the PATH

2. Install the latest version of the ([Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)) and install it.

    📍 _See the task [installation docs](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

## 📄 Create a Service Principal to use with you terraform deployments

1. Open PowerShell
2. Login to your Azure Account 

    2a. Run az login without any parameters and follow the instructions to sign in to Azure.

      ```ps
      az login
      ```

      You will get a result like this :

      ```text
      A web browser has been opened at https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize. Please continue the login in the web browser. If no web browser is available or if the web browser fails to open, use device code flow with `az login --use-device-code`.
      [
        {
          "cloudName": "AzureCloud",
          "homeTenantId": "********-****-****-****-************",
          "id": "********-****-****-****-************",
          "isDefault": true,
          "managedByTenants": [],
          "name": "Subscription-Name",
          "state": "Enabled",
          "tenantId": "********-****-****-****-************",
          "user": {
            "name": "admin@domainname.fr",
            "type": "user"
          }
        }
      ]
      ```
    2b. Confirm the current Azure subscription, run az account show :

      ```ps
      az account show
      ```

    2c. To view all the Azure subscription names and IDs for your account :

      📍 _Replace the <microsoft_account_email> with your email address

      ```ps
      az account list --query "[?user.name=='<microsoft_account_email>'].{Name:name, ID:id, Default:isDefault}" --output Table
      ```

    2d. If you have multiple subscriptions, specify the Azure subscription you want to run Terraform against using az account set:

      ```ps
      az account set --subscription "<subscription_id_or_subscription_name>"
      ```

    2e. Finally, create the Service Principal

      📍 _Replace <id_of_the_subscription> with the id result from the "az account show" command 

      ```ps
      servicePrincipalName="msdocs-sp-$randomIdentifier"
      roleName="azureRoleName"
      az ad sp create-for-rbac --name $servicePrincipalName --role $roleName --scopes="/subscriptions/<id_of_the_subscription>"
      ```

      ```text

      This command will output 5 values:

      {
        "appId": "00000000-0000-0000-0000-000000000000",
        "displayName": "azure-cli-2017-06-05-10-41-15",
        "name": "http://azure-cli-2017-06-05-10-41-15",
        "password": "0000-0000-0000-0000-000000000000",
        "tenant": "00000000-0000-0000-0000-000000000000"
      }

      These values map to the Terraform variables like so:

      * appId is the client_id defined above.
      * password is the client_secret defined above.
      * tenant is the tenant_id defined above.

      ```

## 📝 Pre-requisites checklist

Before we get started with the resources deployment, make sure you have those requirements.

- [ ] You have an Azure Contributor Account
- [ ] You have the Service Principal AppId
- [ ] You have the Service Principal Password
- [ ] You have the Tenant id

> [!IMPORTANT]
> Those are required information for your deployment to succeed.

## :rocket: Basic Terraform commands you will need in the modules

1. Initialize your terraform providers (this will download the required files in .terraform folder)

```ps
terraform init
```

2. Prepare the changes that will be applied

```ps
terraform plan -out main.tfplan
```

That command will put all of the changes in a *.tfplan file and will show you the output of the needed changes

3. Apply the changes to your infrastructure

```ps
terraform apply "main.tfplan"
```

4. Destroy what you deployed

```ps
terraform apply main.tfplan -destroy
terrafrom destroy -target=<terraform-resource>
```