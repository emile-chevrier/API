#Install-PackageProvider -Name NuGet
#Update-Module PowerShellGet
#Install-Module PowerShellGet

#Install-Module -Name CredentialManager -Force


Import-Module CredentialManager

$cred = Get-StoredCredential -Target "PS_credentials"
# Extract values from the secret
$username = $cred.UserName
$password = $cred.GetNetworkCredential().Password
$database = "MESDB"
$server = "Localhost"

# Output credentials in a format that can be parsed by Node.js
"$username|$password|$database|$server"


