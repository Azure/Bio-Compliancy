<#
	.SYNOPSIS
        1. Create an Policy Definition based on an Excel 



	.DESCRIPTION

    Use Excel to modify the next version of the policy definition.
    The script will create a new policy definition based on the excel file.

    Remark: When having issues with createing output. Run the script in debug mode. Direct starting result in not correct working PSExcel module that reads not the data on my machine.



	.EXAMPLE
	   .\createPolicyInitiative.ps1
	   
	.LINK

	.Notes
		NAME:      createPolicyInitiative.ps1
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
    [string]$inputExcelTab = "v2.2.3",

    #parameter for the output json file
    [Parameter(Mandatory = $false)]
    [string]$outputJsonFileSub = "BIO-azuredeploy-subscription.json",
    
    #parameter for the output json file
    [Parameter(Mandatory = $false)]
    [string]$outputJsonFileMng = "BIO-azuredeploy.json",

    #parameter for the output json file
    [Parameter(Mandatory = $false)]
    [string]$outputJsonFileSubUpdate = "BIO-azuredeploy-subscription-update.json",
    
    #parameter for the output json file
    [Parameter(Mandatory = $false)]
    [string]$outputJsonFileMngUpdate = "BIO-azuredeploy-update.json"
    

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
    [String]$bioVersion 
    [String]$deprecated
    [String]$RevisionDateMMYY
    [String]$Remarks

} 



class DefinitionGroup {
    [string]$name;
    [string]$category;
    [string]$displayName;
    [string]$description;
}

class PolicyDef {
    [string]$policyDefinitionReferenceId;
    [array]$groupsNames;
    [PSObject]$Parameters;
    [PSObject]$Definitions;



    
}

class ParametersPolicyDef {

    [PSObject]$Parameters;
    
}

#First set some variables for the objects used for the policy definition
$policyDefinitionjson = @"
{
    "policyDefinitionId": "/providers/Microsoft.Management/managementGroups/contoso/providers/Microsoft.Authorization/policyDefinitions/Proposeddisplayname",
    "policyDefinitionReferenceId": "nametobeaddedfromproposedfilename",
    "parameters": {
                       
    },
    "groupNames": [
            "A: Policy"
        ]
}
"@

$policyParameters = @"
{
}
"@

$policyValue = @"
{
    "value": ""
}
"@

# validate if module PSExcel is installed else install
if (!(Get-Module -ListAvailable -Name PSExcel)) {
    Write-Host "PSExcel is not installed, installing PSExcel" -ForegroundColor Yellow
    Install-Module -Name PSExcel -Force
}
# force loading the module
Install-Module -Name PSExcel -Force

$root = $PSScriptRoot

# Set the variables we use fixed folder  structure for the DeployTemplates SUbscription and management group and ParameterOverrid.json
$resultFolder = "$root\..\results\"
$policyInfoFile = "$resultFolder\$inputExcelFile"
$TemplateFile = "$root\..\templateFiles\policyDeployTemplate-subscription.json"
$parameterOverRideFile = "$root\..\parameterOverride\policyparameterOverRide.json"
$resultfile = "$resultFolder\$outputJsonFileSub"
$resultfileUpdate = "$resultFolder\$outputJsonFileSubUpdate"
$TemplateFileMng = "$root\..\templateFiles\policyDeployTemplate-managementgroup.json"
$resultfileMng = "$resultFolder\$outputJsonFileMng"
$resultfileMngUpdate = "$resultFolder\$outputJsonFileMngUpdate"



# validate if file $policyInfo exist else message and exit
if (!(Test-Path $policyInfoFile)) {
    Write-Host "File $policyInfo does not exist" -ForegroundColor Red
    exit
}

# validate if file $TemplateFile exist else message and exit
if (!(Test-Path $TemplateFile)) {
    Write-Host "File $TemplateFile does not exist" -ForegroundColor Red
    exit
}
# validate if file $parameterOverRideFile exist else message and exit
if (!(Test-Path $parameterOverRideFile)) {
    Write-Host "File $parameterOverRideFile does not exist" -ForegroundColor Red
    exit
}


# validate if file $TemplateFileMng exist else message and exit
if (!(Test-Path $TemplateFileMng)) {
    Write-Host "File $TemplateFileMng does not exist" -ForegroundColor Red
    exit
}


$policyInfo = @()
#read the template file and convert to json
$TemplateFileContent = Get-Content $TemplateFile  | ConvertFrom-Json 
$TemplateFileContentUpdate = Get-Content $TemplateFile  | ConvertFrom-Json 

