# jsonToCosmos

### Prerequisites
- `PowerShell` should be installed (v7.3.2 or more recent is fine)
- `Azure CosmosDB Account` You should have an Azure CosmosDB Account.
- `Collection` You should have a CosmosDB collection.


## Understanding chpod

The jsonToCosmos has a simple logic. You should give it a CosmosDB account name with your primary key, an existing collection with its database and a path to the file with the new collection to add. 

The script will load the collections defined in the json file to the desired database in the CosmosDB account of your choice and skip the collections that already exist in the database.

### Usage
```pwsh
    jsonToCosmos -Name 'myCosmosDBAccount' \
                 -Key 'xxxxyyyyzzzz' \
                 -Collection 'mycollection' \
                 -Database 'mydatabase' \
                 -File '/Path/to/Json/file'
```
