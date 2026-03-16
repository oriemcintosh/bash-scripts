#!/bin/bash
# Create an Azure App Service Plan
# Accept user input for resource group name, plan name, and SKU
read -p "Enter the resource group name: " resourceGroupName
read -p "Enter the App Service Plan name: " appServicePlanName 
read -p "Enter the SKU (e.g., B1, P1V3): " sku

# Create the App Service Plan
az appservice plan create -g $resourceGroupName -n $appServicePlanName --is-linux --sku $sku | jq