$TemplateFileContentMng = Get-Content $TemplateFileMng  | ConvertFrom-Json 
$TemplateFileContentMngUpdate = Get-Content $TemplateFileMng  | ConvertFrom-Json 
#read the parameter override file and convert to json
$ParameterOverRide = Get-Content $parameterOverRideFile  | ConvertFrom-Json 


Write-Host "Reading Excel $($policyInfoFile) with tab $($inputExcelTab)"
# Read the Excel file and create a object with the data
$inputExcelFile = Import-XLSX -Path $policyInfoFile -sheet $inputExcelTab -RowStart 1

# Select only the columns that are needed for groups. Our excel should have also groups in it without any policydefinition so we have the complete list
$inputGroups = $inputExcelFile | Select-Object GroupName, Category, DisplayName, Description -Unique
$definitionGroupObject = @()
foreach ( $groups in $inputGroups ) {

          
    $definitionGroupObject += @([DefinitionGroup]@{
            name        = $groups.GroupName
            category    = $groups.Category
            displayName = $groups.DisplayName
            description = $groups.Description

              
        }
    )
}
    
    
$PolicyRefs = @()
$policyPar = @()
$policyParUpdate = @()
$policyPar = $policyParameters |  ConvertFrom-Json 
$policyParUpdate = $policyParameters |  ConvertFrom-Json 


# Select only the unique PolicyID's
$policyDefinitionReferenceId = $inputExcelFile  | Select-Object @{Label = "policyRefId"; Expression = { "$($_.'PolicyId')" } }, policyDefinitionReferenceId , deprecated -Unique
Write-Host "Excel first  $($inputExcelFile[0]) "
$PolicyInfoAll = Get-AzPolicyDefinition

foreach ($policy in $policyDefinitionReferenceId) {
    # check if $policy.policyRefId is not empty

    if ( $policy.policyRefId.Equals('$null')  ) {
        # Write-Host "PolicyID is empty" -ForegroundColor Red
        
    }
    elseif ($null -ne $policy.policyRefId -and $policy.policyRefId -ne "" ) {
     
        # get the policy info from the excel file based on the policyRefId
        $getAllRefID = $inputExcelFile | Where-Object { $_.PolicyId -in $Policy.policyRefId }
        $policyGroups = $getAllRefID  | Select-Object  @{Label = "GroupNames"; Expression = { "$($_.'GroupName')" } } -Unique

        # get the last token from $Policy.policyRefId based on /
        $id = $policy.policyRefId.Split("/")[-1]

        
        $policyInfo = $PolicyInfoAll | Where-Object { $_.'ResourceId' -like $Policy.policyRefId }

        $NewPolicyDefinition = @()
        $NewPolicyDefinition = $policyDefinitionjson |  ConvertFrom-Json 
        $NewPolicyDefinition.policyDefinitionId = $Policy.policyRefId 
        $NewPolicyDefinition.policyDefinitionReferenceId = $Policy.policyDefinitionReferenceId

        # Build the policy definition parameters 

        $PolicyInfo.Properties.Parameters.PSObject.Properties | ForEach-Object {
            $parameterName = $_.Name
            if ($ParameterOverRide.parametersRename.($parameterName) -ne $null) {
                $parameterName = $ParameterOverRide.parametersRename.($parameterName)
            }
            if ($null -ne $_.Name) {
                if ($parameterName -eq "effect") {
            
                    #append the $id to the $parameterName with a - to make it unique
                    $parameterName = "$($parameterName)-$($id)"

                }
                $NewPolicyValue = @()
                $NewPolicyValue = $policyValue |  ConvertFrom-Json 
                $NewPolicyValue.value = "[[parameters('$($parameterName)')]"
                $NewPolicyDefinition.parameters | Add-Member -MemberType NoteProperty $_.Name -Value $NewPolicyValue -Force
                #   $NewPolicyDefinition.parameters.$($parameter.Name).value = "[[parameters('$($parameterName)')]"
            }
        }

        # Build the parameters list

        $PolicyInfo.Properties.Parameters.PSObject.Properties | ForEach-Object {
      
            $parameterName = $_.Name
            if ($ParameterOverRide.parametersRename.($parameterName) -ne $null) {
                $parameterName = $ParameterOverRide.parametersRename.($parameterName)
            }
            if ($parameterName -eq "effect") {
           
                #append the $id to the $parameterName with a - to make it unique
                $parameterName = "$($parameterName)-$($id)"
      
                $_.Value.metadata.displayName = "Effect for policy:$($PolicyInfo.Properties.DisplayName)"
            
            }

            # if the policy is deprecated then add a deprecated property to the metadata

            if ($policy.deprecated -eq "TRUE") {
                $_.Value.metadata | Add-Member -MemberType NoteProperty "deprecated" -Value $true -Force
            }
     
            # if the  $_.Value.metadata.displayName starts with an [ then add [ to at the start of the string
            if ($null -ne $_.Value.metadata.displayName) {
                if ($_.Value.metadata.displayName.StartsWith("[")) {
                    $_.Value.metadata.displayName = "[" + $_.Value.metadata.displayName
                }
            }


            if ($policy.deprecated -eq "TRUE") {
                if ($policyParUpdate.($parameterName) -eq $null) {

                    if ($null -ne $parameterName ) {
                        if ($ParameterOverRide.parameters.($parameterName) -eq $null) {
                            $policyParUpdate | Add-Member -MemberType NoteProperty $parameterName  -Value $_.value -Force            
                        }
                        else {
                            $policyParUpdate | Add-Member -MemberType NoteProperty $parameterName -Value $ParameterOverRide.parameters.($parameterName) -Force
                        }
                    }
                }
            }
            else {
                if ($policyPar.($parameterName) -eq $null) {

                    if ($null -ne $parameterName ) {
                        if ($ParameterOverRide.parameters.($parameterName) -eq $null) {
                            $policyPar | Add-Member -MemberType NoteProperty $parameterName  -Value $_.value -Force         
                            $policyParUpdate | Add-Member -MemberType NoteProperty $parameterName  -Value $_.value -Force               
                        }
                        else {
                            $policyPar | Add-Member -MemberType NoteProperty $parameterName -Value $ParameterOverRide.parameters.($parameterName) -Force
                            $policyParUpdate | Add-Member -MemberType NoteProperty $parameterName -Value $ParameterOverRide.parameters.($parameterName) -Force
                        }
                    }
                }
            }
        }
        
 
        [array]$policyGroupsArray = $policyGroups.GroupNames | ForEach-Object { $(if ($_.length -gt 64) { $_.substring(0, 64) } else { $_ } ) }


        $NewPolicyDefinition.groupNames = [array]$policyGroupsArray
  

        # if the policy is deprecated then skip
    
        if ($policy.deprecated -ne "TRUE") {
         
            $PolicyRefs += @([PolicyDef]@{
                    policyDefinitionReferenceId = $policy.policyRefId
                    Definitions                 = $NewPolicyDefinition
      

                }
            )
        }
    }
        
       
}


