# 🚂 RailBook Pro — Full Railway Reservation System

A full-featured railway ticket booking system with real IRCTC-style features.

## 📁 Folder Structure

```
railbook-pro/
├── backend/
│   ├── config/db.js              ← MySQL connection
│   ├── controllers/
│   │   ├── userController.js     ← Register, Login, Profile
│   │   ├── trainController.js    ← Search, All Trains, By ID
│   │   └── ticketController.js   ← Book, PNR, My Tickets, Cancel
│   ├── routes/index.js           ← All API routes
│   ├── server.js                 ← Express entry point
│   └── package.json
├── frontend/
│   ├── login.html                ← Split-panel login
│   ├── register.html             ← Registration with DOB/gender
│   ├── dashboard.html            ← Hero search + stats + recent bookings
│   ├── trains.html               ← Search trains + class fare display
│   ├── book.html                 ← 3-step booking wizard
│   ├── mytickets.html            ← Tabs: All/Confirmed/Cancelled
│   ├── pnr.html                  ← PNR status checker
│   ├── profile.html              ← Edit profile + account stats
│   ├── utils.js                  ← Shared helpers (API, formatters)
│   └── style.css                 ← Full production stylesheet
└── database/
    └── schema.sql                ← 20 trains + all seat classes
```

## ✨ Features

| Feature | Details |
|---------|---------|
| 🚆 20 Trains | Rajdhani, Shatabdi, Vande Bharat, Duronto, Express, Mail |
| 🎫 Seat Classes | 1A, 2A, 3A, SL, CC, EC with real fare calculation |
| 👥 Multi-Passenger | Book up to 6 passengers per ticket |
| 🔢 PNR System | Auto-generated 10-digit PNR per booking |
| 💰 Fare Calc | Base fare + 5% GST + ₹15 reservation charge |
| 💺 Berth Preference | Lower/Middle/Upper/Side Lower/Side Upper |
| ❌ Cancellation | Cancel ticket with refund tracking |
| 📋 Booking History | Tabs: All / Confirmed / Cancelled / Waitlist |
| 👤 Profile | Edit name, phone, gender, DOB + spending stats |
| 🔍 PNR Status | Check any PNR with full passenger details |

## 🚀 Setup (Step by Step)

### Step 1: MySQL Database

Open MySQL Workbench or terminal and run:
```sql
source C:/path/to/railbook-pro/database/schema.sql
```

### Step 2: Configure DB Password

Open `backend/config/db.js` and set your MySQL password:
```js
password: '',   // ← add your password here
```

### Step 3: Install & Run Backend

```bash
cd railbook-pro/backend
npm install
node server.js
```

Expected output:
```
✅ MySQL Connected → railbook_pro
🚀 Server → http://localhost:3000
```

### Step 4: Open Frontend

Open `frontend/login.html` in browser (use VS Code Live Server or double-click).

Register a new account → Login → Start booking!

## 🔗 API Reference

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/register | Register user |
| POST | /api/login | Login |
| GET | /api/profile/:id | Get profile |
| PUT | /api/profile/:id | Update profile |
| GET | /api/trains | All trains |
| GET | /api/trains/search?from=&to=&date= | Search trains |
| GET | /api/trains/:id | Train + classes |
| POST | /api/book-ticket | Book ticket |
| GET | /api/pnr/:pnr | PNR status |
| GET | /api/my-tickets/:userId | My tickets |
| POST | /api/cancel-ticket | Cancel ticket |
