const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const app = express();
const port = 3000;

app.use(cors()); // allow frontend to fetch data

// --- MySQL connection ---
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',      
  password: 'Janvi@123',      
  database: 'placementdb'
});

// Connect to DB
db.connect(err => {
  if (err) throw err;
  console.log('Connected to MySQL database');
});

// --- Routes to fetch dashboard data ---

// KPI
app.get('/dashboard-kpi', (req, res) => {
  db.query('SELECT * FROM Dashboard_KPI', (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

// Placement Status (Pie Chart)
app.get('/placement-status', (req, res) => {
  db.query('SELECT * FROM Placement_Status', (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

// Branch-wise Placement (Bar Chart)
app.get('/branch-placement', (req, res) => {
  db.query('SELECT * FROM Branch_Placement', (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

// Placement Trend (Line Chart)
app.get('/placement-trend', (req, res) => {
  db.query('SELECT * FROM Placement_Trend', (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

// Company-wise Placement
app.get('/company-placement', (req, res) => {
  db.query('SELECT * FROM Company_Placement', (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});