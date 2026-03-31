const mysql = require('mysql2');

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password:'Himanshu@62999', // ← add your MySQL password here if any
  database: 'railbook_pro'
});

db.connect((err) => {
  if (err) { console.error('❌ DB Error:', err.message); process.exit(1); }
  console.log('✅ MySQL Connected → railbook_pro');
});

module.exports = db;
