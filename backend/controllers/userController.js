const db = require('../config/db');

const register = (req, res) => {
  const { name, email, password, phone, gender, dob } = req.body;
  if (!name || !email || !password)
    return res.json({ success: false, message: 'Name, email & password are required' });

  db.query(
    'INSERT INTO users (name,email,password,phone,gender,dob) VALUES (?,?,?,?,?,?)',
    [name, email, password, phone || null, gender || 'Male', dob || null],
    (err) => {
      if (err) {
        if (err.code === 'ER_DUP_ENTRY')
          return res.json({ success: false, message: 'Email already registered' });
        return res.json({ success: false, message: 'Registration failed: ' + err.message });
      }
      res.json({ success: true, message: 'Account created successfully! Please login.' });
    }
  );
};

const login = (req, res) => {
  const { email, password } = req.body;
  if (!email || !password)
    return res.json({ success: false, message: 'Email and password required' });

  db.query(
    'SELECT id,name,email,phone,gender FROM users WHERE email=? AND password=?',
    [email, password],
    (err, rows) => {
      if (err) return res.json({ success: false, message: 'Login error' });
      if (!rows.length) return res.json({ success: false, message: 'Invalid email or password' });
      res.json({ success: true, user: rows[0] });
    }
  );
};

const getProfile = (req, res) => {
  db.query(
    'SELECT id,name,email,phone,gender,dob,created_at FROM users WHERE id=?',
    [req.params.id],
    (err, rows) => {
      if (err || !rows.length) return res.json({ success: false, message: 'User not found' });
      res.json({ success: true, user: rows[0] });
    }
  );
};

const updateProfile = (req, res) => {
  const { name, phone, gender, dob } = req.body;
  db.query(
    'UPDATE users SET name=?,phone=?,gender=?,dob=? WHERE id=?',
    [name, phone, gender, dob, req.params.id],
    (err) => {
      if (err) return res.json({ success: false, message: 'Update failed' });
      res.json({ success: true, message: 'Profile updated successfully!' });
    }
  );
};

module.exports = { register, login, getProfile, updateProfile };
