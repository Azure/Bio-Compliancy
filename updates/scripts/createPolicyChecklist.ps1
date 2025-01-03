<#
	.SYNOPSIS
        1. Create an excel file that axport all the policies in an initiative including empty groupnames for a checklist
        2. Please add the old depraciated policies to the excel file to be complete when using his to create the markdown file
        3. Better is to use this file of deprecated policies to update these in the copied excel file as these has the history in RevesionDateMMYY



	.DESCRIPTION

         
     Use the excel to collect we should keep track of ISO and NIST etc

	.EXAMPLE
	   .\createPolicyChecklist.ps1 
	   
	.LINK

	.Notes
		NAME:      createPolicyChecklist.ps1
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  12-6-2023
		KEYWORDS:  policy management Management
#>

[cmdletbinding()] 
Param (


    #paramter for the uri BIO policy
    [Parameter(Mandatory = $false)]
    $BioPolicy = "https://raw.githubusercontent.com/Azure/Bio-Compliancy/main/ARM/BIO-azuredeploy.json",

    #parameter for exportfilename with default value 
    [Parameter(Mandatory = $false)]
    $exportFileName = "BIO-Policy-Checklist.xlsx"
    

)


class PolicyInfo {
    [string]$GroupName;
    [string]$Category;
    [string]$DisplayName
    [string]$Description;
    [string]$PolicyID;
    [string]$policyDefinitionReferenceId;
    [string]$policyDescription;
    [String]$policyDisplayName;
    [String]$policyDefaultEffect
    [String]$IncludeJaNeeInPolicy;
    [String]$Remarks
} 

class PolicyGroups {
    [string]$GroupName;
    [string]$Category;
    [string]$DisplayName
    [string]$Description
}

# Read Excel and JSON File from disk


Install-Module -Name PSExcel
Get-command -module psexcel
$root = $PSScriptRoot

$Resultfolder = "$root\..\results"


$CompareContent = Invoke-WebRequest -Uri $BioPolicy

# Load the payload file as a JSON object
$BioPolicyJson = ( $CompareContent.content | ConvertFrom-Json).resources


$PolicyGroups = @()

$PolicyGroupsJsonObject = $BioPolicyJson.properties.policyDefinitionGroups

foreach ( $Groups in $PolicyGroupsJsonObject ) {


    $PolicyGroups += @([PolicyGroups]@{
             
                GroupName = $Groups.Name
                Category = $Groups.Category
                DisplayName = $Groups.DisplayName
                Description = $Groups.Description

        }
    )
}
$PolicyInfoAll = Get-AzPolicyDefinition -BackwardCompatible 

$PolicyObject = @()
$PolicyDefinitionsObject = $BioPolicyJson.properties.policyDefinitions

foreach ( $Policy in $PolicyDefinitionsObject) {
    
        $groupsNames = $Policy.groupNames 
  foreach ( $group in $groupsNames) {
    $GroupInfo = $PolicyGroups | Where-Object { $_.'GroupName' -like $group }
    # Create $PolicyInfo from $PolicyInfoAll where the PolicyDefinition is equal to $Policy.policyDefinitionId
    $policyInfo = $PolicyInfoAll | Where-Object { $_.'ResourceId' -like $Policy.policyDefinitionId }
    
    # $PolicyInfo = Get-AzPolicyDefinition -Id $Policy.policyDefinitionId
    
    $PolicyObject += @([PolicyInfo]@{
             
                GroupName = $GroupInfo.GroupName
                Category = $GroupInfo.Category
                DisplayName = $GroupInfo.DisplayName
                Description = $GroupInfo.Description
                PolicyID = $policyInfo.PolicyDefinitionId
                policyDefinitionReferenceId = $Policy.policyDefinitionReferenceId
                policyDescription           = $policyInfo.Properties.Description
                policyDisplayName           = $policyInfo.Properties.DisplayName
                policyDefaultEffect         = $policyInfo.Properties.Parameters.effect.defaultValue
                IncludeJaNeeInPolicy = ""
                Remarks = ""

        }
    )
}
    #lower case the $Policy.IncludeJaNeeInNBAPolicy and check if the ja is contained in the string

}


Foreach ($policyGroup in $PolicyGroups) {





    $MatchBIORecord =  $PolicyObject  | Where-Object { $_.'GroupName' -like $policyGroup.GroupName }


    If ($MatchBIORecord ) {
       
    }
    else {
        
        $PolicyObject += @([PolicyInfo]@{
             
            GroupName = $policyGroup.GroupName
            Category = $policyGroup.Category
            DisplayName = $policyGroup.DisplayName
            Description = $policyGroup.Description
            policyDefinitionReferenceId = ""
            policyDescription           = ""
            policyDisplayName           = ""
            policyDefaultEffect         = ""
            IncludeJaNeeInPolicy = ""
            Remarks = ""

    }
)
        }
    }


    $BIOResultObject = $PolicyObject | Sort-Object -Property GroupName


    $BIOResultObject | Format-Table -AutoSize 

    if (Test-Path $Resultfolder\$exportFileName) {
        remove-item $Resultfolder\$exportFileName
    }
    $BIOResultObject | Export-XLSX -Path $Resultfolder\$exportFileName
