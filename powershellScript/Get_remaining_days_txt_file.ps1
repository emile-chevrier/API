# Import Active Directory module (if not already imported)
Import-Module ActiveDirectory

# Define the path for the output file
$outputFile = "C:\temp\Days_remainings.txt"

# Delete the file if it already exists
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# Prepare output array
$resultsArray = @()

# Get all users from Active Directory, including the accountExpires attribute
$users = Get-ADUser -Filter * -Properties accountExpires

foreach ($user in $users) {
    $userName = $user.SamAccountName

    if ($user.accountExpires -eq 0 -or $user.accountExpires -eq 9223372036854775807) {
        $daysRemaining = "Never expires"
    } else {
        try {
            # Convert the accountExpires value to a readable date
            $accountExpirationDate = [datetime]::FromFileTime($user.accountExpires)

            # Calculate the remaining days until expiration
            $currentDate = Get-Date
            $daysRemaining = ($accountExpirationDate - $currentDate).Days

            if ($daysRemaining -lt 0) {
                $daysRemaining = "Expired"
            }
        } catch {
            $daysRemaining = "Error processing date"
        }
    }

    # Add the result to the array in the format [name, remainingDays]
    $resultsArray += ,@($userName, $daysRemaining)
}

# Convert the array to the required string format for output
$formattedResultsArray = $resultsArray | ForEach-Object { "[`"$($_[0])`",`"$($_[1])`"]" }

# Join the array elements with commas to create the final output string
$finalOutput = "[{0}]" -f ($formattedResultsArray -join ',')

# Write the output to the file
$finalOutput | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "Results saved to $outputFile"
