# jsonToCosmos

### Prerequisites
- `PowerShell` should be installed (5.x or 6.x or more recent is fine).
- `Az module` Az.Profile and Az.Resources PowerShell modules are required.
- `CosmosDB account` You should have an Azure CosmosDB Account and be able to get its primary/secondary key.


## Understanding jsonToCosmos

The jsonToCosmos has a simple logic. You should give it a CosmosDB account name with its primary key, an existing collection with its database, and optionally a path to the file with the new collection to be added and its partition key. If these last two parameters are not defined, the script will return the existing data in the collection.

The collection should be similar to:
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

The script will load the collections defined in the json file to the desired database in the CosmosDB account of your choice and skip the collections that already exist in the database.

### Usage
```pwsh

    # Show existing collection in CosmosDB
    jsonToCosmos -Name 'myCosmosDBAccount' `
                 -Key 'xxxxyyyyzzzz' `
                 -Collection 'mycollection' `
                 -Database 'mydatabase'  
                   
                   
    # Upload JSON collection to CosmosDB
    jsonToCosmos -Name 'myCosmosDBAccount' `
                 -Key 'xxxxyyyyzzzz' `
                 -Collection 'mycollection' `
                 -Database 'mydatabase' `
                 -File '/Path/to/Json/file' `
                 -PartitionKey 'xyz'
```