# Add to the template file the policyDefinitionGroups, policyDefinitions and parameters
          
$TemplateFileContent.resources.properties.policyDefinitionGroups = $definitionGroupObject  | Sort-Object -Property name
$TemplateFileContent.resources.properties.policyDefinitions = $PolicyRefs | ForEach-Object { $_.Definitions }
$TemplateFileContent.resources.properties.parameters = $policyPar 

#create outputfile for subscription

$TemplateFileContent |  ConvertTo-Json  -Depth 100 | out-file $resultfile 

# Add to the template file the policyDefinitionGroups, policyDefinitions and parameters for Updates with Pararameters
          
$TemplateFileContentUpdate.resources.properties.policyDefinitionGroups = $definitionGroupObject  | Sort-Object -Property name
$TemplateFileContentUpdate.resources.properties.policyDefinitions = $PolicyRefs | ForEach-Object { $_.Definitions }
$TemplateFileContentUpdate.resources.properties.parameters = $policyParUpdate 

#create outputfile for subscription

$TemplateFileContentUpdate |  ConvertTo-Json  -Depth 100 | out-file $resultfileUpdate 


#create outputfile for Managementgroup

$TemplateFileContentMng.resources.properties.policyDefinitionGroups = $definitionGroupObject 
$TemplateFileContentMng.resources.properties.policyDefinitions = $PolicyRefs | ForEach-Object { $_.Definitions }
$TemplateFileContentMng.resources.properties.parameters = $policyPar


$TemplateFileContentMng |  ConvertTo-Json  -Depth 100 | out-file $resultfileMng

#create outputfile for ManagementgroupUpdate

$TemplateFileContentMngUpdate.resources.properties.policyDefinitionGroups = $definitionGroupObject 
$TemplateFileContentMngUpdate.resources.properties.policyDefinitions = $PolicyRefs | ForEach-Object { $_.Definitions }
$TemplateFileContentMngUpdate.resources.properties.parameters = $policyParUpdate


$TemplateFileContentMngUpdate |  ConvertTo-Json  -Depth 100 | out-file $resultfileMngUpdate