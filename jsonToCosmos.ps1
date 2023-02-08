<#
.SYNOPSIS
    Powershell script to upload .json collection to cosmos db account
.DESCRIPTION
    The script work with a collection defined in json, to upload each item to the database in CosmosDB 
.EXAMPLE
    jsonToCosmos -Name 'CosmosDB name' \
                      -Key 'CosmosDB Primary/Secondary key' \
                      -Collection 'Collection/Container name' \
                      -Database 'Database name' \
                      -File 'Path to json file'
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
    [Parameter(Mandatory=$True)]
    [string]$File
)

# Target collection
$collectionName = $Collection

# Connection to Azure CosmosDB Account
$primaryKey = ConvertTo-SecureString -String $Key -AsPlainText -Force
$cosmosDbContext = New-CosmosDbContext -Account $Name -Database $Database -Key $primaryKey  

# Path to json file
$json = Get-Content $File | Out-String | ConvertFrom-Json

$documents = (Get-CosmosDbDocument -Context $cosmosDbContext -CollectionId $collectionName)

foreach($item in $json){
    $document = $item | ConvertTo-Json | Out-String
    $id = $item.id

    if ($documents.id -eq $id) 
    {
        Write-Output "`n[!] Document with id: [$id] already exist."
    }
    else 
    {
        New-CosmosDbDocument -Context $cosmosDbContext -CollectionId $collectionName -DocumentBody $document -PartitionKey $id
        Write-Output "`n[+] Document with id: [$id] created."
    }
}