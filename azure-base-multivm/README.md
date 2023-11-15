# Deploy Azure Resources with Terraform

This subfolder is a template used to deploy a default Azure Infrastructure using Terraform CLI ([Terraform](https://developer.hashicorp.com/terraform/downloads)). For the example, i run all of those commands using Windows/PowerShell.

By default, this template will deploy all of those services in your Azure Subscription :

- Resource Group
- Network Security Group (NSG for VNET)
- Virtual Network (Subnets for Servers & VPN Gateway)
- Azure Recovery Services Vault
- Azure Backup Policy
- Virtual Machine Network Interfaces (Static IP)
- Virtual Machines (+ Backup Policy assigned)
- Virtual Network Gateway (Basic by default with Dynamic Public IP)


## ⚡ Module Configuration

1. Generate the providers.tf and terraform.tfvars configuration files.

```ps
$CurrentDirectory = Get-Location
Get-ChildItem -Path $CurrentDirectory -Recurse -Include "*.example" | Rename-Item -NewName { $_.Name -replace ".example","" }
```

2. Replace all the variables in "providers.tf", "variables.tf" and "terraform.tfvars" files

  2a. providers.tf

  📍 _Replace variables with the pre-requisites information you got from the root folder intructions

    ```text
      subscription_id   = "00000000-0000-0000-0000-000000000000"
      tenant_id         = "00000000-0000-0000-0000-000000000000"
      client_id         = "00000000-0000-0000-0000-000000000000"
      client_secret     = "*************************************"
    ```
  2b. variables.tf

  📍 _Replace variables with the Windows VM you need to deploy (At the end of the file). You can add there multiple blocks to deploy multiple VMs

    ```text
    "vm1" = {
      vm_name = "FRAZWVM01"
      vm_size = "Standard_B2ms"
      vm_ip   = "10.162.16.6"
      vm_password = "yv!4KDhZ*%SQE!HdDm46"
    }
    ```

  2c. terraform.tfvars

    📍 _Replace variables to fit your needs

## 📜 Certificates

1. Configure your VPN Root Certificate

    📍 _Create your Root Certificate (You can change the CN Value to fit your needs)

    ```ps
    $cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
    -Subject "CN=VPNROOTCA" -KeyExportPolicy Exportable `
    -HashAlgorithm sha256 -KeyLength 2048 `
    -CertStoreLocation "Cert:\CurrentUser\My" -KeyUsageProperty Sign -KeyUsage CertSign -NotAfter (Get-Date).AddYears(20)
    ```

2. Export the root certificate (using .cer base64)

    📍 _Export the cert using certmgr.msc to a *.cer file (without private key)

Take the values between "-----BEGIN CERTIFICATE-----" and "-----END CERTIFICATE-----" 
Replace them in the "main.tf" file.

Exemple of the certificate file content :

-----BEGIN CERTIFICATE-----
MIIC4zCCAcugAwIBAgIQNxE55rUVb71NB/tUS57hszANBgkqhkiG9w0BAQsFADAU
MRIwEAYDVQQDDAlWUE5ST09UQ0EwHhcNMjMwODEwMDc1NDE1WhcNNDMwODEwMDgw
NDE0WjAUMRIwEAYDVQQDDAlWUE5ST09UQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDAQ3GMTN6Qw7mkG5nB+J8IS7zRzTny3EO4d6y9qboY72ModkdZ
RwnJejxZhKkExhItYriOO2OOXrodYnX9P2DWtG5CNCUdgduWC5nDXEwgXx9QeaH8
b+rk8VxXf/iIE5ASGYKDQb/qieU2apTRo6jjq/1l3Gh4NJWvnmLCgMU3wrpxNz9m
0yLZCXuQ10QylBE/Vx+7e4RZMJ/a7Aam6RIa5MbSoXu85xzeZBj42PKRKtQi1MB6
jv919Ddz/FYMBHLoVkugo0z6by9qYAnbIG8UaNYUUc36djNTmhM/kxTNVilLi/2F
6dYNTF3i3ltLFaxrPfCegbukWB0JUJDtRDe5AgMBAAGjMTAvMA4GA1UdDwEB/wQE
AwICBDAdBgNVHQ4EFgQUhzDVd5Av//unqJbv5Cg3hjVcbOUwDQYJKoZIhvcNAQEL
BQADggEBAGZKWpla7c7ZFcdhAu8X2zJzTXikdZkF1H5Zdddkivo+MgeDO85qmmfU
TKI62saGUE4gZTtcy6Fd4wFMyNIvwar1Lf6xAu5qpu5yGGNthX8QORKNjmbcRj+v
Rvl8xSVfo2LjM8vvjxGybWQqTmEPzmnq0AtvsfVXiWBVKouzvyb7VPUZMeeL5tBn
PSxrbRa86t20wDnxgtUP2/+d+56WeUtL86seEziPBFVXCQpsnH8qCj1p27/Crglh
xlTwAt8biP9mtxVCIm5Tct+kiRSIfpLm42QMtqsvEPex9I4VJ51/CmP7J7npADJr
gXQk/TEwX8eRYg4/RHJNN64LVZkYpms=
-----END CERTIFICATE-----

## :rocket: Deploy the resources

1. Initialize your terraform providers (this will download the required files in .terraform folder)

```ps
terraform init
```

2. Prepare ALL the changes that will be applied

```ps
terraform plan -out main.tfplan
```

That command will put all of the changes in a *.tfplan file and will show you the output of the needed changes

3. Apply ALL the changes to your infrastructure

```ps
terraform apply "main.tfplan"
```

## :x: Cleaning up Terraform State before running it against another tenant

    📍 Run the PowerShell Script in the current directory :

```ps
.\Remove_Terraform_StateFiles.ps1
```


## :bookmark_tabs: References

- https://www.cloudninja.nu/post/2022/06/github-terraform-azure-part1/
- https://rohanislam2.medium.com/learn-terraform-and-deploy-azure-resource-via-azure-devops-pipeline-9e340272fdb3
- https://github.com/saileshkaluva/myrepo/tree/598dcf8be196807804bfaac7566e29b92f223fb8/examples


