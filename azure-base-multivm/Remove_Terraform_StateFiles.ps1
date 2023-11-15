$CurrentDirectory = Get-Location
Write-Host "Our current Working Directory is $CurrentDirectory"
Get-ChildItem -Path $CurrentDirectory -Include *.tfstate*,*.tfplan,*.lock.* -File -Recurse | foreach { echo "Deleting: $_" ; $_.Delete()}

