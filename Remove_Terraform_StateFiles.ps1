$CurrentDirectory = Get-Location
Write-Host "Our current Working Directory is $CurrentDirectory"

If ($ValidatePath -eq $True) {
    Get-ChildItem -Path $CurrentDirectory -Include *.tfstate*,*.tfplan,*.lock.* -File -Recurse | foreach { echo "Deleting: $_" ; $_.Delete()}
}
Else {
     Write-Host "Couldnt find any Terraform State & Plan files"
}

