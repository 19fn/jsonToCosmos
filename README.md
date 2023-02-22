# jsonToCosmos

### Prerequisites
- `PowerShell` should be installed (5.x or 6.x or more recent is fine).
- `Az module` Az.Profile and Az.Resources PowerShell modules are required.
- `CosmosDB account` You should have an Azure CosmosDB Account and be able to get its primary/secondary key.


## Understanding jsonToCosmos

The jsonToCosmos has a simple logic. You should give it a CosmosDB account name with its primary key, an existing collection with its database, and optionally a path to the file with the new document/s to be added and its partition key. If these last two parameters are not defined, the script will return the existing document/s in the collection.

The document/s should be similar to:
```json
[
	{
		"id": "XYZ",
		"Code": "XXYY",
		"isRed": true,
		"isBlue": false
	}
]
```

The script will load the documents defined in the json file to the desired collection in the CosmosDB account of your choice and skip the ones that already exist in the database.

## Usage
### Show existing documents in a collection
```pwsh
    jsonToCosmos.ps1 -Name 'CosmosDBAccount' `
                 -Key 'xxxxyyyyzzzz' `
                 -Collection 'collection' `
                 -Database 'database'                
```
### Upload documents to a collection
```pwsh
    jsonToCosmos.ps1 -Name 'CosmosDBAccount' `
                 -Key 'xxxxyyyyzzzz' `
                 -Collection 'collection' `
                 -Database 'database' `
                 -File '/Path/to/Json/file' `
                 -PartitionKey 'xyz'		 
```
