$TenantAdminName = "shawn@rbertesting2019.onmicrosoft.com" ## MFA is not supported for Tenant Admin


# Check to make sure Service Principal Exists
#Get-AzureADServicePrincipal -Filter "AppId eq '2565bd9d-da50-47d4-8b85-4c97f669dc36'"

# Create the service principal for Azure AD Domain Services. 
New-AzureADServicePrincipal -AppId "2565bd9d-da50-47d4-8b85-4c97f669dc36"

# Create the delegated administration group for AAD Domain Services.
New-AzureADGroup -DisplayName "AAD DC Administrators" `
    -Description "Delegated group to administer Azure AD Domain Services" `
    -SecurityEnabled $true -MailEnabled $false `
    -MailNickName "AADDCAdministrators"

# First, retrieve the object ID of the newly created 'AAD DC Administrators' group.

$GroupObjectId = Get-AzureADGroup -SearchString 'AAD DC Administrators' | Select-Object ObjectId;

# Now, retrieve the object ID of the user you'd like to add to the group.

$UserObjectId = Get-AzureADUser -ObjectId $TenantAdminName | Select-Object ObjectId

# Add the user to the 'AAD DC Administrators' group.
## Could add the users into an object or array and then add multiple users into this group - thoughts on this?
Add-AzureADGroupMember -ObjectId $GroupObjectId.ObjectId -RefObjectId $UserObjectId.ObjectId

# Register the resource provider for Azure AD Domain Services with Resource Manager.
Register-AzResourceProvider -ProviderNamespace Microsoft.AAD

# Run ARM Template next through Vertex
