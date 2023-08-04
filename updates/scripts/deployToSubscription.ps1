
<#
	.SYNOPSIS
        1. Assign the SubscriptionxxxDeploy.json to the subscription
		2. Only Used for test purpose



	.DESCRIPTION

         
 
	.EXAMPLE
	   .\deployToSubscription.ps1
	   
	.LINK

	.Notes
		NAME:      deployToSUbscription.ps1
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  01-6-2023
		KEYWORDS:  policy management Management
#>

[cmdletbinding()] 
Param (


    #parameter for the output json file
    [Parameter(Mandatory = $false)]
    [string]$outputJsonFileSub = "BIO-azuredeploy-subscription.json",

	#parameter for deploymentname
	[Parameter(Mandatory = $false)]
	[string]$deploymentName = "BIO-deploy",

	#parameter for location
	[Parameter(Mandatory = $false)]
	[string]$location = "westeurope"

 

)
$root = $PSScriptRoot
$resultFolder = "$root\..\results\"
$payload = "$resultFolder\$outputJsonFileSub"

# validate if file $payload exist else message and exit
if (!(Test-Path $payload)) {
    Write-Host "File $payload does not exist" -ForegroundColor Red
    exit
}


az deployment sub  create --template-file  $payload --location $location  --name $deploymentName 
