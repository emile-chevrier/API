# Install the required modules
# Install-Module -Name Microsoft.PowerShell.SecretManagement -AllowClobber
# Install-Module -Name Microsoft.PowerShell.SecretStore -AllowClobber

# Import the modules
Import-Module Microsoft.PowerShell.SecretManagement
Import-Module Microsoft.PowerShell.SecretStore



# Prompt for username and password
$username = "PSUser"
$password = ConvertTo-SecureString "customPassword" -AsPlainText -Force

# Create a PSCredential object
$credential = New-Object -TypeName PSCredential -ArgumentList $username, $password

# Store the credential in the SecretManagement vault
Set-Secret -Name "PS_credentials" -Secret $credential

# Confirm creation
Write-Host "Credential created successfully."
