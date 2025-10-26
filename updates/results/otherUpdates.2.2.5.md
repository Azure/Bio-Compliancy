
## 🔄 Deployment Process Changes

### Redeployment Required
Due to parameter updates (including deprecated policies), the current policy assignment exceeds the maximum limit of 400 parameters. As a result, we **no longer support in-place updates** for existing assigned policies.

**New Deployment Process:**
1. Delete existing policy assignments. Make sure to check your current parameter settings.
2. Remove current policy definition
3. Reassign the policy with your updated parameters

> **⚠️ Important:** This is a breaking change that requires manual intervention for existing deployments.

**Future Planning:** We plan to create a new initiative based on the next BIO version.

## 📋 Versioning Improvements

### Policy Initiative Versioning
- **New Feature:** Added support for policy definition versions in the initiative
- **Purpose:** Resolves deployment issues encountered in version 2.2.4. See [Issue #38](../../issues/38)
- **Implementation:** Starting from version 2.2.5, `definitionVersion` is explicitly provided

The deployment failure was caused by the Kubernetes policy `KubernetesClusterPodsShouldOnlyUseApprovedHostNetworkAndPortRange`:
- **Version Change:** Updated from version 6 to 7
- **Breaking Change:** Removed parameters in version 7:
  - `minPort`
  - `maxPort` 
  - `excludedContainers`

## 🔍 Policy Version Updates to Validate

The following policies have major version updates that require validation:

| Policy Name | Previous Version | New Version | Status |
|------------|------------------|-------------|---------|
| `KubernetesClusterContainersShouldNotShareHostProcessIDOrHostIPCNamespace` | 5.*.* | 6.*.* | First analyses. Same parameters updated to YAMLv3 no change in content.  |
| `KubernetesClustersShouldNotAllowContainerPrivilegeEscalation` | 7.*.* | 8.*.* | First Analysyes. New parameter forcePrivilegeEscalationToBeFalse with default false. Force all container securityContext.allowPrivilegeEscalation fields to be explicity set to false" |

> **📝 Note:** These major version changes may include breaking changes. Please review and test thoroughly before deployment.

## 🛠️ Bug Fixes

### Certificate Validity Period
- **Issue Fixed:** Updated default parameter `maximumValidityInMonths` from 12 to 13 months
- **Reference:** See [Issue #36](../../issues/36) for details
- **Impact:** Provides more flexibility for certificate management



