# Folder with files to update the policy initiative

This folder is used to update the policy initiative periodically. This will be done based on issues and pull requests and compared with new and deprecated policies. The deprecated policies will be removed, but parameters will be kept in the initiative with metadata deprecated.

We want only audit, deny or disabled policies in the policy initiative this to prevent that we require a managed identity for the policy initiative. This is not required for audit,deny or disabled policies, result in we will not have deploy if not exist policies in this policy initiative.

## Workflow

1. Create a compare file from the latest BIO with the Microsoft Security Baseline. Use the script ```.\scripts\compareWithInitiative.ps1``` to generate the compare file. The result file will be placed in the folder ```results``` called ```PolicyCompareMicrosoft_cloud_security_benchmark.xlsx```. The current script use the URI of the Microsoft Security Baseline and the URI for the BIO these can be changed as parameters. Also the scrip ```createPolicyChecklist.ps1 ``` can be used to quickly generate a checklist of the policies in the current BIO to see what policies are deprecated.
2. Update the ```results\data.xlsx``` by creating a new tab and copy the old content.
3. Use the column deprecated with TRUE when a policy is deprecated. Do not remove as these parameters these should still be in the definitionset as else the policy can not be updated. Add missing policies or updated policies. Update the remark when needed and fill in the version of the policy.
4. If required use the ```.\paramaterOverRide\policyparameterOverRide.json``` to override parameters. This can be used to override parameters and provide default values. Look when generated for Deny in default value.
5. Update the ```.\templateFiles\policyDeployTemplate-managementgroup.json``` and ```.\templateFiles\policyDeployTemplate-subscription.json```with the new version of the policy initiative example 2.3.2.
6. Edit and Run the script ```.\scripts\createPolicyInitiative.ps1``` to update the policy initiative change version of tab to be used to generate the file. This the policy based on the information from ```results\data.xlsx``` please either provide the parameter of the correct sheet or update the script with the correct excel sheet. This will create ```.\results\BIO-azuredeploy.json``` based on the template file and the information in the excel sheet. Look at error in target json like not allow charachers.
7. Test the new file ```.\results\BIO-azuredeploy.json``` by deploying the policy initiative. This can be done by using the script ```.\scripts\deployPolicyInitiative.ps1```. This will deploy the policy initiative to the subscription. Validate also the correct working of the update version that can be used to update existing/old to the new version.
8. Edit and run running the ```createUpdateMarkdown.ps1```  to create the update.md. This wil create in the result folder also the update.md. Do a DIF of files and create in the result folder a file otherUpdates.<version>.md to dcument any other changes.
9. When tested copy the files .\updates\results\BIO-azuredeploy.json, .\updates\results\BIO-azuredeploy-subscription.json including the update versions to .\ARM and .\updates\results\update.md to the folder .\docs.
10. Update in ```.\results\data.xlsx``` the overview pivot table to the correct sheet data please check als the filer on the policy name first select all then deselect the empty. Copy then the ```.\results\data.xlsx``` to the docs folder with the right version name Data-policy-mapping v2.2.4.xlx
11. Commit the changes to the repository make sure test it and create a pull request. Testing with hardcoded "portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietmanr%2FBio-Compliancy%2Fmain%" can be done by copy the url and modify only the repository and branch.

[back to main page](../README.md).


some links to test deployments please edit with the right github repository where you test from and the branch.



| Versie | Doel | Implementeer | Update bestaande policy |
|---|---|---|---|
| 2.2.1 | Management group level | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2FBio-Compliancy%2Fupdatesjan2025-2%2Fupdates%2Fresults%2FBIO-azuredeploy.json) | [![Deploy result test to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2FBio-Compliancy%2Fupdatesjan2025-2%2Fupdates%2Fresults%2FBIO-azuredeploy-update.json) |
| 2.2.1 | Subscription level | [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2FBio-Compliancy%2Fupdatesjan2025-2%2Fupdates%2Fresults%2FBIO-azuredeploy-subscription.json) |  [![Deploy result test to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2FBio-Compliancy%2Fupdatesjan2025-2%2Fupdates%2Fresults%2FBIO-azuredeploy-subscription-update.json) |
