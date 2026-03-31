-- ============================================================
--  RailBook Pro — COMPLETE FINAL DATABASE SCHEMA v3.0
--  230+ trains, every major city connected to every other city
--  Run this file FRESH — drops and recreates everything clean
-- ============================================================

DROP DATABASE IF EXISTS railbook_pro;
CREATE DATABASE railbook_pro;
USE railbook_pro;

-- ─── TABLES ──────────────────────────────────────────────────
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL, password VARCHAR(255) NOT NULL,
  phone VARCHAR(15), gender ENUM('Male','Female','Other') DEFAULT 'Male',
  dob DATE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE trains (
  id INT AUTO_INCREMENT PRIMARY KEY, train_number VARCHAR(10) UNIQUE NOT NULL,
  name VARCHAR(120) NOT NULL, type VARCHAR(30) NOT NULL,
  source VARCHAR(100) NOT NULL, destination VARCHAR(100) NOT NULL,
  departure TIME NOT NULL, arrival TIME NOT NULL, duration VARCHAR(20) NOT NULL,
  distance_km INT NOT NULL, runs_on VARCHAR(60) DEFAULT 'Mon,Tue,Wed,Thu,Fri,Sat,Sun',
  status ENUM('Active','Cancelled','Delayed') DEFAULT 'Active'
);

CREATE TABLE seat_classes (
  id INT AUTO_INCREMENT PRIMARY KEY, train_id INT NOT NULL,
  class_code VARCHAR(5) NOT NULL, class_name VARCHAR(60) NOT NULL,
  total_seats INT NOT NULL, fare_per_km DECIMAL(6,2) NOT NULL,
  FOREIGN KEY (train_id) REFERENCES trains(id) ON DELETE CASCADE
);

CREATE TABLE tickets (
  id INT AUTO_INCREMENT PRIMARY KEY, pnr VARCHAR(10) UNIQUE NOT NULL,
  user_id INT NOT NULL, train_id INT NOT NULL, class_code VARCHAR(5) NOT NULL,
  journey_date DATE NOT NULL, source VARCHAR(100) NOT NULL, destination VARCHAR(100) NOT NULL,
  total_fare DECIMAL(10,2) NOT NULL,
  booking_status ENUM('Confirmed','Cancelled','Waitlist') DEFAULT 'Confirmed',
  payment_status ENUM('Paid','Refunded','Pending') DEFAULT 'Paid',
  booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id), FOREIGN KEY (train_id) REFERENCES trains(id)
);

CREATE TABLE passengers (
  id INT AUTO_INCREMENT PRIMARY KEY, ticket_id INT NOT NULL,
  name VARCHAR(100) NOT NULL, age INT NOT NULL,
  gender ENUM('Male','Female','Other') NOT NULL,
  berth_pref VARCHAR(30) DEFAULT 'No Preference',
  seat_no VARCHAR(10), status ENUM('Confirmed','RAC','Waitlist') DEFAULT 'Confirmed',
  FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE
);

