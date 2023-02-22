<#
.SYNOPSIS
    Powershell script to upload .json collection to cosmos db account
.DESCRIPTION
    The script work with a collection defined in json, to upload each item to the database in CosmosDB 
.EXAMPLE
    jsonToCosmos -Name 'CosmosDB name' `
                      -Key 'CosmosDB Primary/Secondary key' `
                      -Collection 'Collection/Container name' `
                      -Database 'Database name' `
                      -File 'Path to json file' `
                      -PartitionKey 'key'
.NOTES
    Author: Federico N Cabrera
    Date:   February 8, 2023    
#>

param (
    [Parameter(Mandatory=$True)]
    [string]$Name,
    [Parameter(Mandatory=$True)] 
    [string]$Key,
    [Parameter(Mandatory=$True)]
    [string]$Collection,
    [Parameter(Mandatory=$True)]
    [string]$Database,
    [Parameter(Mandatory=$False)]
    [string]$File,
    [Parameter(Mandatory=$False)]
    [string]$PartitionKey
)

# Install module
if  (-Not (Get-Module -ListAvailable -Name CosmosDB)){
    Install-Module -Name CosmosDB
}

# Target collection
$collectionName = $Collection

try {
    # Connection to Azure CosmosDB Account
    $primaryKey = ConvertTo-SecureString -String $Key -AsPlainText -Force
    $cosmosDbContext = New-CosmosDbContext -Account $Name -Database $Database -Key $primaryKey  

    $documents = (Get-CosmosDbDocument -Context $cosmosDbContext `
                                       -CollectionId $collectionName)   
}
catch {
    $_
    exit
}

if ($File -and $PartitionKey){
    # Path to json file
    $json = Get-Content $File | Out-String | ConvertFrom-Json

    Write-Output ""
    foreach($item in $json){
        $document = $item | ConvertTo-Json | Out-String
        $id = $item.id
        if ($item.$PartitionKey){
            $pk = $item.$PartitionKey
        }
        else{
            Write-Output "`n[!] Error: invalid PartitionKey.`n"
            exit
        }
        if ($documents.id -eq $id){
            Write-Output "[!] Warning: id '$id' already exist."
        }
        else{
            New-CosmosDbDocument -Context $cosmosDbContext `
                                 -CollectionId $collectionName `
                                 -DocumentBody $document `
                                 -PartitionKey $pk
        }
    }
    Write-Output ""
}
else{
    $documents
}

