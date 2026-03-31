const db = require('../config/db');

function generatePNR() {
  return Math.floor(1000000000 + Math.random() * 9000000000).toString();
}

function generateSeat(classCode) {
  const coach = { '1A':'A','2A':'B','3A':'C','SL':'S','CC':'D','EC':'E' }[classCode] || 'G';
  return coach + Math.floor(Math.random() * 72 + 1);
}

// ── BOOK TICKET ───────────────────────────────────────────────
const bookTicket = (req, res) => {
  const { user_id, train_id, class_code, journey_date, source, destination, passengers } = req.body;

  if (!user_id || !train_id || !class_code || !journey_date || !passengers || !passengers.length)
    return res.json({ success: false, message: 'All fields are required' });

  // Get fare_per_km and distance
  db.query(
    `SELECT sc.fare_per_km, t.distance_km
     FROM seat_classes sc JOIN trains t ON t.id = sc.train_id
     WHERE sc.train_id=? AND sc.class_code=?`,
    [train_id, class_code],
    (err, rows) => {
      if (err || !rows.length)
        return res.json({ success: false, message: 'Selected class not available for this train' });

      const { fare_per_km, distance_km } = rows[0];
      const base       = Math.round(fare_per_km * distance_km);
      const per_person = Math.round(base * 1.05 + 15);   // 5% GST + ₹15 reservation
      const total_fare = per_person * passengers.length;
      const pnr        = generatePNR();

      db.query(
        `INSERT INTO tickets (pnr,user_id,train_id,class_code,journey_date,source,destination,total_fare)
         VALUES (?,?,?,?,?,?,?,?)`,
        [pnr, user_id, train_id, class_code, journey_date, source, destination, total_fare],
        (err2, result) => {
          if (err2) return res.json({ success: false, message: 'Booking failed: ' + err2.message });

          const ticket_id = result.insertId;
          const paxRows   = passengers.map(p => [
            ticket_id, p.name, p.age, p.gender, p.berth_pref || 'No Preference', generateSeat(class_code)
          ]);

          db.query(
            'INSERT INTO passengers (ticket_id,name,age,gender,berth_pref,seat_no) VALUES ?',
            [paxRows],
            (err3) => {
              if (err3) return res.json({ success: false, message: 'Passenger save failed: ' + err3.message });
              res.json({ success: true, message: 'Ticket booked!', pnr, ticket_id, total_fare, per_person });
            }
          );
        }
      );
    }
  );
};

// ── PNR STATUS ─────────────────────────────────────────────────
const getPNRStatus = (req, res) => {
  db.query(
    `SELECT t.*, tr.name AS train_name, tr.train_number, tr.type AS train_type,
            tr.departure, tr.arrival, tr.source AS tr_source, tr.destination AS tr_dest,
            u.name AS passenger_name
     FROM tickets t
     JOIN trains tr ON tr.id = t.train_id
     JOIN users u   ON u.id  = t.user_id
     WHERE t.pnr = ?`,
    [req.params.pnr],
    (err, rows) => {
      if (err || !rows.length) return res.json({ success: false, message: 'PNR not found. Please check the number.' });
      db.query('SELECT * FROM passengers WHERE ticket_id=?', [rows[0].id], (e2, pax) => {
        res.json({ success: true, ticket: rows[0], passengers: pax || [] });
      });
    }
  );
};

// ── MY TICKETS ─────────────────────────────────────────────────
const getMyTickets = (req, res) => {
  db.query(
    `SELECT t.*, tr.name AS train_name, tr.train_number, tr.type AS train_type,
            tr.departure, tr.arrival
     FROM tickets t
     JOIN trains tr ON tr.id = t.train_id
     WHERE t.user_id = ?
     ORDER BY t.booked_at DESC`,
    [req.params.userId],
    (err, tickets) => {
      if (err) return res.json({ success: false, message: err.message });
      if (!tickets.length) return res.json({ success: true, tickets: [] });

      const ids = tickets.map(t => t.id);
      db.query('SELECT * FROM passengers WHERE ticket_id IN (?)', [ids], (e2, pax) => {
        const result = tickets.map(t => ({
          ...t,
          passengers: (pax || []).filter(p => p.ticket_id === t.id)
        }));
        res.json({ success: true, tickets: result });
      });
    }
  );
};

// ── CANCEL TICKET ──────────────────────────────────────────────
const cancelTicket = (req, res) => {
  const { ticket_id, user_id } = req.body;
  db.query(
    `UPDATE tickets SET booking_status='Cancelled', payment_status='Refunded'
     WHERE id=? AND user_id=? AND booking_status='Confirmed'`,
    [ticket_id, user_id],
    (err, result) => {
      if (err)                       return res.json({ success: false, message: err.message });
      if (!result.affectedRows)      return res.json({ success: false, message: 'Ticket not found or already cancelled' });
      res.json({ success: true, message: 'Ticket cancelled. Refund will be processed in 5–7 business days.' });
    }
  );
};

module.exports = { bookTicket, getPNRStatus, getMyTickets, cancelTicket };
