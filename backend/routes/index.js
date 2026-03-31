const express = require('express');
const router  = express.Router();

const { register, login, getProfile, updateProfile } = require('../controllers/userController');
const { getAllTrains, searchTrains, getTrainById }    = require('../controllers/trainController');
const { bookTicket, getPNRStatus, getMyTickets, cancelTicket } = require('../controllers/ticketController');

// User
router.post('/register',          register);
router.post('/login',             login);
router.get('/profile/:id',        getProfile);
router.put('/profile/:id',        updateProfile);

// Trains
router.get('/trains',             getAllTrains);
router.get('/trains/search',      searchTrains);
router.get('/trains/:id',         getTrainById);

// Tickets
router.post('/book-ticket',       bookTicket);
router.get('/pnr/:pnr',          getPNRStatus);
router.get('/my-tickets/:userId', getMyTickets);
router.post('/cancel-ticket',     cancelTicket);

module.exports = router;