-- ============================================================
--  ALL TRAINS (230+) — Every City to Every City
-- ============================================================
INSERT INTO trains (train_number,name,type,source,destination,departure,arrival,duration,distance_km,runs_on) VALUES
-- ── ORIGINAL CLASSICS ────────────────────────────────────────
('12301','Howrah Rajdhani Express','Rajdhani','Kolkata Howrah','New Delhi','16:55','10:00','17h 5m',1447,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('12951','Mumbai Rajdhani','Rajdhani','Mumbai Central','New Delhi','17:00','08:35','15h 35m',1384,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('12953','August Kranti Rajdhani','Rajdhani','Mumbai Central','Hazrat Nizamuddin','17:40','10:55','17h 15m',1386,'Mon,Wed,Thu,Sat'),
('12431','Trivandrum Rajdhani','Rajdhani','Hazrat Nizamuddin','Thiruvananthapuram','11:05','16:30','29h 25m',3112,'Tue,Wed,Fri,Sun'),
('22691','Rajdhani Bangalore Express','Rajdhani','KSR Bengaluru','Hazrat Nizamuddin','20:00','05:55','33h 55m',2361,'Tue,Thu,Sun'),
('12002','New Delhi Shatabdi','Shatabdi','New Delhi','Bhopal','06:00','13:55','7h 55m',704,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('12009','Mumbai Shatabdi','Shatabdi','Mumbai Central','Ahmedabad','06:25','12:55','6h 30m',492,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('22439','Vande Bharat Delhi-Varanasi','Vande Bharat','New Delhi','Varanasi','06:00','14:00','8h 0m',759,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('22119','Vande Bharat Mumbai-Solapur','Vande Bharat','Mumbai CST','Solapur','05:50','11:30','5h 40m',450,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('12213','Yesvantpur Duronto','Duronto','Yesvantpur','Kolkata Howrah','21:30','06:00','32h 30m',1953,'Mon,Wed,Fri'),
('12285','Nizamuddin Duronto','Duronto','Hazrat Nizamuddin','Ernakulam','11:05','20:30','33h 25m',2500,'Tue,Thu,Sat'),
('12259','Sealdah Duronto','Duronto','Sealdah','New Delhi','20:05','12:25','16h 20m',1455,'Mon,Thu,Sat'),
('12627','Karnataka Express','Express','New Delhi','KSR Bengaluru','21:30','05:45','32h 15m',2361,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11057','Amritsar Mail','Mail','Mumbai CST','Amritsar','18:40','02:20','31h 40m',1931,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('12123','Deccan Queen','Superfast','Pune','Mumbai CST','07:15','10:25','3h 10m',192,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('12615','Grand Trunk Express','Express','New Delhi','Chennai Central','18:35','06:30','35h 55m',2175,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('12701','Hussain Sagar Express','Express','Hyderabad','Mumbai CST','21:45','07:05','33h 20m',1758,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('12903','Golden Temple Mail','Mail','Mumbai Central','Amritsar','21:30','06:00','32h 30m',1930,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('12649','Karnataka Sampark Kranti','Superfast','Hazrat Nizamuddin','KSR Bengaluru','21:00','05:35','32h 35m',2361,'Tue,Fri,Sun'),
('20902','Vande Bharat Pune-Hubballi','Vande Bharat','Pune','Hubballi','05:40','14:30','8h 50m',543,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
-- ── MUMBAI CST / CENTRAL ↔ ALL CITIES ────────────────────────
('11001','Mumbai CST Pune Intercity','Superfast','Mumbai CST','Pune','06:10','08:55','2h 45m',192,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11002','Pune Mumbai CST Intercity','Superfast','Pune','Mumbai CST','17:15','20:05','2h 50m',192,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11003','Deccan Express','Express','Mumbai CST','Pune','17:10','20:25','3h 15m',192,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11004','Deccan Express Return','Express','Pune','Mumbai CST','07:15','10:30','3h 15m',192,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11005','Mumbai Delhi Rajdhani','Rajdhani','Mumbai Central','New Delhi','16:35','08:35','16h 0m',1384,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11006','Delhi Mumbai Rajdhani','Rajdhani','New Delhi','Mumbai Central','16:25','09:30','17h 5m',1384,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11007','Mumbai Bangalore Udyan','Express','Mumbai CST','KSR Bengaluru','08:05','04:10','20h 5m',1014,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11008','Bangalore Mumbai Udyan','Express','KSR Bengaluru','Mumbai CST','20:15','16:30','20h 15m',1014,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11009','Mumbai Hyderabad Express','Express','Mumbai CST','Hyderabad','21:30','13:00','15h 30m',711,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11010','Hyderabad Mumbai Express','Express','Hyderabad','Mumbai CST','17:10','07:55','14h 45m',711,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11011','Mumbai Chennai Express','Express','Mumbai CST','Chennai Central','23:15','03:45','28h 30m',1279,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11012','Chennai Mumbai Express','Express','Chennai Central','Mumbai CST','22:45','03:15','28h 30m',1279,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11013','Mumbai Kolkata Mail','Mail','Mumbai CST','Kolkata Howrah','21:05','01:45','28h 40m',1968,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11014','Kolkata Mumbai Mail','Mail','Kolkata Howrah','Mumbai CST','19:35','23:55','28h 20m',1968,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11015','Mumbai Ahmedabad Express','Express','Mumbai Central','Ahmedabad','17:00','21:35','4h 35m',491,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11016','Ahmedabad Mumbai Express','Express','Ahmedabad','Mumbai Central','06:05','10:45','4h 40m',491,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11017','Mumbai Nagpur Vidarbha','Express','Mumbai CST','Nagpur','22:05','12:00','13h 55m',836,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11018','Nagpur Mumbai Vidarbha','Express','Nagpur','Mumbai CST','14:10','04:15','14h 5m',836,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11019','Mumbai Surat Express','Superfast','Mumbai Central','Surat','06:20','09:45','3h 25m',263,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11020','Surat Mumbai Express','Superfast','Surat','Mumbai Central','18:10','21:30','3h 20m',263,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11021','Mumbai Jaipur Express','Superfast','Mumbai Central','Jaipur','22:50','13:00','14h 10m',1150,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11022','Jaipur Mumbai Express','Superfast','Jaipur','Mumbai Central','15:30','05:40','14h 10m',1150,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11023','Mumbai Lucknow Express','Express','Mumbai CST','Lucknow','20:00','15:30','19h 30m',1400,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11024','Lucknow Mumbai Express','Express','Lucknow','Mumbai CST','17:00','13:00','20h 0m',1400,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11025','Mumbai Kochi Express','Express','Mumbai Central','Ernakulam','10:35','14:35','28h 0m',1387,'Mon,Wed,Fri'),
('11026','Kochi Mumbai Express','Express','Ernakulam','Mumbai Central','11:00','16:00','29h 0m',1387,'Tue,Thu,Sat'),
('11027','Mumbai Bhopal Express','Express','Mumbai CST','Bhopal','22:30','10:30','12h 0m',780,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11028','Bhopal Mumbai Express','Express','Bhopal','Mumbai CST','21:20','09:30','12h 10m',780,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11029','Mumbai Coimbatore Express','Express','Mumbai CST','Coimbatore','23:15','08:30','33h 15m',1325,'Mon,Wed,Fri'),
('11030','Coimbatore Mumbai Express','Express','Coimbatore','Mumbai CST','20:30','06:00','33h 30m',1325,'Tue,Thu,Sat'),
('11031','Mumbai Visakhapatnam Express','Express','Mumbai CST','Visakhapatnam','06:55','10:35','27h 40m',1289,'Mon,Thu'),
('11032','Visakhapatnam Mumbai Express','Express','Visakhapatnam','Mumbai CST','12:20','16:25','28h 5m',1289,'Tue,Fri'),
('11033','Mumbai Patna Express','Express','Mumbai CST','Patna','08:00','12:05','28h 5m',1922,'Mon,Thu'),
('11034','Patna Mumbai Express','Express','Patna','Mumbai CST','17:30','22:00','28h 30m',1922,'Tue,Fri'),
('11035','Mumbai Vadodara Express','Superfast','Mumbai Central','Vadodara','09:00','12:45','3h 45m',390,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11036','Vadodara Mumbai Express','Superfast','Vadodara','Mumbai Central','17:45','21:30','3h 45m',390,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11037','Mumbai Guwahati Express','Express','Mumbai CST','Guwahati','12:40','06:35','65h 55m',2860,'Mon,Fri'),
('11038','Guwahati Mumbai Express','Express','Guwahati','Mumbai CST','13:30','09:30','64h 0m',2860,'Wed,Sat'),
('11039','Mumbai Bhubaneswar Express','Express','Mumbai CST','Bhubaneswar','21:15','12:00','38h 45m',1757,'Mon,Thu'),
('11040','Bhubaneswar Mumbai Express','Express','Bhubaneswar','Mumbai CST','14:30','07:00','40h 30m',1757,'Tue,Fri'),
('11041','Mumbai Chandigarh Express','Express','Mumbai Central','Chandigarh','23:15','22:30','23h 15m',1630,'Mon,Thu'),
('11042','Chandigarh Mumbai Express','Express','Chandigarh','Mumbai Central','06:00','05:30','23h 30m',1630,'Tue,Fri'),
('11043','Mumbai Varanasi Express','Express','Mumbai CST','Varanasi','14:00','17:30','27h 30m',1510,'Mon,Wed,Sat'),
('11044','Varanasi Mumbai Express','Express','Varanasi','Mumbai CST','11:00','14:30','27h 30m',1510,'Tue,Thu,Sun'),
('11045','Mumbai Amritsar Express','Mail','Mumbai Central','Amritsar','21:30','06:00','32h 30m',1930,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('11046','Amritsar Mumbai Express','Mail','Amritsar','Mumbai Central','15:55','21:55','30h 0m',1931,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
-- ── PUNE ↔ ALL CITIES ────────────────────────────────────────
('13001','Pune Delhi Duronto','Duronto','Pune','Hazrat Nizamuddin','11:00','07:15','20h 15m',1509,'Mon,Fri'),
('13002','Delhi Pune Duronto','Duronto','Hazrat Nizamuddin','Pune','08:50','05:05','20h 15m',1509,'Tue,Sat'),
('13003','Pune Bangalore Express','Express','Pune','KSR Bengaluru','11:15','07:45','20h 30m',843,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('13004','Bangalore Pune Express','Express','KSR Bengaluru','Pune','20:30','17:00','20h 30m',843,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('13005','Pune Hyderabad Express','Express','Pune','Hyderabad','06:15','17:30','11h 15m',560,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('13006','Hyderabad Pune Express','Express','Hyderabad','Pune','19:20','07:15','11h 55m',560,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('13007','Pune Chennai Express','Express','Pune','Chennai Central','11:30','14:00','26h 30m',1130,'Mon,Wed,Fri'),
('13008','Chennai Pune Express','Express','Chennai Central','Pune','15:10','18:30','27h 20m',1130,'Tue,Thu,Sat'),
('13009','Pune Kolkata Express','Express','Pune','Kolkata Howrah','14:20','22:40','32h 20m',1931,'Mon,Thu'),
('13010','Kolkata Pune Express','Express','Kolkata Howrah','Pune','22:55','07:05','32h 10m',1931,'Tue,Fri'),
('13011','Pune Ahmedabad Express','Superfast','Pune','Ahmedabad','09:55','19:00','9h 5m',660,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('13012','Ahmedabad Pune Express','Superfast','Ahmedabad','Pune','19:45','05:00','9h 15m',660,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('13013','Pune Nagpur Express','Superfast','Pune','Nagpur','21:30','06:10','8h 40m',680,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('13014','Nagpur Pune Express','Superfast','Nagpur','Pune','21:00','05:55','8h 55m',680,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('13015','Pune Lucknow Express','Express','Pune','Lucknow','08:00','09:30','25h 30m',1600,'Mon,Thu'),
('13016','Lucknow Pune Express','Express','Lucknow','Pune','19:30','22:00','26h 30m',1600,'Tue,Fri'),
('13017','Pune Amritsar Express','Express','Pune','Amritsar','14:30','21:45','31h 15m',2000,'Mon,Fri'),
('13018','Amritsar Pune Express','Express','Amritsar','Pune','09:15','18:00','32h 45m',2000,'Wed,Sun'),
('13019','Pune Bhopal Express','Express','Pune','Bhopal','20:15','09:00','12h 45m',826,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('13020','Bhopal Pune Express','Express','Bhopal','Pune','22:40','11:30','12h 50m',826,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('13021','Pune Coimbatore Express','Express','Pune','Coimbatore','17:00','21:00','28h 0m',1190,'Mon,Wed,Sat'),
('13022','Coimbatore Pune Express','Express','Coimbatore','Pune','06:45','11:00','28h 15m',1190,'Tue,Thu,Sun'),
('13023','Pune Jaipur Express','Superfast','Pune','Jaipur','21:30','15:45','18h 15m',1250,'Mon,Fri'),
('13024','Jaipur Pune Express','Superfast','Jaipur','Pune','18:00','12:30','18h 30m',1250,'Tue,Sat'),
('13025','Pune Kochi Express','Express','Pune','Ernakulam','11:00','18:30','31h 30m',1218,'Mon,Thu'),
('13026','Kochi Pune Express','Express','Ernakulam','Pune','14:30','22:00','31h 30m',1218,'Tue,Fri'),
('13027','Pune Patna Express','Express','Pune','Patna','22:10','09:30','35h 20m',1985,'Mon,Fri'),
('13028','Patna Pune Express','Express','Patna','Pune','20:00','07:30','35h 30m',1985,'Wed,Sun'),
('13029','Pune Surat Express','Superfast','Pune','Surat','07:30','12:30','5h 0m',348,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('13030','Surat Pune Express','Superfast','Surat','Pune','15:00','20:00','5h 0m',348,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('13031','Pune Visakhapatnam Express','Express','Pune','Visakhapatnam','20:00','21:00','25h 0m',1180,'Mon,Thu'),
('13032','Visakhapatnam Pune Express','Express','Visakhapatnam','Pune','16:00','17:00','25h 0m',1180,'Tue,Fri'),
('13033','Pune Chandigarh Express','Express','Pune','Chandigarh','12:00','13:00','25h 0m',1700,'Mon,Thu'),
('13034','Chandigarh Pune Express','Express','Chandigarh','Pune','14:00','15:00','25h 0m',1700,'Tue,Fri'),
('13035','Pune Varanasi Express','Express','Pune','Varanasi','22:00','07:00','33h 0m',1560,'Mon,Thu'),
('13036','Varanasi Pune Express','Express','Varanasi','Pune','20:00','05:00','33h 0m',1560,'Tue,Fri'),
('13037','Pune Guwahati Express','Express','Pune','Guwahati','08:00','12:00','52h 0m',2500,'Mon,Fri'),
('13038','Guwahati Pune Express','Express','Guwahati','Pune','16:00','20:00','52h 0m',2500,'Wed,Sun'),
-- ── DELHI ↔ ALL CITIES ───────────────────────────────────────
('14001','Delhi Bangalore Rajdhani','Rajdhani','Hazrat Nizamuddin','KSR Bengaluru','21:00','05:55','32h 55m',2361,'Mon,Wed,Fri'),
('14002','Bangalore Delhi Rajdhani','Rajdhani','KSR Bengaluru','Hazrat Nizamuddin','20:00','05:55','33h 55m',2361,'Tue,Thu,Sun'),
('14003','Delhi Hyderabad Dakshin','Superfast','Hazrat Nizamuddin','Hyderabad','22:30','16:45','18h 15m',1661,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14004','Hyderabad Delhi Dakshin','Superfast','Hyderabad','Hazrat Nizamuddin','21:15','17:05','19h 50m',1661,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14005','Delhi Chennai Grand Trunk','Express','New Delhi','Chennai Central','18:35','06:30','35h 55m',2175,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14006','Chennai Delhi Grand Trunk','Express','Chennai Central','New Delhi','19:00','06:30','35h 30m',2175,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14007','Delhi Kolkata Rajdhani','Rajdhani','New Delhi','Kolkata Howrah','16:55','10:00','17h 5m',1447,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14008','Kolkata Delhi Rajdhani','Rajdhani','Kolkata Howrah','New Delhi','16:10','09:55','17h 45m',1447,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14009','Delhi Ahmedabad Superfast','Superfast','New Delhi','Ahmedabad','06:10','16:25','10h 15m',934,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14010','Ahmedabad Delhi Superfast','Superfast','Ahmedabad','New Delhi','16:35','06:45','14h 10m',934,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14011','Delhi Jaipur Intercity','Superfast','New Delhi','Jaipur','06:05','10:35','4h 30m',308,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14012','Jaipur Delhi Intercity','Superfast','Jaipur','New Delhi','14:30','19:00','4h 30m',308,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14013','Delhi Lucknow Shatabdi','Shatabdi','New Delhi','Lucknow','06:10','12:30','6h 20m',512,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14014','Lucknow Delhi Shatabdi','Shatabdi','Lucknow','New Delhi','14:40','21:00','6h 20m',512,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14015','Delhi Patna Rajdhani','Rajdhani','New Delhi','Patna','18:25','05:10','10h 45m',991,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14016','Patna Delhi Rajdhani','Rajdhani','Patna','New Delhi','19:25','06:00','10h 35m',991,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14017','Delhi Bhopal Shatabdi','Shatabdi','New Delhi','Bhopal','06:00','13:55','7h 55m',704,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14018','Bhopal Delhi Shatabdi','Shatabdi','Bhopal','New Delhi','14:30','22:30','8h 0m',704,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14019','Delhi Nagpur Express','Express','New Delhi','Nagpur','22:20','14:00','15h 40m',1092,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14020','Nagpur Delhi Express','Express','Nagpur','New Delhi','16:05','07:45','15h 40m',1092,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14021','Delhi Varanasi Vande Bharat','Vande Bharat','New Delhi','Varanasi','06:00','14:00','8h 0m',759,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14022','Varanasi Delhi Vande Bharat','Vande Bharat','Varanasi','New Delhi','15:00','23:00','8h 0m',759,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14023','Delhi Amritsar Shatabdi','Shatabdi','New Delhi','Amritsar','16:30','22:20','5h 50m',449,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14024','Amritsar Delhi Shatabdi','Shatabdi','Amritsar','New Delhi','05:15','11:00','5h 45m',449,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14025','Delhi Chandigarh Shatabdi','Shatabdi','New Delhi','Chandigarh','07:40','11:40','4h 0m',248,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14026','Chandigarh Delhi Shatabdi','Shatabdi','Chandigarh','New Delhi','16:30','20:30','4h 0m',248,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14027','Delhi Kochi Rajdhani','Rajdhani','Hazrat Nizamuddin','Ernakulam','11:05','20:30','33h 25m',2640,'Tue,Thu,Sat'),
('14028','Kochi Delhi Rajdhani','Rajdhani','Ernakulam','Hazrat Nizamuddin','19:15','06:30','35h 15m',2640,'Mon,Wed,Fri'),
('14029','Delhi Coimbatore Express','Express','New Delhi','Coimbatore','22:30','09:15','34h 45m',2197,'Mon,Thu'),
('14030','Coimbatore Delhi Express','Express','Coimbatore','New Delhi','21:00','08:00','35h 0m',2197,'Tue,Fri'),
('14031','Delhi Surat Express','Superfast','New Delhi','Surat','22:15','14:00','15h 45m',1200,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14032','Surat Delhi Express','Superfast','Surat','New Delhi','15:00','06:45','15h 45m',1200,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14033','Delhi Visakhapatnam Express','Express','New Delhi','Visakhapatnam','22:30','20:00','21h 30m',1800,'Mon,Thu'),
('14034','Visakhapatnam Delhi Express','Express','Visakhapatnam','New Delhi','21:00','18:30','21h 30m',1800,'Tue,Fri'),
('14035','Delhi Guwahati Rajdhani','Rajdhani','New Delhi','Guwahati','21:30','05:05','31h 35m',1906,'Mon,Wed,Fri'),
('14036','Guwahati Delhi Rajdhani','Rajdhani','Guwahati','New Delhi','13:05','09:55','44h 50m',2824,'Tue,Thu,Sat'),
('14037','Delhi Bhubaneswar Rajdhani','Rajdhani','New Delhi','Bhubaneswar','22:25','08:20','33h 55m',1765,'Mon,Wed,Fri'),
('14038','Bhubaneswar Delhi Rajdhani','Rajdhani','Bhubaneswar','New Delhi','14:35','05:50','39h 15m',1765,'Tue,Thu,Sat'),
('14039','Delhi Vadodara Express','Superfast','New Delhi','Vadodara','21:30','11:00','13h 30m',1073,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('14040','Vadodara Delhi Express','Superfast','Vadodara','New Delhi','12:00','01:30','13h 30m',1073,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
-- ── BANGALORE ↔ ALL CITIES ───────────────────────────────────
('15001','Bangalore Hyderabad Express','Superfast','KSR Bengaluru','Hyderabad','23:25','06:30','7h 5m',576,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('15002','Hyderabad Bangalore Express','Superfast','Hyderabad','KSR Bengaluru','22:05','05:15','7h 10m',576,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('15003','Bangalore Chennai Shatabdi','Shatabdi','KSR Bengaluru','Chennai Central','06:00','11:00','5h 0m',362,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('15004','Chennai Bangalore Shatabdi','Shatabdi','Chennai Central','KSR Bengaluru','06:00','11:00','5h 0m',362,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('15005','Bangalore Kolkata Express','Express','KSR Bengaluru','Kolkata Howrah','22:30','06:30','32h 0m',1880,'Mon,Wed,Sat'),
('15006','Kolkata Bangalore Express','Express','Kolkata Howrah','KSR Bengaluru','21:00','05:30','32h 30m',1880,'Tue,Thu,Sun'),
('15007','Bangalore Ahmedabad Express','Express','KSR Bengaluru','Ahmedabad','22:40','10:30','35h 50m',1887,'Mon,Thu'),
('15008','Ahmedabad Bangalore Express','Express','Ahmedabad','KSR Bengaluru','20:15','08:00','35h 45m',1887,'Tue,Fri'),
('15009','Bangalore Jaipur Express','Express','KSR Bengaluru','Jaipur','20:45','14:00','41h 15m',2404,'Mon,Thu'),
('15010','Jaipur Bangalore Express','Express','Jaipur','KSR Bengaluru','14:30','07:00','40h 30m',2404,'Tue,Fri'),
('15011','Bangalore Lucknow Express','Express','KSR Bengaluru','Lucknow','06:55','14:00','31h 5m',2327,'Mon,Thu'),
('15012','Lucknow Bangalore Express','Express','Lucknow','KSR Bengaluru','14:00','21:00','31h 0m',2327,'Tue,Fri'),
('15013','Bangalore Nagpur Express','Express','KSR Bengaluru','Nagpur','22:50','18:00','19h 10m',1032,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('15014','Nagpur Bangalore Express','Express','Nagpur','KSR Bengaluru','21:00','16:30','19h 30m',1032,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('15015','Bangalore Kochi Express','Express','KSR Bengaluru','Ernakulam','21:30','05:30','8h 0m',595,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('15016','Kochi Bangalore Express','Express','Ernakulam','KSR Bengaluru','22:00','06:00','8h 0m',595,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('15017','Bangalore Coimbatore Express','Superfast','KSR Bengaluru','Coimbatore','22:00','05:00','7h 0m',386,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('15018','Coimbatore Bangalore Express','Superfast','Coimbatore','KSR Bengaluru','21:30','04:30','7h 0m',386,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('15019','Bangalore Visakhapatnam Express','Express','KSR Bengaluru','Visakhapatnam','21:30','14:30','17h 0m',1023,'Mon,Thu'),
('15020','Visakhapatnam Bangalore Express','Express','Visakhapatnam','KSR Bengaluru','12:00','05:00','17h 0m',1023,'Tue,Fri'),
('15021','Bangalore Patna Express','Express','KSR Bengaluru','Patna','06:15','22:00','39h 45m',2200,'Mon,Fri'),
('15022','Patna Bangalore Express','Express','Patna','KSR Bengaluru','20:30','12:00','39h 30m',2200,'Wed,Sun'),
('15023','Bangalore Bhubaneswar Express','Express','KSR Bengaluru','Bhubaneswar','07:00','08:00','25h 0m',1540,'Mon,Thu'),
('15024','Bhubaneswar Bangalore Express','Express','Bhubaneswar','KSR Bengaluru','21:00','22:00','25h 0m',1540,'Tue,Fri'),
('15025','Bangalore Guwahati Express','Express','KSR Bengaluru','Guwahati','22:00','12:00','62h 0m',2890,'Mon,Fri'),
('15026','Guwahati Bangalore Express','Express','Guwahati','KSR Bengaluru','20:00','10:00','62h 0m',2890,'Wed,Sun'),
('15027','Bangalore Bhopal Express','Express','KSR Bengaluru','Bhopal','22:00','15:00','41h 0m',1560,'Mon,Fri'),
('15028','Bhopal Bangalore Express','Express','Bhopal','KSR Bengaluru','17:00','10:00','41h 0m',1560,'Wed,Sun'),
('15029','Bangalore Amritsar Express','Express','KSR Bengaluru','Amritsar','22:00','22:00','48h 0m',2830,'Mon,Fri'),
('15030','Amritsar Bangalore Express','Express','Amritsar','KSR Bengaluru','20:00','20:00','48h 0m',2830,'Wed,Sun'),
('15031','Bangalore Surat Express','Express','KSR Bengaluru','Surat','21:30','11:00','37h 30m',1690,'Mon,Thu'),
('15032','Surat Bangalore Express','Express','Surat','KSR Bengaluru','22:00','12:00','38h 0m',1690,'Tue,Fri'),
('15033','Bangalore Vadodara Express','Express','KSR Bengaluru','Vadodara','21:00','09:00','36h 0m',1780,'Mon,Thu'),
('15034','Vadodara Bangalore Express','Express','Vadodara','KSR Bengaluru','22:00','10:00','36h 0m',1780,'Tue,Fri'),
-- ── HYDERABAD ↔ ALL CITIES ───────────────────────────────────
('16001','Hyderabad Chennai Express','Superfast','Hyderabad','Chennai Central','18:45','05:00','10h 15m',626,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('16002','Chennai Hyderabad Express','Superfast','Chennai Central','Hyderabad','06:10','16:35','10h 25m',626,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('16003','Hyderabad Kolkata Falaknuma','Express','Hyderabad','Kolkata Howrah','18:15','07:30','37h 15m',1429,'Mon,Thu'),
('16004','Kolkata Hyderabad Falaknuma','Express','Kolkata Howrah','Hyderabad','22:20','11:45','37h 25m',1429,'Tue,Fri'),
('16005','Hyderabad Ahmedabad Express','Express','Hyderabad','Ahmedabad','17:30','12:30','19h 0m',1185,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('16006','Ahmedabad Hyderabad Express','Express','Ahmedabad','Hyderabad','14:00','09:15','19h 15m',1185,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('16007','Hyderabad Nagpur Express','Express','Hyderabad','Nagpur','19:15','07:00','11h 45m',504,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('16008','Nagpur Hyderabad Express','Express','Nagpur','Hyderabad','22:00','09:30','11h 30m',504,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('16009','Hyderabad Lucknow Express','Express','Hyderabad','Lucknow','11:45','13:00','25h 15m',1541,'Mon,Thu'),
('16010','Lucknow Hyderabad Express','Express','Lucknow','Hyderabad','14:30','16:00','25h 30m',1541,'Tue,Fri'),
('16011','Hyderabad Kochi Express','Express','Hyderabad','Ernakulam','18:00','09:30','15h 30m',1070,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('16012','Kochi Hyderabad Express','Express','Ernakulam','Hyderabad','15:00','07:00','16h 0m',1070,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('16013','Hyderabad Coimbatore Express','Express','Hyderabad','Coimbatore','17:45','08:30','14h 45m',905,'Mon,Wed,Fri'),
('16014','Coimbatore Hyderabad Express','Express','Coimbatore','Hyderabad','19:30','10:15','14h 45m',905,'Tue,Thu,Sat'),
('16015','Hyderabad Visakhapatnam Intercity','Superfast','Hyderabad','Visakhapatnam','06:30','14:30','8h 0m',627,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('16016','Visakhapatnam Hyderabad Intercity','Superfast','Visakhapatnam','Hyderabad','15:30','23:30','8h 0m',627,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('16017','Hyderabad Jaipur Express','Express','Hyderabad','Jaipur','20:30','07:00','34h 30m',1805,'Mon,Thu'),
('16018','Jaipur Hyderabad Express','Express','Jaipur','Hyderabad','21:00','07:00','34h 0m',1805,'Tue,Fri'),
('16019','Hyderabad Patna Express','Express','Hyderabad','Patna','22:00','16:00','42h 0m',1770,'Mon,Fri'),
('16020','Patna Hyderabad Express','Express','Patna','Hyderabad','18:00','12:00','42h 0m',1770,'Wed,Sun'),
('16021','Hyderabad Bhubaneswar Express','Express','Hyderabad','Bhubaneswar','22:00','16:00','18h 0m',1100,'Mon,Thu'),
('16022','Bhubaneswar Hyderabad Express','Express','Bhubaneswar','Hyderabad','17:00','11:00','18h 0m',1100,'Tue,Fri'),
('16023','Hyderabad Surat Express','Express','Hyderabad','Surat','21:00','12:00','15h 0m',890,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('16024','Surat Hyderabad Express','Express','Surat','Hyderabad','14:00','05:00','15h 0m',890,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('16025','Hyderabad Guwahati Express','Express','Hyderabad','Guwahati','22:00','18:00','68h 0m',2700,'Mon,Fri'),
('16026','Guwahati Hyderabad Express','Express','Guwahati','Hyderabad','20:00','16:00','68h 0m',2700,'Wed,Sun'),
-- ── CHENNAI ↔ ALL CITIES ─────────────────────────────────────
('17001','Chennai Kolkata Coromandel','Superfast','Chennai Central','Kolkata Howrah','08:45','08:45','24h 0m',1659,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('17002','Kolkata Chennai Coromandel','Superfast','Kolkata Howrah','Chennai Central','14:25','14:25','24h 0m',1659,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('17003','Chennai Ahmedabad Express','Express','Chennai Central','Ahmedabad','22:15','07:00','32h 45m',1918,'Mon,Thu'),
('17004','Ahmedabad Chennai Express','Express','Ahmedabad','Chennai Central','19:00','03:45','32h 45m',1918,'Tue,Fri'),
('17005','Chennai Nagpur Express','Express','Chennai Central','Nagpur','22:30','15:00','16h 30m',1165,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('17006','Nagpur Chennai Express','Express','Nagpur','Chennai Central','06:45','23:15','16h 30m',1165,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('17007','Chennai Kochi Express','Superfast','Chennai Central','Ernakulam','13:00','21:00','8h 0m',697,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('17008','Kochi Chennai Express','Superfast','Ernakulam','Chennai Central','20:15','04:15','8h 0m',697,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('17009','Chennai Coimbatore Shatabdi','Shatabdi','Chennai Central','Coimbatore','06:00','10:45','4h 45m',496,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('17010','Coimbatore Chennai Shatabdi','Shatabdi','Coimbatore','Chennai Central','13:35','18:20','4h 45m',496,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('17011','Chennai Visakhapatnam Express','Superfast','Chennai Central','Visakhapatnam','06:10','16:50','10h 40m',791,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('17012','Visakhapatnam Chennai Express','Superfast','Visakhapatnam','Chennai Central','18:45','05:20','10h 35m',791,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('17013','Chennai Jaipur Express','Express','Chennai Central','Jaipur','22:30','22:15','47h 45m',2387,'Mon,Fri'),
('17014','Jaipur Chennai Express','Express','Jaipur','Chennai Central','20:00','20:00','48h 0m',2387,'Wed,Sun'),
('17015','Chennai Lucknow Express','Express','Chennai Central','Lucknow','15:30','16:00','24h 30m',2097,'Mon,Thu'),
('17016','Lucknow Chennai Express','Express','Lucknow','Chennai Central','22:00','22:30','24h 30m',2097,'Tue,Fri'),
('17017','Chennai Bhubaneswar Express','Express','Chennai Central','Bhubaneswar','06:10','06:00','23h 50m',1340,'Mon,Wed,Fri'),
('17018','Bhubaneswar Chennai Express','Express','Bhubaneswar','Chennai Central','22:00','22:00','24h 0m',1340,'Tue,Thu,Sat'),
('17019','Chennai Guwahati Express','Express','Chennai Central','Guwahati','21:30','05:45','56h 15m',2900,'Mon,Thu'),
('17020','Guwahati Chennai Express','Express','Guwahati','Chennai Central','13:30','21:00','55h 30m',2900,'Tue,Fri'),
('17021','Chennai Patna Express','Express','Chennai Central','Patna','10:30','12:00','49h 30m',2100,'Mon,Fri'),
('17022','Patna Chennai Express','Express','Patna','Chennai Central','20:00','22:00','50h 0m',2100,'Wed,Sun'),
('17023','Chennai Bhopal Express','Express','Chennai Central','Bhopal','22:00','15:00','41h 0m',1500,'Mon,Thu'),
('17024','Bhopal Chennai Express','Express','Bhopal','Chennai Central','17:00','10:00','41h 0m',1500,'Tue,Fri'),
('17025','Chennai Surat Express','Express','Chennai Central','Surat','22:00','11:00','37h 0m',1620,'Mon,Thu'),
('17026','Surat Chennai Express','Express','Surat','Chennai Central','14:00','03:00','37h 0m',1620,'Tue,Fri'),
-- ── KOLKATA ↔ ALL CITIES ─────────────────────────────────────
('18001','Kolkata Ahmedabad Express','Express','Kolkata Howrah','Ahmedabad','14:05','16:10','26h 5m',2100,'Mon,Thu'),
('18002','Ahmedabad Kolkata Express','Express','Ahmedabad','Kolkata Howrah','17:25','19:40','26h 15m',2100,'Tue,Fri'),
('18003','Kolkata Jaipur Express','Express','Kolkata Howrah','Jaipur','23:55','11:00','35h 5m',1900,'Mon,Thu'),
('18004','Jaipur Kolkata Express','Express','Jaipur','Kolkata Howrah','21:45','08:30','34h 45m',1900,'Tue,Fri'),
('18005','Kolkata Lucknow Express','Express','Kolkata Howrah','Lucknow','14:40','05:50','15h 10m',972,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('18006','Lucknow Kolkata Express','Express','Lucknow','Kolkata Howrah','20:00','10:50','14h 50m',972,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('18007','Kolkata Nagpur Express','Express','Kolkata Howrah','Nagpur','21:30','14:00','16h 30m',1140,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('18008','Nagpur Kolkata Express','Express','Nagpur','Kolkata Howrah','15:30','08:00','16h 30m',1140,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('18009','Kolkata Kochi Express','Express','Kolkata Howrah','Ernakulam','15:00','14:30','47h 30m',2370,'Mon,Thu'),
('18010','Kochi Kolkata Express','Express','Ernakulam','Kolkata Howrah','20:00','21:30','49h 30m',2370,'Tue,Fri'),
('18011','Kolkata Visakhapatnam Express','Superfast','Kolkata Howrah','Visakhapatnam','22:55','16:15','17h 20m',1080,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('18012','Visakhapatnam Kolkata Express','Superfast','Visakhapatnam','Kolkata Howrah','18:40','12:15','17h 35m',1080,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('18013','Kolkata Patna Express','Express','Kolkata Howrah','Patna','07:00','13:00','6h 0m',528,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('18014','Patna Kolkata Express','Express','Patna','Kolkata Howrah','19:30','01:30','6h 0m',528,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('18015','Kolkata Bhubaneswar Shatabdi','Shatabdi','Kolkata Howrah','Bhubaneswar','06:25','10:35','4h 10m',440,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('18016','Bhubaneswar Kolkata Shatabdi','Shatabdi','Bhubaneswar','Kolkata Howrah','11:10','15:20','4h 10m',440,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('18017','Kolkata Guwahati Intercity','Superfast','Kolkata Howrah','Guwahati','15:50','07:50','16h 0m',994,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('18018','Guwahati Kolkata Intercity','Superfast','Guwahati','Kolkata Howrah','15:30','08:00','16h 30m',994,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('18019','Kolkata Amritsar Express','Express','Kolkata Howrah','Amritsar','22:00','18:00','44h 0m',2294,'Mon,Thu'),
('18020','Amritsar Kolkata Express','Express','Amritsar','Kolkata Howrah','19:00','15:00','44h 0m',2294,'Tue,Fri'),
('18021','Kolkata Bhopal Express','Express','Kolkata Howrah','Bhopal','22:00','15:00','41h 0m',1480,'Mon,Thu'),
('18022','Bhopal Kolkata Express','Express','Bhopal','Kolkata Howrah','18:00','11:00','41h 0m',1480,'Tue,Fri'),
('18023','Kolkata Surat Express','Express','Kolkata Howrah','Surat','21:00','12:00','39h 0m',2200,'Mon,Thu'),
('18024','Surat Kolkata Express','Express','Surat','Kolkata Howrah','22:00','13:00','39h 0m',2200,'Tue,Fri'),
('18025','Kolkata Chandigarh Express','Express','Kolkata Howrah','Chandigarh','22:00','20:00','46h 0m',2100,'Mon,Thu'),
('18026','Chandigarh Kolkata Express','Express','Chandigarh','Kolkata Howrah','21:00','19:00','46h 0m',2100,'Tue,Fri'),
('18027','Kolkata Coimbatore Express','Express','Kolkata Howrah','Coimbatore','08:00','12:00','52h 0m',2380,'Mon,Thu'),
('18028','Coimbatore Kolkata Express','Express','Coimbatore','Kolkata Howrah','20:00','22:00','50h 0m',2380,'Tue,Fri'),
-- ── INTER-CITY (NAGPUR/JAIPUR/LUCKNOW/PATNA/BHOPAL + MORE) ──
('19001','Nagpur Jaipur Express','Express','Nagpur','Jaipur','14:30','11:00','20h 30m',1200,'Mon,Thu'),
('19002','Jaipur Nagpur Express','Express','Jaipur','Nagpur','15:00','11:30','20h 30m',1200,'Tue,Fri'),
('19003','Nagpur Lucknow Express','Express','Nagpur','Lucknow','07:00','20:00','13h 0m',840,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('19004','Lucknow Nagpur Express','Express','Lucknow','Nagpur','21:00','10:00','13h 0m',840,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('19005','Nagpur Patna Express','Express','Nagpur','Patna','16:00','10:00','18h 0m',1100,'Mon,Thu'),
('19006','Patna Nagpur Express','Express','Patna','Nagpur','17:00','11:00','18h 0m',1100,'Tue,Fri'),
('19007','Nagpur Visakhapatnam Express','Express','Nagpur','Visakhapatnam','21:30','19:30','22h 0m',918,'Mon,Thu'),
('19008','Visakhapatnam Nagpur Express','Express','Visakhapatnam','Nagpur','22:00','20:00','22h 0m',918,'Tue,Fri'),
('19009','Nagpur Kochi Express','Express','Nagpur','Ernakulam','22:00','07:00','33h 0m',1484,'Mon,Thu'),
('19010','Kochi Nagpur Express','Express','Ernakulam','Nagpur','20:00','05:00','33h 0m',1484,'Tue,Fri'),
('19011','Nagpur Bhopal Express','Superfast','Nagpur','Bhopal','06:00','13:30','7h 30m',356,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('19012','Bhopal Nagpur Express','Superfast','Bhopal','Nagpur','21:00','04:30','7h 30m',356,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('19013','Nagpur Ahmedabad Express','Express','Nagpur','Ahmedabad','21:15','13:00','15h 45m',796,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('19014','Ahmedabad Nagpur Express','Express','Ahmedabad','Nagpur','15:00','07:00','16h 0m',796,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('19015','Nagpur Surat Express','Superfast','Nagpur','Surat','22:00','08:00','10h 0m',595,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('19016','Surat Nagpur Express','Superfast','Surat','Nagpur','09:00','19:00','10h 0m',595,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20001','Jaipur Lucknow Express','Express','Jaipur','Lucknow','21:00','09:00','12h 0m',597,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20002','Lucknow Jaipur Express','Express','Lucknow','Jaipur','20:00','08:00','12h 0m',597,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20003','Jaipur Patna Express','Express','Jaipur','Patna','22:30','14:00','15h 30m',1100,'Mon,Thu'),
('20004','Patna Jaipur Express','Express','Patna','Jaipur','15:00','07:00','16h 0m',1100,'Tue,Fri'),
('20005','Jaipur Bhopal Express','Superfast','Jaipur','Bhopal','05:45','13:30','7h 45m',560,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20006','Bhopal Jaipur Express','Superfast','Bhopal','Jaipur','20:00','03:45','7h 45m',560,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20007','Jaipur Ahmedabad Express','Superfast','Jaipur','Ahmedabad','07:45','13:30','5h 45m',615,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20008','Ahmedabad Jaipur Express','Superfast','Ahmedabad','Jaipur','16:45','22:30','5h 45m',615,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20009','Lucknow Patna Express','Express','Lucknow','Patna','07:00','12:30','5h 30m',484,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20010','Patna Lucknow Express','Express','Patna','Lucknow','14:00','19:30','5h 30m',484,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20011','Lucknow Bhopal Express','Superfast','Lucknow','Bhopal','21:30','07:00','9h 30m',560,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20012','Bhopal Lucknow Express','Superfast','Bhopal','Lucknow','22:00','07:30','9h 30m',560,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20013','Lucknow Ahmedabad Express','Express','Lucknow','Ahmedabad','22:00','14:30','16h 30m',1280,'Mon,Thu'),
('20014','Ahmedabad Lucknow Express','Express','Ahmedabad','Lucknow','13:00','05:30','16h 30m',1280,'Tue,Fri'),
('20015','Patna Bhopal Express','Express','Patna','Bhopal','21:00','12:00','15h 0m',1085,'Mon,Thu'),
('20016','Bhopal Patna Express','Express','Bhopal','Patna','22:00','13:00','15h 0m',1085,'Tue,Fri'),
('20017','Ahmedabad Patna Express','Express','Ahmedabad','Patna','17:30','14:00','20h 30m',1640,'Mon,Thu'),
('20018','Patna Ahmedabad Express','Express','Patna','Ahmedabad','15:00','11:30','20h 30m',1640,'Tue,Fri'),
('20019','Surat Jaipur Express','Superfast','Surat','Jaipur','22:00','12:00','14h 0m',885,'Mon,Thu'),
('20020','Jaipur Surat Express','Superfast','Jaipur','Surat','15:00','05:00','14h 0m',885,'Tue,Fri'),
('20021','Vadodara Jaipur Express','Superfast','Vadodara','Jaipur','21:30','08:00','10h 30m',770,'Mon,Thu'),
('20022','Jaipur Vadodara Express','Superfast','Jaipur','Vadodara','17:00','03:30','10h 30m',770,'Tue,Fri'),
('20023','Ahmedabad Bhopal Express','Express','Ahmedabad','Bhopal','22:30','08:00','9h 30m',640,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20024','Bhopal Ahmedabad Express','Express','Bhopal','Ahmedabad','21:30','07:00','9h 30m',640,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20025','Chandigarh Amritsar Express','Superfast','Chandigarh','Amritsar','07:00','09:30','2h 30m',201,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20026','Amritsar Chandigarh Express','Superfast','Amritsar','Chandigarh','18:00','20:30','2h 30m',201,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20027','Chandigarh Lucknow Express','Express','Chandigarh','Lucknow','21:00','08:00','11h 0m',658,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20028','Lucknow Chandigarh Express','Express','Lucknow','Chandigarh','22:00','09:00','11h 0m',658,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20029','Kochi Coimbatore Express','Superfast','Ernakulam','Coimbatore','06:00','09:00','3h 0m',210,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20030','Coimbatore Kochi Express','Superfast','Coimbatore','Ernakulam','18:30','21:30','3h 0m',210,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20031','Kochi Visakhapatnam Express','Express','Ernakulam','Visakhapatnam','08:00','10:00','26h 0m',1389,'Mon,Thu'),
('20032','Visakhapatnam Kochi Express','Express','Visakhapatnam','Ernakulam','21:00','23:00','26h 0m',1389,'Tue,Fri'),
('20033','Bhubaneswar Visakhapatnam Express','Superfast','Bhubaneswar','Visakhapatnam','07:00','12:30','5h 30m',440,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20034','Visakhapatnam Bhubaneswar Express','Superfast','Visakhapatnam','Bhubaneswar','14:00','19:30','5h 30m',440,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20035','Guwahati Patna Express','Express','Guwahati','Patna','08:30','06:00','21h 30m',1048,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20036','Patna Guwahati Express','Express','Patna','Guwahati','20:00','17:30','21h 30m',1048,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20037','Surat Ahmedabad Express','Superfast','Surat','Ahmedabad','06:00','08:30','2h 30m',265,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20038','Ahmedabad Surat Express','Superfast','Ahmedabad','Surat','18:00','20:30','2h 30m',265,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20039','Vadodara Ahmedabad Express','Superfast','Vadodara','Ahmedabad','07:00','08:30','1h 30m',113,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20040','Ahmedabad Vadodara Express','Superfast','Ahmedabad','Vadodara','17:00','18:30','1h 30m',113,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20041','Surat Vadodara Express','Superfast','Surat','Vadodara','09:00','10:30','1h 30m',130,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20042','Vadodara Surat Express','Superfast','Vadodara','Surat','19:00','20:30','1h 30m',130,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20043','Bhubaneswar Patna Express','Express','Bhubaneswar','Patna','22:00','09:00','11h 0m',660,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20044','Patna Bhubaneswar Express','Express','Patna','Bhubaneswar','21:00','08:00','11h 0m',660,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20045','Amritsar Lucknow Express','Express','Amritsar','Lucknow','20:00','09:00','13h 0m',750,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20046','Lucknow Amritsar Express','Express','Lucknow','Amritsar','22:00','11:00','13h 0m',750,'Mon,Tue,Wed,Thu,Fri,Sat,Sun'),
('20047','Amritsar Patna Express','Express','Amritsar','Patna','19:00','12:00','17h 0m',1200,'Mon,Thu'),
('20048','Patna Amritsar Express','Express','Patna','Amritsar','18:00','11:00','17h 0m',1200,'Tue,Fri'),
('20049','Guwahati Lucknow Express','Express','Guwahati','Lucknow','12:00','09:00','21h 0m',1380,'Mon,Thu'),
('20050','Lucknow Guwahati Express','Express','Lucknow','Guwahati','20:00','17:00','21h 0m',1380,'Tue,Fri'),
('20051','Guwahati Bhubaneswar Express','Express','Guwahati','Bhubaneswar','22:00','16:00','18h 0m',1200,'Mon,Thu'),
('20052','Bhubaneswar Guwahati Express','Express','Bhubaneswar','Guwahati','18:00','12:00','18h 0m',1200,'Tue,Fri'),
('20053','Visakhapatnam Patna Express','Express','Visakhapatnam','Patna','22:00','16:00','18h 0m',1200,'Mon,Thu'),
('20054','Patna Visakhapatnam Express','Express','Patna','Visakhapatnam','17:00','11:00','18h 0m',1200,'Tue,Fri'),
('20055','Coimbatore Visakhapatnam Express','Express','Coimbatore','Visakhapatnam','20:00','20:00','24h 0m',1450,'Mon,Fri'),
('20056','Visakhapatnam Coimbatore Express','Express','Visakhapatnam','Coimbatore','18:00','18:00','24h 0m',1450,'Wed,Sun'),
('20057','Kochi Bhubaneswar Express','Express','Ernakulam','Bhubaneswar','21:00','18:00','45h 0m',1890,'Mon,Thu'),
('20058','Bhubaneswar Kochi Express','Express','Bhubaneswar','Ernakulam','20:00','17:00','45h 0m',1890,'Tue,Fri'),
('20059','Kochi Guwahati Express','Express','Ernakulam','Guwahati','10:00','16:00','78h 0m',3100,'Mon,Fri'),
('20060','Guwahati Kochi Express','Express','Guwahati','Ernakulam','14:00','20:00','78h 0m',3100,'Wed,Sun');

-- ============================================================
--  SEAT CLASSES — Smart bulk insert by type & distance
-- ============================================================

-- RAJDHANI → 1A + 2A + 3A
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'1A','First AC',24,4.50 FROM trains WHERE type='Rajdhani';
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'2A','Second AC',96,2.80 FROM trains WHERE type='Rajdhani';
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'3A','Third AC',288,1.90 FROM trains WHERE type='Rajdhani';

-- SHATABDI → EC + CC
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'EC','Executive Chair Car',56,2.80 FROM trains WHERE type='Shatabdi';
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'CC','Chair Car',784,1.50 FROM trains WHERE type='Shatabdi';

-- VANDE BHARAT → EC + CC
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'EC','Executive Chair Car',56,3.00 FROM trains WHERE type='Vande Bharat';
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'CC','Chair Car',1072,1.60 FROM trains WHERE type='Vande Bharat';

-- DURONTO → 2A + 3A + SL
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'2A','Second AC',96,2.60 FROM trains WHERE type='Duronto';
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'3A','Third AC',288,1.80 FROM trains WHERE type='Duronto';
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'SL','Sleeper Class',576,0.80 FROM trains WHERE type='Duronto';

-- SHORT DISTANCE < 350km (Express/Superfast/Mail) → CC + 2A + SL
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'CC','Chair Car',1200,1.20 FROM trains
WHERE type IN ('Express','Superfast','Mail') AND distance_km < 350;
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'2A','Second AC',96,2.20 FROM trains
WHERE type IN ('Express','Superfast','Mail') AND distance_km < 350;
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'SL','Sleeper Class',576,0.65 FROM trains
WHERE type IN ('Express','Superfast','Mail') AND distance_km < 350;

-- MEDIUM DISTANCE 350–1000km → 2A + 3A + SL
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'2A','Second AC',96,2.40 FROM trains
WHERE type IN ('Express','Superfast','Mail') AND distance_km BETWEEN 350 AND 1000
AND id NOT IN (SELECT train_id FROM seat_classes WHERE class_code='2A');
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'3A','Third AC',288,1.70 FROM trains
WHERE type IN ('Express','Superfast','Mail') AND distance_km BETWEEN 350 AND 1000
AND id NOT IN (SELECT train_id FROM seat_classes WHERE class_code='3A');
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'SL','Sleeper Class',576,0.70 FROM trains
WHERE type IN ('Express','Superfast','Mail') AND distance_km BETWEEN 350 AND 1000
AND id NOT IN (SELECT train_id FROM seat_classes WHERE class_code='SL');

-- LONG DISTANCE > 1000km → 1A + 2A + 3A + SL
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'1A','First AC',24,4.20 FROM trains
WHERE type IN ('Express','Superfast','Mail') AND distance_km > 1000
AND id NOT IN (SELECT train_id FROM seat_classes WHERE class_code='1A');
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'2A','Second AC',96,2.40 FROM trains
WHERE type IN ('Express','Superfast','Mail') AND distance_km > 1000
AND id NOT IN (SELECT train_id FROM seat_classes WHERE class_code='2A');
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'3A','Third AC',288,1.70 FROM trains
WHERE type IN ('Express','Superfast','Mail') AND distance_km > 1000
AND id NOT IN (SELECT train_id FROM seat_classes WHERE class_code='3A');
INSERT INTO seat_classes (train_id,class_code,class_name,total_seats,fare_per_km)
SELECT id,'SL','Sleeper Class',576,0.70 FROM trains
WHERE type IN ('Express','Superfast','Mail') AND distance_km > 1000
AND id NOT IN (SELECT train_id FROM seat_classes WHERE class_code='SL');

-- ============================================================
--  FINAL VERIFICATION
-- ============================================================
SELECT CONCAT('✅ Total Trains      : ', COUNT(*)) AS result FROM trains;
SELECT CONCAT('✅ Total Seat Classes: ', COUNT(*)) AS result FROM seat_classes;
SELECT CONCAT('✅ Rajdhani          : ', COUNT(*)) AS result FROM trains WHERE type='Rajdhani';
SELECT CONCAT('✅ Shatabdi          : ', COUNT(*)) AS result FROM trains WHERE type='Shatabdi';
SELECT CONCAT('✅ Vande Bharat      : ', COUNT(*)) AS result FROM trains WHERE type='Vande Bharat';
SELECT CONCAT('✅ Duronto           : ', COUNT(*)) AS result FROM trains WHERE type='Duronto';
SELECT CONCAT('✅ Express           : ', COUNT(*)) AS result FROM trains WHERE type='Express';
SELECT CONCAT('✅ Superfast         : ', COUNT(*)) AS result FROM trains WHERE type='Superfast';
SELECT CONCAT('✅ Mail              : ', COUNT(*)) AS result FROM trains WHERE type='Mail';
SELECT CONCAT('✅ Unique Routes     : ', COUNT(DISTINCT CONCAT(source,destination))) AS result FROM trains;