const express = require('express');
const sql = require('mssql');
const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');
const cookieParser = require('cookie-parser');
const https = require('https'); // Import the https module

// Create an Express application
const app = express();
app.use(express.json()); // Parse JSON payloads
app.use(cookieParser()); // Parse cookies

// Serve static files from the 'public' directory
app.use(express.static(path.join(__dirname, 'public'))); // Ensure 'index.html' is in 'public' directory

// Route to serve index.html explicitly
app.get('/index', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Retrieve credentials using PowerShell
function getCredentials(executionPolicy = 'Bypass') {
  try {
    const scriptPath = path.join(__dirname, 'powershellScript', 'get-credentials.ps1');
    if (!fs.existsSync(scriptPath)) {
      throw new Error(`File does not exist: ${scriptPath}`);
    }

    const result = execSync(`powershell -ExecutionPolicy ${executionPolicy} -File "${scriptPath}"`, { encoding: 'utf8' }).trim();
    const [username, password, database, dbServer] = result.split('|');
    return { username, password, database, dbServer };
  } catch (err) {
    console.error('Error details:', err.stack);
    throw new Error('Failed to retrieve credentials: ' + err.message);
  }
}

// Load SQL Server connection configuration
const { username, password, database, dbServer } = getCredentials(); // Retrieve credentials
const sqlConfig = {
  user: username,
  password: password,
  database: database,
  server: dbServer,
  port: 1433,
  options: {
    encrypt: false,
    enableArithAbort: true
  }
};

// Endpoint to get DaysRemaining based on Username
app.post('/password-remaining', async (req, res) => {
  // Set Content Security Policy headers for this endpoint
  res.setHeader("Content-Security-Policy", "https://apc-dv-wwmes.pci.local:8002;");
  res.setHeader("Access-Control-Allow-Origin", "https://apc-dv-wwmes.pci.local:8001"); // Replace with your actual frontend domain

  const { Username } = req.body;

  if (!Username) {
    return res.status(400).json({ error: 'Username is required in the payload' });
  }

  try {
    await sql.connect(sqlConfig);
    const result = await sql.query`SELECT DaysRemaining FROM PasswordRemainDays WHERE Username = ${Username}`;

    if (result.recordset.length > 0) {
      const daysRemaining = result.recordset[0].DaysRemaining;
      res.cookie('daysRemaining', daysRemaining, { maxAge: 86400000 }); // Set cookie for 1 day
      res.json({ DaysRemaining: daysRemaining });
    } else {
      res.status(404).json({ error: 'Username not found' });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'An error occurred while processing your request' });
  } finally {
    await sql.close(); // Ensure the SQL connection is closed properly
  }
});

// Load SSL certificate and key
const options = {
  key: fs.readFileSync(path.join(__dirname, 'Certificat', 'private_key.pem')), // Path to your private key
  cert: fs.readFileSync(path.join(__dirname, 'Certificat', 'certificate.pem')) // Path to your public certificate
};

// Start the server on port 8002 using HTTPS
const server = https.createServer(options, app); // Create HTTPS server
server.listen(8002, () => {
  console.log('HTTPS Server is running on port 8002');
});
