<#
	.SYNOPSIS
        1. Script to get the last used version to compare with this writes in the tab versioned the collum LastPolicyVersion



	.DESCRIPTION

     Script to get the latest versions.
    
    



	.EXAMPLE
	   .\WritePolicyVersionToData.ps1
	   
	.LINK

	.Notes
		NAME:      WritePolicyVersionToData.ps1
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  12-6-2023
		KEYWORDS:  policy management Management
#>

[cmdletbinding()] 
Param (
    #paramter for the input exel file
    [Parameter(Mandatory = $false)]
    [string]$inputExcelFile = "data.xlsx",

    #parameter for tab in excel file
    [Parameter(Mandatory = $false)]
    [string]$inputExcelTab = "v2.2.5",

    #parameter for the output json file
    [Parameter(Mandatory = $false)]
    [string]$InputLastJsonFile = "2.2.4.withversions.json",

    #parameter for the output json file
    [Parameter(Mandatory = $false)]
    [string]$OutputExcelFile = "datawithversions.xlsx"
) 
# force loading the module
Install-Module -Name PSExcel -Force

$root = $PSScriptRoot

# Set the variables we use fixed folder  structure for the DeployTemplates SUbscription and management group and ParameterOverrid.json
$resultFolder = "$root\..\results\"
$policyInfoFile = "$resultFolder\$inputExcelFile"
$LastInputJsonFile = "$resultFolder\$InputLastJsonFile"

$PolicyInfoAll = Get-AzPolicyDefinition -Builtin -BackwardCompatible

# validate if file $policyInfo exist else message and exit
if (!(Test-Path $policyInfoFile)) {
    Write-Host "File $policyInfofile does not exist" -ForegroundColor Red
    exit
}


# validate if file $TemplateFile exist else message and exit
if (!(Test-Path $LastInputJsonFile )) {
    Write-Host "File $LastInputJsonFile does not exist" -ForegroundColor Red
    exit
}

# Read the last json file

$LastFileCOntent = Get-Content $LastInputJsonFile  | ConvertFrom-Json 

# Open the excel file and read the data from the tab $inputExcelTab
$inputExcelFile = Import-XLSX -Path $policyInfoFile -sheet $inputExcelTab -RowStart 1

$outputfile = @()

# Loop trough each row in the excel data and where policyName is not "$null" find the version in the json
foreach ($row in $inputExcelFile) {
    if ($row.policyDefinitionReferenceId -ne "") {
        # find the policy in the last json file
        $policy = $LastFileCOntent.properties.policyDefinitions | Where-Object { $_.policyDefinitionId -eq $row.PolicyID }
        if ($policy -ne $null) {
            # get the version from the policy
            $version = $policy.definitionVersion
            # set the version in the excel row
            $row.LastPolicyVersion = $version
  
            $policyInfo = $PolicyInfoAll | Where-Object { $_.'Id' -like $Policy.policyDefinitionId }
            $version2 = $PolicyInfo.Properties.Metadata.version
            $newversion = $version2 -replace '.\d+\.\d+', '.*.*'
            $row.CurrentPolicyVersion = $newversion
            Write-Host "Set version in json $($version) latestversion $($newversion) for policy $($row.PolicyName)" -ForegroundColor Green
        }
        else {
            Write-Host "Policy $($row.PolicyName) not found in last json file" -ForegroundColor Yellow
        }
    }
    $outputfile += $row
}
if (Test-Path $Resultfolder\$OutputExcelFile) {
    remove-item $Resultfolder\$OutputExcelFile
}
write-host "Exporting to $Resultfolder\$OutputExcelFile" -ForegroundColor Cyan
$outputfile  | Export-XLSX -Path $Resultfolder\$OutputExcelFile

