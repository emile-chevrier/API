winget install OpenSSL.OpenSSL

rundll32 sysdm.cpl,EditEnvironmentVariables



# Generate a private key
#openssl genrsa -out private-key.pem 2048

# Generate a certificate signing request (CSR)
#openssl req -new -key private-key.pem -out csr.pem

# Generate the self-signed certificate (valid for 365 days)
#openssl x509 -req -days 365 -in csr.pem -signkey private-key.pem -out certificate.pem
