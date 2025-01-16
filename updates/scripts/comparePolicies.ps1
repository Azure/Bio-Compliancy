
<#
	.SYNOPSIS
        1. Compare the BIO Policy with the Microsoft security baseline


	.DESCRIPTION
    
        Compare the BIO Policy with the Microsoft security baseline         
 
	.EXAMPLE
	   .\comparePolicies.ps1
	   
	.LINK

	.Notes
		NAME:      comparePolicies.ps1
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  12-6-2023
		KEYWORDS:  policy management Management
#>

[cmdletbinding()] 
Param (

    #paramter for the uri BIO policy
    [Parameter(Mandatory = $false)]
    $BioPolicy = "https://raw.githubusercontent.com/Azure/Bio-Compliancy/main/ARM/BIO-azuredeploy.json",

    #paramter for the uri Microsoft security baseline
    [Parameter(Mandatory = $false)]
    $compareFile ="https://raw.githubusercontent.com/Azure/azure-policy/master/built-in-policies/policySetDefinitions/Azure%20Government/Security%20Center/AzureSecurityCenter.json"
   

)

class PolicyCompareInfo {
    [string]$comparePolicyDefinition
    [string]$BioPolicyJson
    [string]$policyDefinitionReferenceId;
    [string]$policyDescription;
    [String]$policyDisplayName;
    [String]$policyDefaultEffect
    [String]$status
    [String]$Remarks
} 

$root = $PSScriptRoot
$ResultFolder = "$root\..\results"
# create the $resultFolder if it does not exist
if (!(Test-Path $ResultFolder)) {
    New-Item -ItemType Directory -Path $ResultFolder
}

# validate if module PSExcel is installed else install
if (!(Get-Module -ListAvailable -Name PSExcel)) {
    Write-Host "PSExcel is not installed, installing PSExcel" -ForegroundColor Yellow
    Install-Module -Name PSExcel -Force
}


#get the name from the file name $comparePolicyDefinition
$comparePolicyDefinitionName = $compareFile -split "\.json" | Select-Object -First 1
$comparePolicyDefinitionName = $comparePolicyDefinitionName  -split "/" | Select-Object -Last 1

# Get the content from the BIO policy
$CompareContent = Invoke-WebRequest -Uri $BioPolicy

# Load the payload file as a JSON object
$BioPolicyJson = ( $CompareContent.content | ConvertFrom-Json).resources.properties.policyDefinitions

# Get the content from the Microsoft security baseline
$CompareContent = Invoke-WebRequest -Uri $compareFile

# Load the compare file as a JSON object
$compareJson = ($CompareContent.content| ConvertFrom-Json).properties.policyDefinitions
 
$logobjectPolicy = @()

# Get all the policyDefinitions from the subscription
$PolicyInfoAll = Get-AzPolicyDefinition -BackwardCompatible 

# Go trough all the  policyDefinitions from the payloadJSON 
foreach ($policyDefinition in $BioPolicyJson) {
    # Get the policyDefinitionReferenceId
    $policyDefinitionId = $policyDefinition.policyDefinitionId 

    #select $compareJson where  policyDefinitionId is equal to $policyDefinitionId
    $comparePolicyDefinition = $compareJson | Where-Object { $_.policyDefinitionId -eq $policyDefinitionId }
    
    #If $comparePolicyDefinition is not null
    If ($comparePolicyDefinition) {

        #select $PolicyInfoAll where  policyDefinitionId is equal to $policyDefinitionId
        $policyInfo = $PolicyInfoAll | Where-Object { $_.'ResourceId' -like  $policyDefinitionId }
        $policyId = ($policyDefinitionId -split "/")[-1]
        # Add the policyDefinition to the $logobjectPolicy
        $logobjectPolicy += @([PolicyCompareInfo]@{
            comparePolicyDefinition = $comparePolicyDefinitionName
            BioPolicyJson = "BIO"
            policyDefinitionReferenceId = $PolicyId
            policyDescription = $policyInfo.Properties.Description
            policyDisplayName =  $policyInfo.Properties.DisplayName
            policyDefaultEffect = $policyInfo.Parameters.effect.defaultValue
            status = "inBoth"
            
            Remarks = ""
        })
    }
    else {
       #Only in BIO
        $policyInfo = $PolicyInfoAll | Where-Object { $_.'ResourceId' -like  $policyDefinitionId }
        $policyDefinitionId
        $policyId = ($policyDefinitionId -split "/")[-1]
        $logobjectPolicy += @([PolicyCompareInfo]@{
            comparePolicyDefinition = $comparePolicyDefinitionName
            BioPolicyJson  = "BIO"
            policyDefinitionReferenceId = $PolicyId
            policyDescription = $policyInfo.Properties.Description
            policyDisplayName =  $policyInfo.Properties.DisplayName
            policyDefaultEffect = $policyInfo.Parameters.effect.defaultValue
            status = "onlyInBIO"
            
            Remarks = ""
        })

        write-host "no match $policyDefinitionId"
    }
}


# Go trough all the  policyDefinitions from the payloadJSON 
foreach ($policyDefinition in $compareJson) {
    # Get the policyDefinitionReferenceId
    $policyDefinitionId = $policyDefinition.policyDefinitionId 

    #select $compareJson where  policyDefinitionId is equal to $policyDefinitionId
    $comparePolicyDefinition = $BioPolicyJson | Where-Object { $_.policyDefinitionId -eq $policyDefinitionId }
    
    #If $comparePolicyDefinition is not null
    If ($comparePolicyDefinition) {
        write-host "match $policyDefinitionId"
    }
    else {
       #Only in Microsoft security baseline
        $policyInfo = $PolicyInfoAll | Where-Object { $_.'ResourceId' -like  $policyDefinitionId }
        $policyId = ($policyDefinitionId -split "/")[-1]
        $logobjectPolicy += @([PolicyCompareInfo]@{
            comparePolicyDefinition = $comparePolicyDefinitionName
            BioPolicyJson  = "BIO"
            policyDefinitionReferenceId = $PolicyId
            policyDescription = $policyInfo.Properties.Description
            policyDisplayName =  $policyInfo.Properties.DisplayName
            policyDefaultEffect = $policyInfo.Parameters.effect.defaultValue
            status  = "onlyInMSBaseline"
            Remarks = ""
        })

        write-host "no match $policyDefinitionId"
    }
}



$logobjectPolicy  | Format-Table -AutoSize 

# if file exist remove file the .\Policyinfo.xlsx
if (Test-Path $ResultFolder\PolicyCompare$($comparePolicyDefinitionName).xlsx) {
    remove-item $ResultFolder\PolicyCompare$($comparePolicyDefinitionName).xlsx
}
#Export the $logobjectPolicy to a xlsx file
$logobjectPolicy  | Export-XLSX -Path $ResultFolder\PolicyCompare$($comparePolicyDefinitionName).xlsx



