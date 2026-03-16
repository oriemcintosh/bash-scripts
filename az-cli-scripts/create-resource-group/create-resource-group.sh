# Shell script to create a resource group in Azure
# Accept user input for resource group name and location
echo "Enter the name of the resource group:"
read rgName
echo "Enter the location for the resource group (e.g., eastus):"
read location

# Create the resource group
az group create -n $rgName -l $location | jq 