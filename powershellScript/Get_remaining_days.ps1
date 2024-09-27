# Install RSAT for Active Directory (if not already installed)
# Add-WindowsFeature RSAT-AD-PowerShell

# Import Active Directory module (if not already imported)
Import-Module ActiveDirectory

# Define SQL Server connection settings
$serverName = "localhost"  # Replace with your SQL Server name
$databaseName = "MESDB"  # Replace with your database name
$tableName = "PasswordRemainDays"

# Define connection string using Windows credentials
$connectionString = "Server=$serverName;Database=$databaseName;Integrated Security=True;"

# Create SQL connection
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString

# Open the connection
$connection.Open()

# Delete all existing records in the PasswordRemainDays table
$deleteQuery = "DELETE FROM $tableName;"
$deleteCommand = $connection.CreateCommand()
$deleteCommand.CommandText = $deleteQuery
$deleteCommand.ExecuteNonQuery()

# Get all users from Active Directory, including the accountExpires attribute
$users = Get-ADUser -Filter * -Properties accountExpires

# Prepare to insert new records into the PasswordRemainDays table
$insertQuery = "INSERT INTO $tableName (Username, DaysRemaining) VALUES (@Username, @DaysRemaining);"

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

            if ($daysRemaining -gt 0) {
                $daysRemaining = "$daysRemaining"
            } elseif ($daysRemaining -eq 0) {
                $daysRemaining = "$daysRemaining"
            } else {
                $daysRemaining = "$daysRemaining"
            }
        } catch {
            $daysRemaining = "Error processing date"
        }
    }

    # Insert the record into the PasswordRemainDays table
    $insertCommand = $connection.CreateCommand()
    $insertCommand.CommandText = $insertQuery
    $insertCommand.Parameters.Add((New-Object System.Data.SqlClient.SqlParameter("@Username", [System.Data.SqlDbType]::VarChar, 255))).Value = $userName
    $insertCommand.Parameters.Add((New-Object System.Data.SqlClient.SqlParameter("@DaysRemaining", [System.Data.SqlDbType]::VarChar, 400))).Value = $daysRemaining
    $insertCommand.ExecuteNonQuery()
}

# Close the connection
$connection.Close()
