# Define the certificate variables
$certPath = "C:\Project\API\Certificat"
$pfxFile = "$certPath\certificate.pfx"
$cacertFile = "$certPath\certificate.cer"
$privateKeyFile = "$certPath\private_key.pem"
$cacertPemFile = "$certPath\certificate.pem"
$password = "custom password"

# Ensure OpenSSL is installed and available in the system PATH
$opensslPath = "C:\Program Files\OpenSSL\bin\openssl.exe"  # Replace this with the actual path

# Check if the certificate directory exists; if not, create it
if (-not (Test-Path -Path $certPath)) {
    New-Item -ItemType Directory -Path $certPath
}

# Create the self-signed certificate
$cert = New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation "cert:\LocalMachine\My" -NotAfter (Get-Date).AddYears(1)

# Export the certificate to a .pfx file (including the private key)
$pwd = ConvertTo-SecureString -String $password -Force -AsPlainText
Export-PfxCertificate -Cert $cert -FilePath $pfxFile -Password $pwd

# Export the public certificate to a .cer file
Export-Certificate -Cert $cert -FilePath $cacertFile

# Convert the .pfx to .pem and extract the private key
# Ensure OpenSSL is installed and properly set in the system PATH

# Convert PFX to PEM format (certificate and private key in separate files)
Start-Process -FilePath $opensslPath -ArgumentList "pkcs12 -in `"$pfxFile`" -out `"$cacertPemFile`" -nodes -clcerts -password pass:$password" -NoNewWindow -Wait
Start-Process -FilePath $opensslPath -ArgumentList "pkcs12 -in `"$pfxFile`" -out `"$privateKeyFile`" -nodes -nocerts -password pass:$password" -NoNewWindow -Wait

# Display the result
Write-Host "Self-signed certificate and keys have been generated:"
Write-Host "PFX File: $pfxFile"
Write-Host "Public Certificate (CER): $cacertFile"
Write-Host "Private Key (PEM): $privateKeyFile"
Write-Host "Public Certificate (PEM): $cacertPemFile"
