const db = require('../config/db');

const getAllTrains = (req, res) => {
  const sql = `
    SELECT t.*,
      GROUP_CONCAT(CONCAT(sc.class_code,'|',sc.class_name,'|',sc.total_seats,'|',sc.fare_per_km) SEPARATOR ';;') AS classes
    FROM trains t
    LEFT JOIN seat_classes sc ON sc.train_id = t.id
    GROUP BY t.id
    ORDER BY t.train_number`;

  db.query(sql, (err, rows) => {
    if (err) return res.json({ success: false, message: err.message });
    res.json({ success: true, trains: parseTrains(rows) });
  });
};

const searchTrains = (req, res) => {
  const { from, to, date } = req.query;
  if (!from || !to) return res.json({ success: false, message: 'From and To are required' });

  const dayNames = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
  const day = date ? dayNames[new Date(date).getDay()] : null;

  let sql = `
    SELECT t.*,
      GROUP_CONCAT(CONCAT(sc.class_code,'|',sc.class_name,'|',sc.total_seats,'|',sc.fare_per_km) SEPARATOR ';;') AS classes
    FROM trains t
    LEFT JOIN seat_classes sc ON sc.train_id = t.id
    WHERE t.source LIKE ? AND t.destination LIKE ? AND t.status='Active'`;
  const params = [`%${from}%`, `%${to}%`];

  if (day) { sql += ` AND t.runs_on LIKE ?`; params.push(`%${day}%`); }
  sql += ' GROUP BY t.id ORDER BY t.departure';

  db.query(sql, params, (err, rows) => {
    if (err) return res.json({ success: false, message: err.message });
    res.json({ success: true, trains: parseTrains(rows) });
  });
};

const getTrainById = (req, res) => {
  db.query('SELECT * FROM trains WHERE id=?', [req.params.id], (err, rows) => {
    if (err || !rows.length) return res.json({ success: false, message: 'Train not found' });
    db.query('SELECT * FROM seat_classes WHERE train_id=?', [req.params.id], (e2, classes) => {
      res.json({ success: true, train: rows[0], classes: classes || [] });
    });
  });
};

function parseTrains(rows) {
  return rows.map(t => ({
    ...t,
    classes: t.classes
      ? t.classes.split(';;').map(c => {
          const [code, name, seats, fare] = c.split('|');
          return { code, name, seats: +seats, fare: +fare };
        })
      : []
  }));
}

module.exports = { getAllTrains, searchTrains, getTrainById };
